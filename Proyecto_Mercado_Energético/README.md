# PROYECTO MERCADO ENERGÉTICO

# 1. Formalización Matemática del Entorno

El sistema se evalúa en intervalos de tiempo discretos $t$ (cada 15 minutos). Para cada agente $i$ en el intervalo $t$, definimos:

* **Generación ($g_i(t)$):** Energía producida por las placas solares del agente.
* **Demanda ($d_i(t)$):** Energía consumida por la vivienda del agente.
* **Balance Neto ($b_i(t)$):** Se calcula como la diferencia entre la generación y la demanda:
  $$b_i(t) = g_i(t) - d_i(t)$$

A partir del balance neto, clasificamos a los agentes en cada intervalo $t$:
* Si $b_i(t) > 0$, el agente tiene excedente y actúa como **vendedor** (oferente).
* Si $b_i(t) < 0$, el agente tiene déficit y actúa como **comprador** (demandante).

El entorno define dos precios frontera (externos a la comunidad):
* $p_{red}^{compra}$: Precio al que la red eléctrica tradicional vende la energía.
* $p_{red}^{venta}$: Precio al que la red tradicional compensa los excedentes.
* **Restricción del mercado:** $p_{red}^{venta} < p_{red}^{compra}$. La diferencia entre ambos define el margen de negociación interno.

---

# 2. Funciones de Utilidad (El núcleo del razonamiento)

Si un vendedor transfiere una cantidad de energía $q$ a un comprador a un precio interno acordado $p$, sus ganancias se calculan respecto a lo que habrían ganado o pagado interactuando directamente con la red externa:

* **Utilidad del Vendedor:**
  $$u_v = q \cdot (p - p_{red}^{venta})$$

* **Utilidad del Comprador:**
  $$u_c = q \cdot (p_{red}^{compra} - p)$$

### Principio de Conservación del Valor
La suma de las utilidades (el excedente total generado por la comunidad) se define mediante la siguiente expresión:

$$Excedente = u_v + u_c = q \cdot (p - p_{red}^{venta}) + q \cdot (p_{red}^{compra} - p) = q \cdot (p_{red}^{compra} - p_{red}^{venta})$$

Esto demuestra matemáticamente que el precio de transacción $p$ se cancela en la ecuación global. El mecanismo de mercado no crea riqueza por sí mismo; la riqueza $q \cdot (p_{red}^{compra} - p_{red}^{venta})$ viene dada por el mero hecho de intercambiar energía internamente. El algoritmo seleccionado (CNP, Subasta o Bilateral) sirve única y exclusivamente para decidir cómo se casa esa energía ($q$) y cómo se reparte el beneficio económico entre las partes ($p$).

---

# 3. Mapeo a la Arquitectura A&A (JaCaMo)

Para garantizar la trazabilidad exigida en el modelo, la traducción a código se estructura de la siguiente manera:

### A. Nivel de Razonamiento (Agentes `.asl`)
* **`prosumidor.asl`:** Conocerá su perfil (sincero, agresivo o adaptativo) y evaluará sus funciones de utilidad $u_v$ y $u_c$ antes de aceptar o rechazar un trato.
* **`subastador.asl`:** Agente neutral encargado de recoger las pujas y aplicar la regla de casación (se activa exclusivamente en los escenarios de subasta doble).

### B. Nivel de Entorno y Recursos Compartidos (Artefactos de CArtAgO en Java)
* **`Mercado.java`:** Artefacto donde los agentes ejecutan las acciones de `pujar(cantidad, precio)` y consultan las propiedades observables como el `precio_casacion`.
* **`Red.java`:** Mantiene las variables globales correspondientes a $p_{red}^{compra}$ y $p_{red}^{venta}$, así como los límites de potencia de la infraestructura.
* **`Reloj.java`:** Orquestará los turnos temporales (simulando los saltos de 15 minutos), sincronizando de forma determinista la ejecución de todos los agentes.
* **`PerfilesEnergeticos.java`:** Artefacto encargado de leer los conjuntos de datos reales en formato CSV para inyectar los valores de $g_i(t)$ y $d_i(t)$ a cada prosumidor en cada *tick* del reloj.
