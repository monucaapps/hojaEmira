// =====================================================================
//  Power Query (lenguaje M) — Carga de XML CFDI 4.0 por carpeta / RFC
//  Herramienta: Concentrado de CFDI
//  Autor: Jorge Nuñez López
// ---------------------------------------------------------------------
//  QUÉ HACE:
//   - Lee TODOS los .xml de una carpeta (los recibos CFDI 4.0 de un RFC).
//   - Extrae los datos principales de cada comprobante (UUID, fechas,
//     RFC emisor/receptor, tipo, total, moneda, serie, folio, método de
//     pago, y — si es nómina — fecha de pago y totales de percepciones,
//     deducciones y otros pagos).
//   - Calcula el MES (para vincular con las demás hojas).
//   - VALIDA que el RFC del XML coincida con el RFC esperado (el de la
//     carpeta), y marca "OK" o "REVISAR".
//   - Funciona con CUALQUIER cantidad de XML (52 semanales, RESICO, etc.).
//
//  CÓMO USARLO (una sola vez):
//   1) En Excel de escritorio (Windows) abre: Datos > Obtener datos >
//      Iniciar el Editor de Power Query.
//   2) Menú Inicio > Consulta nueva > Origen > Consulta en blanco.
//   3) Ver > Editor avanzado. Borra lo que haya y PEGA todo este código.
//   4) Ajusta las dos primeras líneas (CarpetaXML y RFCEsperado).
//   5) Cerrar y cargar. Se creará una tabla con todos los CFDI.
//   6) Para actualizar cuando lleguen nuevos XML: Datos > Actualizar todo.
//
//  NOTA: el desglose de percepciones/deducciones por CONCEPTO individual
//  (complemento nómina12 detallado) es alcance aparte; aquí se traen los
//  TOTALES de nómina, que es lo que alimenta ingresos/egresos.
// =====================================================================

let
    // ==== 1) CONFIGURA AQUÍ ====
    // Carpeta del contribuyente = el RFC del RECEPTOR (el empleado/contribuyente).
    // Estructura recomendada (nombra la carpeta con ese RFC):
    //   C:\Users\DELL\Documents\jorgenunez\EMIRA\CFDI\NULJ770313CL7\   (los .xml adentro)
    CarpetaXML  = "C:\Users\DELL\Documents\jorgenunez\EMIRA\CFDI\NULJ770313CL7",
    RFCEsperado = "",   // RFC del RECEPTOR; si lo dejas "", usa el nombre de la carpeta

    RFCCarpeta = if RFCEsperado <> "" then RFCEsperado
                 else List.Last(Text.Split(Text.TrimEnd(CarpetaXML, "\"), "\")),

    // ==== 2) LEE LOS ARCHIVOS ====
    Origen   = Folder.Files(CarpetaXML),
    SoloXML  = Table.SelectRows(Origen, each Text.Lower([Extension]) = ".xml"),

    // ---- función auxiliar: valor de un atributo de un nodo ----
    fnAttr = (nodo as any, nombre as text) as any =>
        let a = try nodo[Attributes] otherwise null
        in  if a = null then null
            else let f = Table.SelectRows(a, each [Name] = nombre)
                 in  if Table.RowCount(f) > 0 then f{0}[Value] else null,

    // ---- función auxiliar: primer elemento hijo con cierto nombre local ----
    fnHijo = (tabla as any, nombre as text) as any =>
        if tabla = null then null
        else let f = Table.SelectRows(tabla, each [Name] = nombre)
             in  if Table.RowCount(f) > 0 then f{0} else null,

    // ---- función que procesa UN comprobante ----
    fnParse = (contenido as binary) as record =>
        let
            doc       = Xml.Document(contenido),
            compRow   = doc{0},                              // cfdi:Comprobante
            compTbl   = compRow[Value],                      // hijos del comprobante
            emisor    = fnHijo(compTbl, "Emisor"),
            receptor  = fnHijo(compTbl, "Receptor"),
            compl     = fnHijo(compTbl, "Complemento"),
            complTbl  = if compl = null then null else compl[Value],
            nomina    = if complTbl = null then null else fnHijo(complTbl, "Nomina"),
            timbre    = if complTbl = null then null else fnHijo(complTbl, "TimbreFiscalDigital"),

            Fecha     = fnAttr(compRow, "Fecha"),
            FechaPago = if nomina = null then null else fnAttr(nomina, "FechaPago"),
            FechaMes  = if FechaPago <> null then FechaPago else Fecha,
            Mes       = try Date.Month(DateTime.From(FechaMes)) otherwise null,

            rfcRec    = fnAttr(receptor, "Rfc")
        in
            [
                UUID              = fnAttr(timbre, "UUID"),
                Fecha_Emision     = Fecha,
                Version           = fnAttr(compRow, "Version"),
                RFC_Emisor        = fnAttr(emisor, "Rfc"),
                Nombre_Emisor     = fnAttr(emisor, "Nombre"),
                RFC_Receptor      = rfcRec,
                Nombre_Receptor   = fnAttr(receptor, "Nombre"),
                Tipo_Comprobante  = fnAttr(compRow, "TipoDeComprobante"),
                Serie             = fnAttr(compRow, "Serie"),
                Folio             = fnAttr(compRow, "Folio"),
                Metodo_Pago       = fnAttr(compRow, "MetodoPago"),
                Lugar_Expedicion  = fnAttr(compRow, "LugarExpedicion"),
                Moneda            = fnAttr(compRow, "Moneda"),
                Total             = fnAttr(compRow, "Total"),
                Fecha_Pago        = FechaPago,
                Mes               = Mes,
                Percepciones      = if nomina = null then null else fnAttr(nomina, "TotalPercepciones"),
                Deducciones       = if nomina = null then null else fnAttr(nomina, "TotalDeducciones"),
                Otros_Pagos       = if nomina = null then null else fnAttr(nomina, "TotalOtrosPagos"),
                Validacion_RFC    = if rfcRec = null then "SIN RFC"
                                    else if Text.Upper(rfcRec) = Text.Upper(RFCCarpeta) then "OK"
                                    else "REVISAR"
            ],

    // ==== 3) APLICA EL PARSEO A CADA ARCHIVO ====
    ConDatos  = Table.AddColumn(SoloXML, "CFDI", each fnParse([Content])),
    Expandida = Table.ExpandRecordColumn(ConDatos, "CFDI",
        {"UUID","Fecha_Emision","Version","RFC_Emisor","Nombre_Emisor","RFC_Receptor",
         "Nombre_Receptor","Tipo_Comprobante","Serie","Folio","Metodo_Pago",
         "Lugar_Expedicion","Moneda","Total","Fecha_Pago","Mes",
         "Percepciones","Deducciones","Otros_Pagos","Validacion_RFC"}),

    SoloCols  = Table.SelectColumns(Expandida,
        {"UUID","Fecha_Emision","Version","RFC_Emisor","Nombre_Emisor","RFC_Receptor",
         "Nombre_Receptor","Tipo_Comprobante","Serie","Folio","Metodo_Pago",
         "Lugar_Expedicion","Moneda","Total","Fecha_Pago","Mes",
         "Percepciones","Deducciones","Otros_Pagos","Validacion_RFC"}),

    // ==== 4) TIPOS ====
    Tipada = Table.TransformColumnTypes(SoloCols,{
        {"Total", type number}, {"Percepciones", type number},
        {"Deducciones", type number}, {"Otros_Pagos", type number},
        {"Mes", Int64.Type}})
in
    Tipada
