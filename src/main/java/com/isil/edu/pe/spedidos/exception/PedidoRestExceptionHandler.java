
package com.isil.edu.pe.spedidos.exception;

import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice(basePackages = "com.isil.edu.pe.spedidos.controller")
public class PedidoRestExceptionHandler {

    @ExceptionHandler(PedidoException.class)
    public ResponseEntity<Map<String, String>> manejarPedidoException(
            PedidoException ex) {

        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(Map.of("error", ex.getMessage()));
    }
}
