// =====================================================================
//  Power Query (M) — Carga DETALLADA de XML de nómina (nómina12) -> hoja fabi
//  Llena las columnas que usan ingresos / REGLA DE ORO / presupuesto.
//  Autor: Jorge Nuñez López
// ---------------------------------------------------------------------
//  Se carga sobre la hoja fabi (ver instrucciones). El contribuyente es
//  el RECEPTOR del CFDI. Funciona con cualquier cantidad de XML.
// =====================================================================
let
    CarpetaXML  = "C:\Users\DELL\Documents\jorgenunez\EMIRA\CFDI\NULJ770313CL7",
    RFCEsperado = "",
    RFCCarpeta  = if RFCEsperado <> "" then RFCEsperado
                  else List.Last(Text.Split(Text.TrimEnd(CarpetaXML, "\"), "\")),

    Origen  = Folder.Files(CarpetaXML),
    SoloXML = Table.SelectRows(Origen, each Text.Lower([Extension]) = ".xml"),

    fnNum = (x) as number => if x = null then 0 else (try Number.From(x) otherwise 0),
    fnAttr = (nodo as any, nombre as text) as any =>
        let a = try nodo[Attributes] otherwise null in
        if a = null then null else
        let f = Table.SelectRows(a, each [Name] = nombre) in
        if Table.RowCount(f) > 0 then f{0}[Value] else null,
    fnHijo = (tabla as any, nombre as text) as any =>
        if tabla = null then null else
        let f = Table.SelectRows(tabla, each [Name] = nombre) in
        if Table.RowCount(f) > 0 then f{0} else null,
    fnSumBy = (parent as any, childName as text, tipoAttr as text, tipoVal as text, sumAttr as text) as number =>
        if parent = null then 0 else
        let rows = try parent[Value] otherwise null in
        if rows = null then 0 else
        let hijos = Table.SelectRows(rows, each [Name] = childName),
            match = Table.SelectRows(hijos, (r) => fnAttr(r, tipoAttr) = tipoVal),
            vals  = List.Transform(Table.ToRecords(match), (r) => fnNum(fnAttr(r, sumAttr)))
        in (List.Sum(vals) ?? 0),

    fnParse = (contenido as binary) as record =>
        let
            doc        = Xml.Document(contenido),
            compRow    = doc{0},
            compTbl    = compRow[Value],
            emisor     = fnHijo(compTbl, "Emisor"),
            receptor   = fnHijo(compTbl, "Receptor"),
            compl      = fnHijo(compTbl, "Complemento"),
            complTbl   = if compl = null then null else compl[Value],
            nomina     = if complTbl = null then null else fnHijo(complTbl, "Nomina"),
            nominaTbl  = if nomina = null then null else nomina[Value],
            nomEmisor  = if nominaTbl = null then null else fnHijo(nominaTbl, "Emisor"),
            nomReceptor= if nominaTbl = null then null else fnHijo(nominaTbl, "Receptor"),
            perc       = if nominaTbl = null then null else fnHijo(nominaTbl, "Percepciones"),
            ded        = if nominaTbl = null then null else fnHijo(nominaTbl, "Deducciones"),
            otros      = if nominaTbl = null then null else fnHijo(nominaTbl, "OtrosPagos"),
            timbre     = if complTbl = null then null else fnHijo(complTbl, "TimbreFiscalDigital"),
            Fecha      = fnAttr(compRow, "Fecha"),
            FechaPago  = if nomina = null then null else fnAttr(nomina, "FechaPago"),
            Mes        = try Date.Month(Date.From(if FechaPago<>null then FechaPago else Fecha)) otherwise null,
            rfcRec     = fnAttr(receptor, "Rfc"),
            pG = (t) => fnSumBy(perc, "Percepcion", "TipoPercepcion", t, "ImporteGravado"),
            pE = (t) => fnSumBy(perc, "Percepcion", "TipoPercepcion", t, "ImporteExento"),
            dD = (t) => fnSumBy(ded,  "Deduccion",  "TipoDeduccion",  t, "Importe"),
            oO = (t) => fnSumBy(otros,"OtroPago",   "TipoOtroPago",   t, "Importe")
        in
            [
                #"N°" = null,
                #"UUID" = fnAttr(timbre,"UUID"),
                #"Fecha Emision" = Fecha,
                #"Fecha Timbrado" = fnAttr(timbre,"FechaTimbrado"),
                #"Version" = fnAttr(compRow,"Version"),
                #"RFC Receptor" = rfcRec,
                #"Razon Social Emisor" = fnAttr(emisor,"Nombre"),
                #"Regimen Fiscal" = fnAttr(emisor,"RegimenFiscal"),
                #"PACCertificador" = fnAttr(timbre,"RfcProvCertif"),
                #"Estatus" = "VIGENTE",
                #"Tipo de Comprobante" = fnAttr(compRow,"TipoDeComprobante"),
                #"Serie" = fnAttr(compRow,"Serie"),
                #"Folio" = fnAttr(compRow,"Folio"),
                #"Lugar Expedicion" = fnAttr(compRow,"LugarExpedicion"),
                #"Metodo de Pago" = fnAttr(compRow,"MetodoPago"),
                #"Moneda" = fnAttr(compRow,"Moneda"),
                #"Tipo Nomina" = fnAttr(nomina,"TipoNomina"),
                #"mes" = Mes,
                #"Fecha de Pago" = FechaPago,
                #"Total de Deducciones" = fnNum(fnAttr(nomina,"TotalDeducciones")),
                #"Total de Otros Pagos" = fnNum(fnAttr(nomina,"TotalOtrosPagos")),
                #"Registro Patronal" = fnAttr(nomEmisor,"RegistroPatronal"),
                #"Curp" = fnAttr(nomReceptor,"Curp"),
                #"NumSeguridadSocial" = fnAttr(nomReceptor,"NumSeguridadSocial"),
                #"Antiguedad" = fnAttr(nomReceptor,"Antigüedad"),
                #"TipoJornada" = fnAttr(nomReceptor,"TipoJornada"),
                #"TipoRegimen" = fnAttr(nomReceptor,"TipoRegimen"),
                #"NumEmpleado" = fnAttr(nomReceptor,"NumEmpleado"),
                #"RiesgoPuesto" = fnAttr(nomReceptor,"RiesgoPuesto"),
                #"PeriodicidadPago" = fnAttr(nomReceptor,"PeriodicidadPago"),
                #"Banco" = fnAttr(nomReceptor,"Banco"),
                #"CuentaBancaria" = fnAttr(nomReceptor,"CuentaBancaria"),
                #"SalarioBaseCotApor" = fnNum(fnAttr(nomReceptor,"SalarioBaseCotApor")),
                #"SalarioDiarioIntegrado" = fnNum(fnAttr(nomReceptor,"SalarioDiarioIntegrado")),
                #"019 HORAS EXTRAS" = pG("019")+pE("019"),
                #"010 PUNTUALIDAD Gravado" = pG("010"),
                #"010 PUNTUALIDAD Exento" = pE("010"),
                #"049 ASISTENCIA Gravado" = pG("049"),
                #"049 ASISTENCIA Exento" = pE("049"),
                #"003 PTU Gravado" = pG("003"),
                #"003 PTU Exento" = pE("003"),
                #"002 AGUINALDO Gravado" = pG("002"),
                #"002 AGUINALDO Exento" = pE("002"),
                #"029 Vales Gravado" = pG("029"),
                #"029 Vales Exento" = pE("029"),
                #"020 Prima Dominical Gravado" = pG("020"),
                #"020 Prima Dominical Exento" = pE("020"),
                #"001 SUELDO Gravado" = pG("001"),
                #"001 SUELDO Exento" = pE("001"),
                #"028 COMISION Gravado" = pG("028"),
                #"028 COMISION Exento" = pE("028"),
                #"005 Fondo Ahorro Gravado" = pG("005"),
                #"005 Fondo Ahorro Exento" = pE("005"),
                #"038 Gratificaciones Gravado" = pG("038"),
                #"038 Gratificaciones Exento" = pE("038"),
                #"021 Prima Vac Gravado" = pG("021"),
                #"021 Prima Vac Exento" = pE("021"),
                #"PERCEPCIONES" = fnNum(fnAttr(nomina,"TotalPercepciones")),
                #"002 Subsidio Empleo" = oO("002"),
                #"999 Ajuste Moneda P" = 0,
                #"007 ISR Ajustado" = 0,
                #"004 ISPT a Compensar" = 0,
                #"OP Subsidio Causado" = 0,
                #"OP Saldo Favor" = 0,
                #"OP Anio" = null,
                #"OP Remanente" = 0,
                #"OTROS PAGOS" = fnNum(fnAttr(nomina,"TotalOtrosPagos")),
                #"002 ISPT" = dD("002"),
                #"010 INFONAVIT" = dD("009")+dD("010"),
                #"004 Ajuste Moneda D" = dD("004"),
                #"007 Pension Alimenticia" = dD("007"),
                #"011 FONACOT" = dD("011"),
                #"001 IMSS" = dD("001"),
                #"101 ISPT A CARGO" = 0,
                #"107 Ajuste Subsidio" = 0,
                #"018 Ahorro" = dD("018"),
                #"021 Aport IMSS" = dD("021"),
                #"009 Prestamo Vivienda" = dD("009"),
                #"DEDUCCIONES" = fnNum(fnAttr(nomina,"TotalDeducciones")),
                #"02 Dias Incapacidad" = 0,
                #"INCAPACIDADES" = 0,
                #"NETO" = fnNum(fnAttr(compRow,"Total")),
                #"NETO2" = fnNum(fnAttr(compRow,"Total")),
                #"Validacion_RFC" = if rfcRec=null then "SIN RFC" else if Text.Upper(rfcRec)=Text.Upper(RFCCarpeta) then "OK" else "REVISAR"
            ],

    ConDatos  = Table.AddColumn(SoloXML, "R", each fnParse([Content])),
    Expandida = Table.ExpandRecordColumn(ConDatos, "R", {"N°", "UUID", "Fecha Emision", "Fecha Timbrado", "Version", "RFC Receptor", "Razon Social Emisor", "Regimen Fiscal", "PACCertificador", "Estatus", "Tipo de Comprobante", "Serie", "Folio", "Lugar Expedicion", "Metodo de Pago", "Moneda", "Tipo Nomina", "mes", "Fecha de Pago", "Total de Deducciones", "Total de Otros Pagos", "Registro Patronal", "Curp", "NumSeguridadSocial", "Antiguedad", "TipoJornada", "TipoRegimen", "NumEmpleado", "RiesgoPuesto", "PeriodicidadPago", "Banco", "CuentaBancaria", "SalarioBaseCotApor", "SalarioDiarioIntegrado", "019 HORAS EXTRAS", "010 PUNTUALIDAD Gravado", "010 PUNTUALIDAD Exento", "049 ASISTENCIA Gravado", "049 ASISTENCIA Exento", "003 PTU Gravado", "003 PTU Exento", "002 AGUINALDO Gravado", "002 AGUINALDO Exento", "029 Vales Gravado", "029 Vales Exento", "020 Prima Dominical Gravado", "020 Prima Dominical Exento", "001 SUELDO Gravado", "001 SUELDO Exento", "028 COMISION Gravado", "028 COMISION Exento", "005 Fondo Ahorro Gravado", "005 Fondo Ahorro Exento", "038 Gratificaciones Gravado", "038 Gratificaciones Exento", "021 Prima Vac Gravado", "021 Prima Vac Exento", "PERCEPCIONES", "002 Subsidio Empleo", "999 Ajuste Moneda P", "007 ISR Ajustado", "004 ISPT a Compensar", "OP Subsidio Causado", "OP Saldo Favor", "OP Anio", "OP Remanente", "OTROS PAGOS", "002 ISPT", "010 INFONAVIT", "004 Ajuste Moneda D", "007 Pension Alimenticia", "011 FONACOT", "001 IMSS", "101 ISPT A CARGO", "107 Ajuste Subsidio", "018 Ahorro", "021 Aport IMSS", "009 Prestamo Vivienda", "DEDUCCIONES", "02 Dias Incapacidad", "INCAPACIDADES", "NETO", "NETO2", "Validacion_RFC"}),
    SoloCols  = Table.SelectColumns(Expandida, {"N°", "UUID", "Fecha Emision", "Fecha Timbrado", "Version", "RFC Receptor", "Razon Social Emisor", "Regimen Fiscal", "PACCertificador", "Estatus", "Tipo de Comprobante", "Serie", "Folio", "Lugar Expedicion", "Metodo de Pago", "Moneda", "Tipo Nomina", "mes", "Fecha de Pago", "Total de Deducciones", "Total de Otros Pagos", "Registro Patronal", "Curp", "NumSeguridadSocial", "Antiguedad", "TipoJornada", "TipoRegimen", "NumEmpleado", "RiesgoPuesto", "PeriodicidadPago", "Banco", "CuentaBancaria", "SalarioBaseCotApor", "SalarioDiarioIntegrado", "019 HORAS EXTRAS", "010 PUNTUALIDAD Gravado", "010 PUNTUALIDAD Exento", "049 ASISTENCIA Gravado", "049 ASISTENCIA Exento", "003 PTU Gravado", "003 PTU Exento", "002 AGUINALDO Gravado", "002 AGUINALDO Exento", "029 Vales Gravado", "029 Vales Exento", "020 Prima Dominical Gravado", "020 Prima Dominical Exento", "001 SUELDO Gravado", "001 SUELDO Exento", "028 COMISION Gravado", "028 COMISION Exento", "005 Fondo Ahorro Gravado", "005 Fondo Ahorro Exento", "038 Gratificaciones Gravado", "038 Gratificaciones Exento", "021 Prima Vac Gravado", "021 Prima Vac Exento", "PERCEPCIONES", "002 Subsidio Empleo", "999 Ajuste Moneda P", "007 ISR Ajustado", "004 ISPT a Compensar", "OP Subsidio Causado", "OP Saldo Favor", "OP Anio", "OP Remanente", "OTROS PAGOS", "002 ISPT", "010 INFONAVIT", "004 Ajuste Moneda D", "007 Pension Alimenticia", "011 FONACOT", "001 IMSS", "101 ISPT A CARGO", "107 Ajuste Subsidio", "018 Ahorro", "021 Aport IMSS", "009 Prestamo Vivienda", "DEDUCCIONES", "02 Dias Incapacidad", "INCAPACIDADES", "NETO", "NETO2", "Validacion_RFC"}),
    Tipada    = Table.TransformColumnTypes(SoloCols, {{"Total de Deducciones", type number}, {"Total de Otros Pagos", type number}, {"SalarioBaseCotApor", type number}, {"SalarioDiarioIntegrado", type number}, {"PERCEPCIONES", type number}, {"OTROS PAGOS", type number}, {"DEDUCCIONES", type number}, {"NETO", type number}, {"NETO2", type number}, {"mes", type number}, {"019 HORAS EXTRAS", type number}, {"010 PUNTUALIDAD Gravado", type number}, {"010 PUNTUALIDAD Exento", type number}, {"049 ASISTENCIA Gravado", type number}, {"049 ASISTENCIA Exento", type number}, {"003 PTU Gravado", type number}, {"003 PTU Exento", type number}, {"002 AGUINALDO Gravado", type number}, {"002 AGUINALDO Exento", type number}, {"029 Vales Gravado", type number}, {"029 Vales Exento", type number}, {"020 Prima Dominical Gravado", type number}, {"020 Prima Dominical Exento", type number}, {"001 SUELDO Gravado", type number}, {"001 SUELDO Exento", type number}, {"028 COMISION Gravado", type number}, {"028 COMISION Exento", type number}, {"005 Fondo Ahorro Gravado", type number}, {"005 Fondo Ahorro Exento", type number}, {"038 Gratificaciones Gravado", type number}, {"038 Gratificaciones Exento", type number}, {"021 Prima Vac Gravado", type number}, {"021 Prima Vac Exento", type number}, {"002 Subsidio Empleo", type number}, {"002 ISPT", type number}, {"010 INFONAVIT", type number}, {"004 Ajuste Moneda D", type number}, {"007 Pension Alimenticia", type number}, {"011 FONACOT", type number}, {"001 IMSS", type number}, {"018 Ahorro", type number}, {"021 Aport IMSS", type number}, {"009 Prestamo Vivienda", type number}})
in
    Tipada
