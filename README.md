# Concentrado CFDI — herramienta de control financiero (Parte 1)

Proyecto para **Emira Huerta** (proveedor: Jorge Nuñez López). Cotización **COT-2026-001**.
Branch de trabajo: `claude/excel-function-improvement-l8snqx`.

## 👉 Empieza aquí
Lee **[`CONTEXTO_Y_CONTINUACION.md`](CONTEXTO_Y_CONTINUACION.md)** — tiene el estado completo, la arquitectura, los pendientes y cómo continuar en otra máquina u otro chat.

## Archivo vivo
**`Concentrado_CFDI_AUTOMATIZADO.xlsm`** (contiene las consultas Power Query y las fórmulas conectadas). Es el archivo sobre el que se debe continuar.

## Resumen del estado
- ✅ Errores corregidos (60 `#REF!` → 0), sin dañar tablas dinámicas/slicers/gráficas.
- ✅ Carga de XML CFDI 4.0 con Power Query (2 consultas: `Consulta1` y `CFDI`).
- ✅ DASHBOARD (por RFC/mes, indicadores y gráficas) e `ingresos` automatizados desde los XML; `REGLA DE ORO` y `presupuesto` se actualizan vía `ingresos`.
- ⚠️ Pendiente: ligar el flujo `concentrado`, selector de mes en `ingresos`, menú de RFC, botón .xlsm. Ver §5 del contexto.
