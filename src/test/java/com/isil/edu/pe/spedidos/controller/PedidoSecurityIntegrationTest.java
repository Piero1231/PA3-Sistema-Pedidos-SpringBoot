
package com.isil.edu.pe.spedidos.controller;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers.springSecurity;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

@SpringBootTest
@ActiveProfiles("test")
class PedidoSecurityIntegrationTest {

    private MockMvc mockMvc;

    @Autowired
    private WebApplicationContext context;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context)
                .apply(springSecurity())
                .build();
    }

    @Test
    @DisplayName("Rechazar usuario anonimo al acceder a pedidos")
    void rejectAnonymousUserWhenAccessingOrdersPage() throws Exception {

        ResultActions response = mockMvc.perform(get("/pedidos"));

        response.andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("CONSULTA no puede registrar pedidos")
    void rejectPedidoControllerPostWhenConsultaRoleSubmitsValidCsrf() throws Exception {

        ResultActions response = mockMvc.perform(post("/pedidos")
                .with(user("consulta").roles("CONSULTA"))
                .with(csrf())
                .param("cliente", "Ana")
                .param("productoCodigo", "P001")
                .param("cantidad", "1"));

        response.andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("OPERADOR no puede registrar sin token CSRF")
    void rejectPedidoControllerPostWhenOperadorRoleOmitsCsrfToken() throws Exception {

        ResultActions response = mockMvc.perform(post("/pedidos")
                .with(user("operador").roles("OPERADOR"))
                .param("cliente", "Ana")
                .param("productoCodigo", "P001")
                .param("cantidad", "1"));

        response.andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("CONSULTA puede acceder al resumen de pedidos")
    void returnOrderSummaryJsonWhenConsultaRoleAccessesProtectedApi() throws Exception {

        ResultActions response = mockMvc.perform(get("/api/v1/orders/resumen")
                .with(user("consulta").roles("CONSULTA")));

        response.andExpect(status().isOk())
                .andExpect(jsonPath("$.totalPedidos").isNumber())
                .andExpect(jsonPath("$.totalUnidades").isNumber());
    }
}
