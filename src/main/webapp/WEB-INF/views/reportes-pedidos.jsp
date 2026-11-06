
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.lang.reflect.Method" %>

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
        if (objeto == null) return "";

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
            return "";
        }
    }
%>

<%
    Object atributoPedidos = request.getAttribute("pedidos");
    List<?> pedidos = atributoPedidos instanceof List
            ? (List<?>) atributoPedidos
            : Collections.emptyList();

    Object atributoClientes = request.getAttribute("clientesFrecuentes");
    List<?> clientes = atributoClientes instanceof List
            ? (List<?>) atributoClientes
            : Collections.emptyList();

    String contexto = request.getContextPath();
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reportes de Pedidos</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
        }

        h1, h2 {
            color: #263238;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin: 15px 0 25px;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #e9eef2;
        }

        input, button {
            padding: 8px;
            margin: 5px;
        }

        button {
            background-color: #1976d2;
            color: white;
            border: none;
            cursor: pointer;
        }

        .error {
            color: #b71c1c;
        }
    </style>
</head>

<body>

<h1>Reportes de Pedidos</h1>

<% if (error != null) { %>
    <p class="error"><%= escapar(error) %></p>
<% } %>

<hr>

<h2>Busqueda avanzada de pedidos</h2>

<form method="get" action="<%= contexto %>/reportes/pedidos">

    <label>Cliente:</label>
    <input type="text"
           name="cliente"
           placeholder="Nombre del cliente"
           required>

    <label>Total minimo:</label>
    <input type="number"
           name="totalMinimo"
           min="0"
           step="0.01"
           required>

    <button type="submit">Buscar pedidos</button>

</form>

<h3>Resultados de busqueda</h3>

<p>Pedidos encontrados: <%= pedidos.size() %></p>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Cliente</th>
        <th>Producto</th>
        <th>Cantidad</th>
        <th>Total</th>
    </tr>
    </thead>

    <tbody>

    <% for (Object pedido : pedidos) { %>
        <tr>
            <td><%= escapar(obtener(pedido, "id")) %></td>
            <td><%= escapar(obtener(pedido, "cliente")) %></td>
            <td><%= escapar(obtener(pedido, "productoNombre")) %></td>
            <td><%= escapar(obtener(pedido, "cantidad")) %></td>
            <td><%= escapar(obtener(pedido, "total")) %></td>
        </tr>
    <% } %>

    <% if (pedidos.isEmpty()) { %>
        <tr>
            <td colspan="5">No hay pedidos para mostrar.</td>
        </tr>
    <% } %>

    </tbody>
</table>

<hr>

<h2>Clientes frecuentes</h2>

<form method="get" action="<%= contexto %>/reportes/pedidos">

    <label>Minimo de pedidos:</label>
    <input type="number"
           name="minPedidos"
           min="1"
           value="1"
           required>

    <button type="submit">Consultar</button>

</form>

<h3>Resultados de clientes frecuentes</h3>

<p>Clientes encontrados: <%= clientes.size() %></p>

<table>
    <thead>
    <tr>
        <th>Cliente</th>
        <th>Total pedidos</th>
        <th>Total unidades</th>
        <th>Importe acumulado</th>
        <th>Ticket promedio</th>
    </tr>
    </thead>

    <tbody>

    <% for (Object cliente : clientes) { %>
        <tr>
            <td><%= escapar(obtener(cliente, "cliente")) %></td>
            <td><%= escapar(obtener(cliente, "totalPedidos")) %></td>
            <td><%= escapar(obtener(cliente, "totalUnidades")) %></td>
            <td><%= escapar(obtener(cliente, "importeAcumulado")) %></td>
            <td><%= escapar(obtener(cliente, "ticketPromedio")) %></td>
        </tr>
    <% } %>

    <% if (clientes.isEmpty()) { %>
        <tr>
            <td colspan="5">No hay clientes para mostrar.</td>
        </tr>
    <% } %>

    </tbody>
</table>

<hr>

<a href="<%= contexto %>/pedidos">
    Volver a pedidos
</a>

</body>
</html>
