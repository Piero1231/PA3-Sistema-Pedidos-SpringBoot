
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.DecimalFormatSymbols" %>
<%@ page import="java.util.Locale" %>
<%@ page import="org.springframework.security.web.csrf.CsrfToken" %>

<%!
    private String escapar(Object valor) {
        if (valor == null) return "";
        return String.valueOf(valor)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private Object obtener(Object objeto, String propiedad) {
        if (objeto == null) return null;

        try {
            String getter = "get"
                    + Character.toUpperCase(propiedad.charAt(0))
                    + propiedad.substring(1);

            Method metodo;

            try {
                metodo = objeto.getClass().getMethod(getter);
            } catch (NoSuchMethodException e) {
                metodo = objeto.getClass().getMethod(propiedad);
            }

            return metodo.invoke(objeto);
        } catch (Exception e) {
            return null;
        }
    }

    private String moneda(Object valor) {
        if (valor == null) return "0.00";

        try {
            DecimalFormat formato = new DecimalFormat(
                    "0.00",
                    DecimalFormatSymbols.getInstance(Locale.US)
            );
            return formato.format(valor);
        } catch (Exception e) {
            return escapar(valor);
        }
    }
%>

<%
    String contexto = request.getContextPath();

    Object atributoProductos = request.getAttribute("productos");
    List<?> productos = atributoProductos instanceof List
            ? (List<?>) atributoProductos
            : Collections.emptyList();

    Object atributoPedidos = request.getAttribute("pedidos");
    List<?> pedidos = atributoPedidos instanceof List
            ? (List<?>) atributoPedidos
            : Collections.emptyList();

    Object error = request.getAttribute("error");
    String creado = request.getParameter("creado");

    Object clienteIngresado = request.getAttribute("clienteIngresado");
    Object productoCodigoIngresado = request.getAttribute("productoCodigoIngresado");
    Object cantidadIngresada = request.getAttribute("cantidadIngresada");

    CsrfToken csrf = (CsrfToken) request.getAttribute("_csrf");
    String csrfNombre = csrf != null ? csrf.getParameterName() : "_csrf";
    String csrfValor = csrf != null ? csrf.getToken() : "";
%>

<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Sistema de Pedidos - ISIL</title>

    <link rel="stylesheet"
          href="<%= contexto %>/assets/css/app.css">
</head>

<body>

<div class="contenedor">

    <header class="cabecera">
        <div>
            <p class="eyebrow">
                Spring Boot 4.1 · Spring MVC · Inyección de Dependencias
            </p>

            <h1>Sistema de Pedidos</h1>

            <p class="subtitulo">
                El catálogo, precio y stock provienen de inventario-service.
                Los pedidos se almacenan en la base de datos configurada.
            </p>
        </div>

        <form method="post" action="<%= contexto %>/logout">
            <input type="hidden"
                   name="<%= escapar(csrfNombre) %>"
                   value="<%= escapar(csrfValor) %>">

            <button type="submit">Cerrar sesión</button>
        </form>

        <div class="flujo">
            DispatcherServlet → Controller → Service → RestClient →
            inventario-service · Pedido → Base de datos
        </div>
    </header>

    <section class="tarjeta">

        <% if (error != null) { %>
            <div class="alerta error">
                <%= escapar(error) %>
            </div>
        <% } %>

        <% if (creado != null && !creado.isBlank()) { %>
            <div class="alerta exito">
                Pedido #<%= escapar(creado) %> registrado correctamente.
            </div>
        <% } %>

        <h2>Registrar pedido</h2>

        <form method="post"
              action="<%= contexto %>/pedidos"
              class="form-grid">

            <input type="hidden"
                   name="<%= escapar(csrfNombre) %>"
                   value="<%= escapar(csrfValor) %>">

            <label>
                Cliente

                <input name="cliente"
                       required
                       maxlength="120"
                       placeholder="Ej. Ana Torres"
                       value="<%= escapar(clienteIngresado) %>">
            </label>

            <label>
                Producto

                <select name="productoCodigo" required>
                    <option value="">Seleccione un producto</option>

                    <% for (Object producto : productos) {
                        Object codigo = obtener(producto, "codigo");
                        Object nombre = obtener(producto, "nombre");
                        Object precio = obtener(producto, "precio");
                        Object stock = obtener(producto, "stock");

                        boolean agotado = false;

                        if (stock instanceof Number) {
                            agotado = ((Number) stock).intValue() <= 0;
                        }

                        boolean seleccionado =
                                codigo != null
                                && productoCodigoIngresado != null
                                && String.valueOf(codigo).equals(
                                        String.valueOf(productoCodigoIngresado)
                                );
                    %>

                        <option value="<%= escapar(codigo) %>"
                                <%= agotado ? "disabled" : "" %>
                                <%= seleccionado ? "selected" : "" %>>

                            <%= escapar(codigo) %> -
                            <%= escapar(nombre) %> -
                            S/ <%= moneda(precio) %> -
                            stock: <%= escapar(stock) %>

                        </option>

                    <% } %>
                </select>
            </label>

            <label>
                Cantidad

                <input name="cantidad"
                       type="number"
                       min="1"
                       value="<%= cantidadIngresada == null
                               ? "1"
                               : escapar(cantidadIngresada) %>"
                       required>
            </label>

            <button type="submit">Registrar</button>

        </form>
    </section>

    <section class="tarjeta">

        <div class="titulo-tabla">
            <h2>Pedidos registrados</h2>

            <p>
                Cada pedido conserva el código, nombre y precio
                vigente al momento de la compra.
            </p>
        </div>

        <div class="tabla-scroll">

            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Cliente</th>
                    <th>Código</th>
                    <th>Producto</th>
                    <th>Precio unitario</th>
                    <th>Cantidad</th>
                    <th>Total</th>
                    <th>Fecha</th>
                </tr>
                </thead>

                <tbody>

                <% for (Object pedido : pedidos) { %>

                    <tr>
                        <td><%= escapar(obtener(pedido, "id")) %></td>
                        <td><%= escapar(obtener(pedido, "cliente")) %></td>
                        <td><%= escapar(obtener(pedido, "productoCodigo")) %></td>
                        <td><%= escapar(obtener(pedido, "productoNombre")) %></td>

                        <td>
                            S/ <%= moneda(obtener(pedido, "precioUnitario")) %>
                        </td>

                        <td><%= escapar(obtener(pedido, "cantidad")) %></td>

                        <td>
                            S/ <%= moneda(obtener(pedido, "total")) %>
                        </td>

                        <td><%= escapar(obtener(pedido, "fecha")) %></td>
                    </tr>

                <% } %>

                <% if (pedidos.isEmpty()) { %>
                    <tr>
                        <td colspan="8" class="sin-datos">
                            Aún no hay pedidos.
                        </td>
                    </tr>
                <% } %>

                </tbody>
            </table>

        </div>
    </section>

    <p>
        <a href="<%= contexto %>/reportes/pedidos">
            Ver reportes de pedidos
        </a>
    </p>

</div>

</body>
</html>
