# CONTEXTO DEL PROYECTO — Concentrado CFDI (para continuar en otra sesión)

> **Lee este archivo primero.** Resume qué es el proyecto, qué está hecho, qué falta y cómo seguir.
> Última actualización: 27-jul-2026. Branch de trabajo: `claude/excel-function-improvement-l8snqx`.

---

## 1. Qué es el proyecto
- **Cliente:** Emira Huerta · **Proveedor:** Jorge Nuñez López (monucaapps@gmail.com).
- **Parte 1** de la cotización **COT-2026-001** ($2,000 MXN): mejorar y automatizar un archivo Excel de **concentrado de CFDI** (recibos de nómina) de **8 hojas**, que mide la situación financiera de un contribuyente a partir de sus ingresos (XML del SAT) y gastos.
- Objetivo: **corregir errores + automatizar la carga de XML + DASHBOARD + gráficas**, reduciendo tiempo y errores.

## 2. Archivo de trabajo (IMPORTANTE)
- **`Concentrado_CFDI_AUTOMATIZADO.xlsm`** ← **este es el archivo VIVO** (tiene las consultas Power Query y las fórmulas conectadas). **Continuar sobre este.**
- `Concentrado_CFDI_AUTOMATIZADO.xlsx` = versión intermedia sin las consultas (referencia).
- `Concentrado_CFDI_CORREGIDO.xlsx` = solo correcciones (respaldo).
- El archivo original del cliente era `ejemplo2_concentrados_Fabi.xlsx`.

Los XML se guardan **fuera** del Excel, en carpetas por RFC:
`C:\Users\DELL\Documents\jorgenunez\EMIRA\CFDI\<RFC>\`  (ej. `...\CFDI\NULJ770313CL7\`).
El **contribuyente es el RECEPTOR** del CFDI.

## 3. Arquitectura / flujo de datos
```
XML (carpeta por RFC)
   │  Power Query
   ├──> Consulta1  (datos generales + totales)      ──> DASHBOARD
   └──> CFDI       (detallado, layout de fabi)       ──> ingresos ──> REGLA DE ORO
                                                                  └─> presupuesto
Gastos captura (manual)  ──> (pendiente) concentrado egresos
```
- **Dos consultas Power Query** en el .xlsm:
  - **`Consulta1`** — versión simple (totales). Alimenta el **DASHBOARD**. Código: `PowerQuery_CargaXML_CFDI.m`.
  - **`CFDI`** — versión detallada (parsea nómina12, 84 columnas con el mismo layout que `fabi`). Alimenta `ingresos`. Código: `PowerQuery_CargaXML_fabi_detallado.m`.
- Para refrescar: **Datos → Actualizar todo** (o el botón .xlsm, pendiente).

## 4. Estado por hoja (al 27-jul)
| Hoja | Estado | Fuente |
|---|---|---|
| DASHBOARD | ✅ automática | Consulta1 (XML) |
| ingresos | ✅ automática | CFDI (XML) — se hizo Ctrl+H `fabi!`→`CFDI!` |
| REGLA DE ORO | ✅ automática | vía `ingresos` |
| presupuesto | ✅ automática (salario) | vía `ingresos` |
| hoja de gastos | ✋ manual (por diseño) | captura del usuario |
| Gastos captura | ✋ manual/XML (por diseño) | captura del usuario |
| tabulador | ✋ tabla fija (ISR) | — |
| fabi | ⚠️ datos viejos de ejemplo | (ya no se usa; CFDI la reemplaza) |
| **detalle** | ⚠️ **PENDIENTE** — sigue apuntando a `fabi` viejo | legacy |
| **concentrado** | ⚠️ **PENDIENTE** — usa `detalle`, muestra datos viejos | legacy |

## 5. PENDIENTES (por dónde seguir mañana)

### 5.1 Ligar el flujo `concentrado` (2 fórmulas)
En la hoja **`concentrado`**, reemplazar y arrastrar de C a N:
- **Ingresos** (celda ENE de la fila "ingresos", normalmente C4):
  ```
  =SUMAR.SI(CFDI!$R:$R,C$2,CFDI!$CD:$CD)
  ```
- **Egresos** (celda ENE de "egresos", normalmente C5):
  ```
  =SUMAR.SI('Gastos captura'!$A$5:$A$504,C$2,'Gastos captura'!$D$5:$D$504)
  ```
  Seleccionar C4:C5 y arrastrar hasta la columna N. Saldo y saldo acumulado se calculan solos.

### 5.2 Limpiar la tabla dinámica vieja de `concentrado`
Debajo de la tabla del flujo hay una **tabla dinámica + gráfica + slicer "mes"** que se alimentan de `detalle` (legacy). Se pueden **eliminar** y dejar solo la tabla/gráfica del flujo nuevo. (La hoja `detalle` ya no es necesaria con este esquema.)

### 5.3 Selector de mes en `ingresos`
`ingresos` muestra **un mes a la vez** en la celda **H5** (número 1-12).
- Agregar dropdown: H5 → Datos → Validación de datos → Lista → `1,2,3,4,5,6,7,8,9,10,11,12`.
- Que el nombre del mes (H6) se acomode solo: `=ELEGIR(H5,"ENE","FEB","MZO","ABR","MAY","JUN","JUL","AGO","SEPT","OCT","NOV","DIC")`

### 5.4 Menú de RFC en DASHBOARD (celda C4)
El dropdown apunta a `fabi` (vacío). Cambiarlo a la consulta:
- Opción simple: C4 → Validación de datos → Origen `=Consulta1!$F$2:$F$1000`.
- Opción lista limpia: en N1 `=UNICOS(FILTRAR(Consulta1!F2:F1000,Consulta1!F2:F1000<>""))` y en C4 Origen `=$N$1#`.

### 5.5 Botón "Actualizar" (.xlsm)
Insertar un botón (Programador → Insertar → Botón) con la macro:
```vba
Sub Actualizar_XML()
    ThisWorkbook.RefreshAll
    MsgBox "Datos actualizados", vbInformation
End Sub
```

### 5.6 (Opcional) Afinar mapeo de conceptos en el parser CFDI
El parser `CFDI` (nómina12) es v1. Si algún concepto cae en columna equivocada, revisar el mapeo por `TipoPercepcion`/`TipoDeduccion` en `PowerQuery_CargaXML_fabi_detallado.m`. Ver §7.

## 6. Mapeo de columnas de la hoja CFDI (= layout de `fabi`)
Posiciones clave (letra de columna):
- **F** = RFC Receptor · **R** = mes (número) · **S** = Fecha de Pago
- **W** = Curp · **X** = NSS · **AG** = SBC · **AH** = SDI
- Percepciones (gravado): **AJ**=010 puntualidad · **AL**=049 asistencia · **AN**=003 PTU · **AP**=002 aguinaldo · **AT/AU**=020 prima dom · **AV**=001 sueldo · **AX**=028 comisión · **BB**=038 gratif · **BD**=021 prima vac
- **BF** = PERCEPCIONES (total)
- Deducciones: **BP**=002 ISPT/ISR · **BQ**=010+009 INFONAVIT · **BT**=011 FONACOT · **BU**=001 IMSS · **BX**=018 ahorro · **BZ**=009 préstamo vivienda
- **CA** = DEDUCCIONES (total) · **CD/CE** = NETO
- **CF** = Validacion_RFC (OK/REVISAR)
`ingresos` usa SUMIF sobre estas columnas por el mes de H5.

## 7. Notas técnicas / lecciones aprendidas (para no repetir errores)
- **NO reescribir el .xlsx/.xlsm con librerías genéricas (openpyxl):** se pierden tablas dinámicas, slicers, formato condicional y las consultas Power Query. Para editar estructura, hacer **cirugía de XML** (descomprimir, editar, recomprimir) o editar dentro de Excel.
- **Las conexiones Power Query se crean DENTRO de Excel** (no se pueden pre-incrustar de forma segura desde fuera).
- **Al TECLEAR fórmulas en Excel en español** usar nombres en español: `SI.ERROR`, `SUMAPRODUCTO`, `SUMAR.SI`, `ELEGIR`, `UNICOS`, `FILTRAR`. (Las guardadas en el archivo pueden ir en inglés; Excel las traduce.)
- **Aviso "[Grupo]" deshabilita el menú Datos:** ocurre si hay varias hojas seleccionadas. Solución: clic en una sola pestaña / Desagrupar. En el XML: solo **una** hoja con `tabSelected="1"`.
- **Aviso de "recuperar contenido" (reparación):** lo causó (a) `app.xml` con conteo de hojas desactualizado, (b) celdas con `<v></v>` vacío, (c) validación de datos con referencia a otra hoja, y (d) una **Tabla de Excel (ListObject) inyectada** → por eso "Gastos captura" quedó como **rango normal con SUMIFS de rango fijo** (no como tabla).
- **XML CFDI 4.0 nómina:** el contribuyente es el **Receptor**; los conceptos vienen en `nomina12:Percepciones/Percepcion` (TipoPercepcion, ImporteGravado/Exento) y `nomina12:Deducciones/Deduccion` (TipoDeduccion, Importe). `Total` del comprobante = NETO.
- La cantidad de XML **varía** (asalariados semanales ≈52; RESICO variable): las consultas funcionan con cualquier cantidad.

## 8. Inventario del repo
- `Concentrado_CFDI_AUTOMATIZADO.xlsm` — **archivo vivo** (con consultas).
- `PowerQuery_CargaXML_CFDI.m` — consulta simple (Consulta1 → DASHBOARD).
- `PowerQuery_CargaXML_fabi_detallado.m` — consulta detallada nómina12 (CFDI → ingresos).
- `Tutorial_Excel_Concentrado_CFDI.pdf` — guía de uso (incluye puesta en marcha).
- `Cotizacion_COT-2026-001_AMPLIADA.(md|pdf)` — cotización con las dudas aclaradas.
- `Aclaraciones_cliente_segun_audios.md` — respuestas a las 5 dudas del cliente.
- `INFORME_correcciones_Excel.md` — las 112 celdas corregidas.
- `ENTREGA_Parte1.md` — resumen de entrega de la Parte 1.
- `transcribir_mis_audios.py` / `transcribir_audios.py` — transcriptores de audio.
- `Concentrado_CFDI_CORREGIDO.xlsx`, `Concentrado_CFDI_AUTOMATIZADO.xlsx` — respaldos/etapas.

## 9. Cómo continuar mañana (checklist rápido)
1. `git pull` del branch `claude/excel-function-improvement-l8snqx` (o descargar los archivos del repo).
2. Abrir **`Concentrado_CFDI_AUTOMATIZADO.xlsm`**. Si pide habilitar contenido/edición, aceptar.
3. Ajustar la carpeta de XML en cada consulta (Datos → Consultas y conexiones → Editar) a la ruta de la nueva máquina.
4. **Datos → Actualizar todo.**
5. Retomar los **PENDIENTES §5** (empezar por 5.1 ligar `concentrado`).

## 10. Para retomar en otro chat
Pega esto al inicio del nuevo chat:
> "Continúo el proyecto del **Concentrado CFDI (Parte 1, COT-2026-001)**. El estado y los pendientes están en el archivo **`CONTEXTO_Y_CONTINUACION.md`** del branch `claude/excel-function-improvement-l8snqx` del repo `monucaapps/hojaemira`. El archivo vivo es `Concentrado_CFDI_AUTOMATIZADO.xlsm`. Sigue desde los PENDIENTES §5."
