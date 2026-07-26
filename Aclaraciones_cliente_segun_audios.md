# Aclaraciones para la clienta (Emira) — respuestas a sus dudas de la cotización

> Basado en los 6 audios del 21‑jul. Redactado para que puedas **reenviarlo o leerlo tal cual**.
> Cada punto tiene una **respuesta lista** (en tono directo a la clienta) y una **nota interna** para ti (Jorge).

---

## 1) "Cambios de alcance" — ¿qué es?

**Respuesta a la clienta:**
"Alcance" es simplemente **la lista de lo que acordamos que voy a hacer** (los 4 puntos de la Parte 1: corregir tus 8 hojas, el tablero/DASHBOARD, la carga de XML y la documentación). Un *cambio de alcance* es cuando aparece **algo nuevo o distinto a esa lista** —por ejemplo, una hoja adicional, otro tipo de reporte, o una automatización extra que no habíamos incluido—. No es ningún castigo: solo significa que si surge algo extra, lo cotizo aparte y lo acordamos **antes** de hacerlo, para que no haya sorpresas ni malentendidos.

**Nota interna:** confirmar con ella qué considera "parte de las 8 hojas" para que las gráficas y la captura manual queden DENTRO del alcance y no se perciban como extra (ver punto 6).

---

## 2) "Cambios hechos por el cliente" — ¿se refiere a mi captura manual?

**Respuesta a la clienta:**
**No, para nada.** Tu **captura manual de gastos es una función que la herramienta va a tener por diseño** — justo como me lo pediste: se llena **automático con los XML cuando existan**, y **a mano cuando no haya factura**. Capturar tus cifras en los espacios previstos es **uso normal y 100% incluido**.

Esa cláusula se refiere a **otra cosa**: si se modifica la **estructura** del archivo (borrar columnas, mover o eliminar hojas, cambiar fórmulas, pegar bloques de otro archivo) y con eso algo se rompe, esa reparación queda fuera de la garantía. Pero **escribir tus datos** en la herramienta no es un "cambio del cliente".

**Nota interna:** este era su mayor temor. Conviene reafirmarle que el **llenado dual (XML / manual)**, sobre todo en gastos, es parte central del diseño.

---

## 3) Soporte / capacitación después de la garantía — ¿cómo sería? ¿Zoom?

**Respuesta a la clienta:**
Sí, **la capacitación se puede hacer por videollamada (Zoom o Google Meet)**, sin problema. Dentro de los **15 días de garantía** incluyo una **sesión de arranque** para enseñarte a usar la herramienta (cargar XML, elegir mes, leer los indicadores). Después de la garantía, si necesitas más soporte o capacitación, lo agendamos por Zoom como servicio aparte; te puedo dar un **precio por hora** o un **paquete pequeño de horas**, lo que te acomode.

**Nota interna:** definir tarifa/hora o mini‑paquete de soporte post‑garantía para tenerlo listo si lo pide.

---

## 4) "Licencias de Excel" — tengo 3 computadoras (laptop con Office, Chromebook, otra)

**Respuesta a la clienta:**
No te vendo Excel; solo aclaro **dónde correrá la parte automática**. La automatización de los XML usa **Power Query**, que **solo funciona en Excel de escritorio (Windows) con Office instalado**. Entonces:

- **Tu laptop con Office** → es la ideal, ahí corre **todo**, incluida la carga automática de XML. ✅
- **La Chromebook (Google Classroom / hojas de Google)** → puede **abrir y ver/editar** la hoja, pero **NO ejecuta la carga automática de XML** (no tiene Power Query). Sirve para consultar o capturar a mano, no para la automatización.
- **Excel en el navegador (Excel Online)** → tampoco corre la automatización completa.

En resumen: **haz la carga de XML en tu laptop con Office** (que ya la tienes), y las otras compus te sirven para consultar. Con eso estás cubierta.

**Nota interna:** si su laptop "se calienta"/alenta, la carga de 500 facturas puede pesar. Vale mencionar que el proceso es puntual (se corre y se guarda), no continuo.

---

## 5) "Migración a otras plataformas o versiones distintas" — ¿qué significa?

**Respuesta a la clienta:**
Significa que el precio cubre entregarte la herramienta **en Excel**, en la versión que acordamos. Si **más adelante** quisieras **la misma herramienta pero en otro entorno** —por ejemplo en **Google Sheets**, o como la **app web** de la Parte 2, o adaptada a una versión de Office muy distinta— eso sería un trabajo por separado. No afecta lo que recibes ahora; solo aclara que "mudarla" a otra plataforma no está incluido en los $2,000.

---

## 6) Requerimientos que quedaron más claros con los audios (para afinar el archivo)

1. **Llenado DUAL (automático por XML *o* manual), sobre todo en GASTOS.** Hay clientes que no facturan sus gastos → captura manual. Ingresos casi siempre de XML; gastos, mixto.
2. **Cantidad de XML variable.** Asalariados semanales ≈ 52 recibos; **RESICO** varía (a veces menos, a veces más). La carga debe funcionar con **cualquier número** de XML.
3. **Agregar conceptos nuevos / insertar renglones** en gastos (básicos, lujos, ahorro) sin romper porcentajes ni totales. *(Ej.: alguien pone "nutriólogo" como básico.)*
4. **Gráficas** en *entradas y salidas* (detalle) y en *flujo de efectivo* (concentrado), con **menú mes por mes** y visión de **año completo**.
5. **Conservar impresión** de: presupuesto, ingresos y concentrado de gastos (tamaño carta/oficio).
6. **Fin:** ahorrar tiempo y **reducir errores de captura**. **No** requiere cálculo de impuestos (usa otros sistemas).

### Recomendación técnica (para el punto 3 — agregar conceptos)
Convertir la **hoja de gastos** en una **Tabla de Excel** con una columna **"Categoría"** (básico / lujo / ahorro). Los totales e indicadores porcentuales se calcularían con **SUMIFS por categoría** (no por rangos fijos). Así, **insertar un renglón nuevo y escribir su categoría** hace que **todo se recalcule solo**, sin romper nada. Es la forma robusta de darle la libertad que hoy tiene "a mano".

---

## 7) Punto de alcance a decidir (interno, Jorge)

Lo que Emira pide encaja **en gran parte** con la Parte 1 cotizada (corrección + DASHBOARD + carga XML + captura manual). Conviene decidir si estos quedan **dentro** de los $2,000 o se ajusta el alcance:

- **Dentro (razonable):** llenado dual XML/manual, tabla de gastos con conceptos dinámicos, gráficas en detalle y flujo con menú por mes.
- **Fuera / a cotizar aparte (como ya pusiste):** parseo del complemento de **Nómina (nómina12)**, multiusuario, y la **app web** (Parte 2).

Sugerencia: reafirmarle que **las 8 hojas + automatización + manual + gráficas** están contempladas, y dejar explícito qué NO (nómina12 detallada, web) para que el precio cerrado se sostenga.
