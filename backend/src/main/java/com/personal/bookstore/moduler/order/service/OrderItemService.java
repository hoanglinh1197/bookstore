package com.personal.bookstore.moduler.order.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.OrderItem;
import com.personal.bookstore.moduler.order.repository.OrderItemRepository;

import jakarta.transaction.Transactional;

@Service
@Transactional
public class OrderItemService {
	
	@Autowired
	private OrderItemRepository orderItemRepository;
	
	public OrderItem save(OrderItem orderItem) {
		return orderItemRepository.save(orderItem);
	}
	
	public List<OrderItem> orderItem(Long orderId){
		return orderItemRepository.findByOrderId(orderId);
	}

}
