# Entrega — Parte 1 · Concentrado CFDI (COT-2026-001)

**Proveedor:** Jorge Nuñez López · **Cliente:** Emira Huerta
**Fecha de entrega:** 26 de julio de 2026

Este documento resume todo lo entregado de la **Parte 1** y cómo se cubre cada concepto cotizado.

---

## Archivos entregados

| Archivo | Qué es |
|---|---|
| `Concentrado_CFDI_AUTOMATIZADO.xlsx` | **Herramienta final**: archivo corregido + automatizado (10 hojas). |
| `Concentrado_CFDI_CORREGIDO.xlsx` | Versión solo con las correcciones (respaldo, sin las hojas nuevas). |
| `PowerQuery_CargaXML_CFDI.m` | Código de Power Query para cargar los XML CFDI 4.0 por carpeta/RFC. |
| `Tutorial_Excel_Concentrado_CFDI.pdf` | Guía de uso, hoja por hoja, incluida la carga de XML. |
| `Cotizacion_COT-2026-001_AMPLIADA.pdf` | Cotización con la explicación ampliada de las dudas del cliente. |
| `Aclaraciones_cliente_segun_audios.md` | Respuestas puntuales a las 5 dudas del cliente. |
| `INFORME_correcciones_Excel.md` | Detalle técnico de las 112 celdas corregidas. |

---

## Cómo se cubre cada concepto de la cotización

**1. Diagnóstico y corrección de errores de fórmula — $700** ✅
- **60 errores `#REF!` → 0** (verificado).
- `VLOOKUP` y ~22 divisiones protegidas con `IFERROR` (adiós `#N/A` y `#DIV/0!`).
- Rangos `SUMIF` alineados; vínculo externo roto eliminado.
- Se corrigió además una relación colgante interna (calcChain).
- **Se conservan intactas** las tablas dinámicas, segmentaciones (slicers) y gráficas originales.

**2. Hoja DASHBOARD — $800** ✅
- Menú desplegable por **RFC** y por **mes**.
- Indicadores: **ingresos, deducciones, balance/neto, no. de comprobantes, por revisar**.
- Tabla de los **12 meses** + **gráficas** (barras y pastel).
- Se agregó también la hoja **“Gastos captura”**: tabla flexible con **llenado manual o XML**, **conceptos que se pueden agregar libremente**, categorías (Básico/Lujo/Ahorro), totales y % automáticos, y gráfica de pastel — atendiendo lo que el cliente aclaró en los audios.

**3. Automatización de carga de XML CFDI 4.0 — $400** ✅
- Código Power Query (`.m`) que lee una carpeta de XML, extrae los datos clave, calcula el **mes** y **valida el RFC** (marca `OK` / `REVISAR`).
- Funciona con **cualquier cantidad** de XML (asalariados semanales, RESICO, etc.).

**4. Documentación, instrucciones, pruebas y entrega — $100** ✅
- Tutorial en PDF (hoja por hoja + carga de XML) y este documento de entrega.
- Pruebas de integridad: archivo validado (todas las hojas cargan, XML bien formados, sin referencias rotas ni relaciones colgantes).

---

## Estructura final del archivo (10 hojas)

1. **DASHBOARD** *(nueva)* — tablero por RFC y mes con indicadores y gráficas.
2. **fabi** — datos de los CFDI (materia prima, se llena con los XML).
3. **ingresos** — concentrado de ingresos con indicadores %.
4. **hoja de gastos** — concentrado de gastos original (se conserva).
5. **presupuesto** — formato de presupuesto mensual (imprimible).
6. **REGLA DE ORO** — correcto vs. real + fondo de emergencia 3 y 6 meses.
7. **detalle** — entradas y salidas por mes (con gráfica).
8. **concentrado** — flujo mensual acumulado del año (con gráficas y filtro de mes).
9. **tabulador** — niveles de ingreso (ISR).
10. **Gastos captura** *(nueva)* — captura flexible manual/XML con conceptos dinámicos.

---

## Notas y pendientes menores
- **Al abrir el archivo, Excel recalcula solo** (está configurado para ello). Si pregunta por “habilitar edición/contenido”, acepta.
- La **carga automática de XML** requiere **Excel de escritorio (Windows) con Office** (Power Query). En Chromebook/Excel Online solo se consulta o captura a mano.
- El **código Power Query** conviene probarlo con XML reales; si algún campo necesita ajuste por variantes de los comprobantes, se afina (está dentro de la garantía de 15 días).
- Fuera de alcance de la Parte 1 (para cotizar aparte si se desea): desglose por concepto individual de **nómina12**, y la **app web** (Parte 2).
