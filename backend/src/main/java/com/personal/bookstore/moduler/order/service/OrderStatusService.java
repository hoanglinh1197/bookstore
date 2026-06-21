package com.personal.bookstore.moduler.order.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.OrderStatus;
import com.personal.bookstore.moduler.order.repository.OrderStatusRepository;

@Service
public class OrderStatusService {
	
	@Autowired
	private OrderStatusRepository orderStatusRepository;
	
	public OrderStatus orderStatus(Long id) {
		Optional<OrderStatus> orderStatus = orderStatusRepository.findById(id);
		return orderStatus.get();
	}
}
