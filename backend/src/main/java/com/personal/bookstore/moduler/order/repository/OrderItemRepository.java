package com.personal.bookstore.moduler.order.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.OrderItem;

@Repository
public interface OrderItemRepository extends CrudRepository<OrderItem, Long>{
	
	List<OrderItem> findByOrderId(Long orderId);
}
