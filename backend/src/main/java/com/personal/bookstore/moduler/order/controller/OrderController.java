package com.personal.bookstore.moduler.order.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.personal.bookstore.moduler.order.dto.HistoryOrderResponseDto;
import com.personal.bookstore.moduler.order.dto.OrderRequestDto;
import com.personal.bookstore.moduler.order.service.OrderService;


@RestController
@RequestMapping("/orders")
public class OrderController {
	
	@Autowired
	private OrderService orderService;
	
	@PostMapping
	public BigDecimal order(@RequestBody OrderRequestDto orderDto) {
		System.out.println("Vao ham order");
		return orderService.order(orderDto);
	}
	
	@GetMapping
	public List<HistoryOrderResponseDto> orders(Authentication auth, @RequestParam String shippingStatus){
		List<HistoryOrderResponseDto> result = new ArrayList<HistoryOrderResponseDto>();
		if(shippingStatus.equalsIgnoreCase("ALL")) {
			System.out.println("Vao ShippingStatus ALL");
			result = orderService.orders(auth.getName());
		}else {
			System.out.println("Vao ShippingStatus: "+ shippingStatus);
			result = orderService.orders(auth.getName(), shippingStatus);
		}
		return result;
	}
}
