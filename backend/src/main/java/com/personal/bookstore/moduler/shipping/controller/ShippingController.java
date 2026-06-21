package com.personal.bookstore.moduler.shipping.controller;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.personal.bookstore.moduler.shipping.dto.ShippingFeeRequestFromClient;
import com.personal.bookstore.moduler.shipping.service.GhnShippingService;

@RestController
@RequestMapping("/api/shippingFee")
public class ShippingController {

	@Autowired
	private GhnShippingService ghnShippingService;

	@PostMapping
	public ResponseEntity<?> getShippingFee(@RequestBody ShippingFeeRequestFromClient req) {
		System.out.println("Dang tinh shippingFee");
		BigDecimal result = ghnShippingService.getShippingFee(req);
		System.out.println("Chi phi la: "+ result);
		return ResponseEntity.ok(result);
	}
}
