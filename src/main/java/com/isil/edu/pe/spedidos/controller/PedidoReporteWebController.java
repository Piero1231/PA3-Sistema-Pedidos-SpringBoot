
package com.isil.edu.pe.spedidos.controller;

import com.isil.edu.pe.spedidos.exception.PedidoException;
import com.isil.edu.pe.spedidos.service.PedidoService;
import java.math.BigDecimal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class PedidoReporteWebController {

    private final PedidoService pedidoService;

    public PedidoReporteWebController(PedidoService pedidoService) {
        this.pedidoService = pedidoService;
    }

    @GetMapping("/reportes/pedidos")
    public String mostrarReportes(
            @RequestParam(required = false) String cliente,
            @RequestParam(required = false) BigDecimal totalMinimo,
            @RequestParam(required = false) Integer minPedidos,
            Model model) {

        try {
            if (cliente != null || totalMinimo != null) {
                model.addAttribute(
                        "pedidos",
                        pedidoService.buscarPedidosPorClienteYTotalMinimo(
                                cliente, totalMinimo
                        )
                );
            }

            if (minPedidos != null) {
                model.addAttribute(
                        "clientesFrecuentes",
                        pedidoService.listarClientesFrecuentes(minPedidos)
                );
            }

        } catch (PedidoException e) {
            model.addAttribute("error", e.getMessage());
        }

        return "reportes-pedidos";    }

    @GetMapping("/prueba-reportes")
    @ResponseBody
    public String probarControlador() {
        return "CONTROLADOR FUNCIONANDO";
    }
}
