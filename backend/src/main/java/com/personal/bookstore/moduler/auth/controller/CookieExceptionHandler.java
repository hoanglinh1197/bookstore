package com.personal.bookstore.moduler.auth.controller;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MissingRequestCookieException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.personal.bookstore.common.exception.ErrorCode;

@RestControllerAdvice
public class CookieExceptionHandler {
	
	@ExceptionHandler(MissingRequestCookieException.class)
    public ResponseEntity<?> handleMissingCookie(
            MissingRequestCookieException ex) {

        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(Map.of(
                        "code", ErrorCode.Code.INVALID_REF_TOKEN.getValue(),
                        "message", "Refresh token is missing"
                ));
    }
}
