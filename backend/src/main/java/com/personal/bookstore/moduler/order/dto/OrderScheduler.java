package com.personal.bookstore.moduler.order.dto;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.personal.bookstore.moduler.order.service.OrderService;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Component
@NoArgsConstructor
@AllArgsConstructor
public class OrderScheduler {
	
	
	@Autowired
	private OrderService orderService;

	@Scheduled(cron = "*/30 * * * * *")
	public void updateShippingStatusAuto() {
		orderService.updateShippingStatusAuto();
	}

}
