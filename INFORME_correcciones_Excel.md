# Informe de correcciones — Concentrado CFDI

**Archivo original:** `ejemplo2_concentrados_Fabi.xlsx`
**Archivo corregido:** `Concentrado_CFDI_CORREGIDO.xlsx`
**Método:** edición quirúrgica del XML interno para **no dañar** tablas dinámicas, segmentaciones (slicers) ni gráficas.

## Resumen

| Problema | Antes | Después |
|---|---|---|
| Fórmulas `#REF!` | 60 | **0** |
| Vínculo a archivo externo roto (`[1]gastos fijos-variables`) | 1 | **0** (repuntado a `hoja de gastos`) |
| Fórmulas `VLOOKUP` sin protección (riesgo `#N/A`) | 4 | Protegidas con `IFERROR` |
| Divisiones sin protección (riesgo `#DIV/0!`) | ~22 | Protegidas con `IFERROR` |
| Rangos `SUMIF` desalineados (resumen mensual) | Sí | Corregidos |
| Tablas dinámicas / slicers / gráficas | — | **Conservadas intactas** |

Total de celdas corregidas: **112**. El libro abre sin mensajes de error y recalcula al abrir (`fullCalcOnLoad`).

## Detalle por hoja

**ingresos** (5 `#REF!` + 4 VLOOKUP + divisiones)
- `A7:E7` (RFC, CURP, NSS, SDI, SBC) apuntaban a `fabi!#REF!` → repuntados a `fabi!$F$2, $W$2, $X$2, $AH$2, $AG$2`.
- `H34, H35, H37, H40` (búsquedas en tabulador de ISR) → envueltas en `IFERROR(...,0)`.
- `D5, H38, H52, H53, H54` (divisiones) → `IFERROR(...,0)`.

**hoja de gastos** (3 divisiones)
- `D5, D47, D78` (porcentajes sobre ingresos/presupuesto) → `IFERROR(...,0)`.

**presupuesto** (2 `#REF!` + vínculo externo + 8 divisiones)
- `K24, K26` (`'hoja de gastos'!#REF!`) → repuntados a `D90` y `D80`.
- `K25` (vínculo externo roto `'[1]gastos fijos-variables'!P29`) → `'hoja de gastos'!D81`.
- `A30, A48, A50, A53, L53, A55, A56, M29` (divisiones) → `IFERROR(...,0)`.

**REGLA DE ORO** (7 divisiones)
- `D5, F5, D6, F6, D7, F7, D8` (porcentajes correcto/real) → `IFERROR(...,0)`.

**detalle** (53 `#REF!`)
- `C8:C60` tenían `MID(fabi!#REF!,4,2)` → reemplazadas por `IFERROR(IF(Bn="","",MONTH(Bn)),"")`, que obtiene el mes de la fecha de la propia fila (y queda vacío si no hay fecha). Las filas ya correctas (`C61:C64`) se conservaron.

**concentrado** (rangos `SUMIF`)
- Ingresos `C4:N4`: unificados a `SUMIF(detalle!$C$8:$C$94, mes, detalle!$E$8:$E$94)`.
- Egresos `C5:N5`: el rango de suma crecía de más cada mes (`J8:K50`, `J8:L50`, …); unificados a `SUMIF(detalle!$H$8:$H$50, mes, detalle!$J$8:$J$50)`.

## Nota de criterio
En `detalle`, las fórmulas rotas apuntaban a columnas de `fabi` que ya no existen y las filas no tienen importe, por lo que se aplicó **manejo seguro** (quedan vacías) sin alterar los totales. Si más adelante se decide que `detalle` debe **reflejar automáticamente** los CFDI de `fabi`, es un ajuste sencillo (entra como mejora de la hoja DASHBOARD / automatización).
