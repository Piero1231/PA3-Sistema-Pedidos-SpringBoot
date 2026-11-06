
package com.isil.edu.pe.spedidos.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import com.isil.edu.pe.spedidos.client.InventarioClient;
import com.isil.edu.pe.spedidos.entity.Pedido;
import com.isil.edu.pe.spedidos.exception.PedidoException;
import com.isil.edu.pe.spedidos.repository.PedidoRepository;
import com.isil.edu.pe.spedidos.repository.PedidoReporteJdbcRepository;
import com.isil.edu.pe.spedidos.repository.projection.ClienteFrecuenteProjection;

import java.math.BigDecimal;
import java.util.List;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class PedidoReportesNuevosTest {

    private PedidoRepository pedidoRepository;
    private InventarioClient inventarioClient;
    private PedidoReporteJdbcRepository reporteRepository;
    private PedidoServiceImpl pedidoService;

    @BeforeEach
    void setUp() {
        pedidoRepository = mock(PedidoRepository.class);
        inventarioClient = mock(InventarioClient.class);
        reporteRepository = mock(PedidoReporteJdbcRepository.class);

        pedidoService = new PedidoServiceImpl(
                pedidoRepository,
                inventarioClient,
                reporteRepository
        );
    }

    @Test
    void debeBuscarPedidosPorClienteYTotalMinimo() {
        BigDecimal minimo = new BigDecimal("1000.00");
        List<Pedido> esperados = List.of(mock(Pedido.class));

        when(reporteRepository.buscarPedidosPorClienteYTotalMinimo(
                "Ana", minimo
        )).thenReturn(esperados);

        List<Pedido> resultado =
                pedidoService.buscarPedidosPorClienteYTotalMinimo(
                        " Ana ", minimo
                );

        assertEquals(1, resultado.size());
        assertSame(esperados, resultado);

        verify(reporteRepository)
                .buscarPedidosPorClienteYTotalMinimo("Ana", minimo);

        verifyNoInteractions(inventarioClient);
    }

    @Test
    void debeRechazarClienteVacio() {
        PedidoException error = assertThrows(
                PedidoException.class,
                () -> pedidoService.buscarPedidosPorClienteYTotalMinimo(
                        " ",
                        new BigDecimal("100")
                )
        );

        assertEquals(
                "El cliente es obligatorio.",
                error.getMessage()
        );

        verifyNoInteractions(reporteRepository);
    }

    @Test
    void debeRechazarTotalMinimoNegativo() {
        PedidoException error = assertThrows(
                PedidoException.class,
                () -> pedidoService.buscarPedidosPorClienteYTotalMinimo(
                        "Ana",
                        new BigDecimal("-100")
                )
        );

        assertEquals(
                "El total mínimo debe ser mayor o igual a cero.",
                error.getMessage()
        );

        verifyNoInteractions(reporteRepository);
    }

    @Test
    void debeListarClientesFrecuentes() {
        ClienteFrecuenteProjection cliente =
                new ClienteFrecuenteProjection(
                        "Ana Torres",
                        2L,
                        3L,
                        new BigDecimal("5000.00"),
                        new BigDecimal("2500.00")
                );

        when(reporteRepository.listarClientesFrecuentes(2))
                .thenReturn(List.of(cliente));

        List<ClienteFrecuenteProjection> resultado =
                pedidoService.listarClientesFrecuentes(2);

        assertEquals(1, resultado.size());
        assertEquals("Ana Torres", resultado.get(0).cliente());
        assertEquals(2L, resultado.get(0).totalPedidos());
        assertEquals(
                new BigDecimal("5000.00"),
                resultado.get(0).importeAcumulado()
        );

        verify(reporteRepository).listarClientesFrecuentes(2);
        verifyNoInteractions(inventarioClient);
    }

    @Test
    void debeRechazarMinPedidosInvalido() {
        PedidoException error = assertThrows(
                PedidoException.class,
                () -> pedidoService.listarClientesFrecuentes(0)
        );

        assertEquals(
                "La cantidad mínima de pedidos debe ser mayor o igual a 1.",
                error.getMessage()
        );

        verifyNoInteractions(reporteRepository);
    }
}
