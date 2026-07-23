# Aclaración y ampliación de la propuesta — COT‑2026‑001

**Proveedor:** Jorge Nuñez López — Servicios de desarrollo y automatización
**Cliente:** Emira Huerta
**Referencia:** Propuesta y Presupuesto de Servicios, Folio COT‑2026‑001
**Objetivo de este documento:** explicar con más detalle y en lenguaje sencillo cada punto de la cotización, para que quede claro *qué se entrega, para qué sirve y qué incluye cada importe*. No cambia los precios ni el alcance ya cotizados; sólo los explica.

---

## En una frase

Su archivo de Excel (el concentrado de CFDI) hoy tiene errores y trabajo manual. La **Parte 1** lo deja **corregido y automatizado** para que mida sola la situación financiera del contribuyente. La **Parte 2** es *opcional* y a futuro: convertir esa misma herramienta en una **aplicación web** multiusuario.

---

## PARTE 1 · Mejora y corrección del archivo Excel (precio cerrado: $2,000 MXN)

Esta es la parte contratada ahora. Se entrega en **3 días hábiles** después del pago y **conserva todas sus hojas originales**. Se divide en 4 conceptos:

### 1) Diagnóstico y corrección de errores de fórmula — $700
**Qué es:** su archivo hoy arrastra fórmulas rotas que muestran mensajes de error y hacen que los totales no cuadren.

**Lo que encontramos (medido en el archivo real):**
- **60 errores `#REF!`** — fórmulas que apuntan a celdas que ya no existen (se borraron o movieron columnas). Se concentran en la hoja *detalle* (53), *ingresos* (5) y *presupuesto* (2), más un **vínculo a otro archivo externo** que ya no existe.
- **Riesgos de `#DIV/0!`** — divisiones que truenan cuando un dato viene en blanco o en cero (por ejemplo, porcentajes sobre el total de ingresos).
- **Riesgos de `#N/A`** — búsquedas en el tabulador de ISR que fallan si el valor no está en la tabla.
- **Rangos mal alineados** en el resumen mensual (la suma de egresos crecía de más en cada mes, dando cifras incorrectas).

**Qué se corrige y cómo:**
- Se reparan las referencias rotas apuntándolas a los datos correctos.
- Se blindan las fórmulas con **`IFERROR`** (manejo seguro): si un dato falta, la celda muestra 0 o queda vacía **en lugar de un error**. Esto es lo que reduce el *riesgo de error* que ustedes pidieron.
- Se alinean los rangos para que los totales mensuales cuadren.

**Resultado entregable:** el archivo abre **sin un solo mensaje de error** y con los cálculos consistentes. *(En la versión corregida que ya se preparó, los 60 `#REF!` quedaron en 0 y se conservaron intactas las tablas dinámicas, segmentaciones y gráficas.)*

### 2) Hoja DASHBOARD (tablero de control) — $800
**Qué es:** una hoja nueva y visual que resume todo "de un vistazo", sin tener que buscar entre las 8 hojas.

**Qué incluye:**
- **Menú desplegable por RFC:** usted elige un contribuyente y el tablero se actualiza solo (por eso el archivo *soporta más de un contribuyente*).
- **Indicadores automáticos:** ingresos, egresos, balance (diferencia), número de comprobantes y cuántos quedan "por revisar".
- **Desglose mensual automático:** el comportamiento de los 12 meses del ejercicio (el año completo), con **menú desplegable por mes**.
- **Gráficas** (pastel o barras) para *visualizar* la información, como se solicitó.

**Para qué sirve:** es justo lo que pidieron en las especificaciones — *eficientar el análisis, ahorrar tiempo y visualizar* la salud financiera del contribuyente automáticamente.

### 3) Automatización de carga de XML CFDI 4.0 — $400
**Qué es:** hoy alguien tiene que capturar o pegar a mano la información de los CFDI. Esto lo automatiza.

**Qué incluye:**
- Con **Power Query** (una función que ya viene incluida en Excel, sin costo de licencia extra) el archivo **lee una carpeta de XML** y llena la información sola.
- **Validación automática:** compara el **RFC de la carpeta contra el RFC de cada XML** para avisar si se coló un comprobante que no corresponde.

**Para qué sirve:** menos captura manual = **menos errores y más ahorro de tiempo**. Cuando lleguen nuevos CFDI, sólo se actualiza y listo.

### 4) Documentación, instrucciones, pruebas y entrega — $100
**Qué es:** un instructivo claro de cómo usar la herramienta (cómo cargar los XML, cómo elegir RFC y mes, cómo leer los indicadores), más las pruebas de que todo funciona.

**Se entregan dos archivos:** (a) el Excel corregido y automatizado, y (b) el archivo con el código de automatización (Power Query).

---

### Cómo se cubren sus 8 hojas (especificaciones del cliente)

| Hoja | Qué hace en la herramienta corregida |
|---|---|
| 1 · Datos del XML (fabi) | Ingresos/egresos del contribuyente tomados del CFDI; admite varios contribuyentes |
| 2 · Concentrado de ingresos | Conceptos e indicadores porcentuales |
| 3 · Concentrado de gastos | Categorías (básicos / lujos / ahorro), captura manual y opción de agregar conceptos |
| 4 · Presupuesto | Formato con conceptos, importes y gráficas |
| 5 · Regla de oro | Importes correctos **vs.** reales + fondo de emergencia a 3 y 6 meses |
| 6 · Detalle | Entradas y salidas por mes, conceptos e importes |
| 7 · Flujo mensual acumulado | Comportamiento del año con gráficas mensuales |
| 8 · Tabulador | Niveles de ingreso |

Todas quedan **vinculadas** para que la herramienta mida **automáticamente** la situación financiera con base en ingresos y egresos.

---

### Qué incluye la Parte 1 sin costo adicional
- Entrega del archivo corregido **y** del archivo con el código de automatización.
- **Garantía de 15 días naturales:** si algo falla por causa directa del trabajo entregado, se corrige **sin costo** en ese periodo.

### Qué NO incluye la Parte 1 (se cotiza aparte)
Esto es sólo para dejar claro el límite del precio cerrado; **no** es un cobro sorpresa:
- **Nuevos requerimientos o cambios de alcance:** hojas, reportes o gráficas adicionales a lo descrito; interpretar el complemento de **Nómina (nómina12)**; nuevas automatizaciones.
- **Errores por cambios que haga el cliente** al archivo, o por datos/insumos que entregue el cliente con problemas de origen.
- **Soporte o capacitación** después de los 15 días de garantía.
- **Licencias de Microsoft Excel / Office** (las pone el cliente).
- **Migrar a otra plataforma** o versión distinta a la entregada.

> **Regla simple de costos:** todo lo que sea *un defecto de nuestro trabajo* se corrige gratis dentro de la garantía. Todo lo que sea *un requerimiento nuevo, un cambio del cliente o un error en los datos de origen* se cotiza por separado y se acuerda por escrito **antes** de hacerlo.

---

## PARTE 2 · Escalamiento a plataforma web (ESTIMADO, opcional y a futuro)

**Importante:** esta parte **no** está incluida en los $2,000 de la Parte 1. Son **estimados de mercado** para, más adelante, llevar la misma herramienta de Excel a una **aplicación web** con dominio propio, base de datos y nube. Los costos de nube se facturan **según consumo real**.

### ¿Qué ganaría con la versión web?
- Entrar desde cualquier lado con usuario y contraseña (no depender de un archivo).
- **Varios usuarios** trabajando a la vez, con roles y permisos.
- Cargar XML, ver el dashboard y exportar a Excel/PDF desde el navegador.
- Respaldos automáticos y mayor seguridad.

### A) Desarrollo (inversión inicial, pago único)
Va desglosado por bloques (análisis, backend, frontend, base de datos, almacenamiento, usuarios, infraestructura, pruebas y capacitación). **Suma versión completa: $84,000 MXN.**

**¿Y si es mucho de inicio? — Opción MVP.**
**MVP** = *Producto Mínimo Viable*: una **primera versión funcional** con lo esencial para operar (cargar XML + dashboard por RFC + base de datos + 1 usuario), con **menor inversión inicial: desde $38,000 a $45,000 MXN**. Después se va **ampliando por módulos** hasta la versión completa. Es la forma recomendada de empezar: invertir menos, validar con uso real y crecer.

### B) Costos recurrentes (mensuales, según uso)
Servidor, base de datos, almacenamiento y transferencia en la nube suman **~$1,400 MXN/mes** estimados (el certificado de seguridad SSL es sin costo; el dominio es ~$350/año). Varían según el volumen de XML, imágenes y número de usuarios.

### Planes de soporte (mensual, opcional — se elige uno)
| Plan | Incluye | Mensual |
|---|---|---|
| Básico | Monitoreo, respaldos y hasta 2 h de soporte | $2,000 |
| Estándar | Lo del Básico + actualizaciones y mejoras menores, hasta 6 h | $3,500 |
| Premium | Lo del Estándar + nuevas funciones priorizadas, hasta 15 h y soporte prioritario | $6,000 |

### Resumen de la inversión web
- Inversión inicial (desarrollo completo): **$84,000 MXN**
- Alternativa **MVP** por fases: **desde $38,000 MXN**
- Costo recurrente estimado (infraestructura + soporte Básico): **desde ~$3,400 / mes**

---

## Condiciones y tiempos (recordatorio)
- **Parte 1 (Excel):** entrega en **3 días hábiles** después del pago completo. Garantía 15 días.
- **Parte 2 (Web):** tiempos estimados — **MVP de 3 a 4 semanas**; versión completa de **8 a 12 semanas**.
- Forma de pago sugerida para el proyecto web: **50% anticipo y 50% contra entrega** (ajustable).
- Precios en **MXN**; no incluyen IVA salvo indicación expresa.
- Los costos de nube (AWS) son estimados y se facturan según consumo real.
- Vigencia de la propuesta: **30 días naturales**.

---

## Preguntas frecuentes (por si ayudan a aclarar con el cliente)

**¿Necesito comprar algo más para la Parte 1?**
No. Sólo su **Excel/Office** con licencia. Power Query ya viene incluido en Excel.

**¿Por qué se cotiza la web aparte y "por estimado"?**
Porque depende del alcance final y del consumo real de nube (usuarios, volumen de datos). Por eso se recomienda empezar por el **MVP** y crecer por módulos.

**¿La corrección del Excel me sirve aunque no haga la web?**
Sí. La Parte 1 es **independiente** y le deja una herramienta completa y automatizada en Excel. La web es un paso opcional a futuro.

**¿Qué pasa si aparece un error después de la entrega?**
Si es por el trabajo entregado, se corrige **gratis** dentro de los 15 días de garantía.
