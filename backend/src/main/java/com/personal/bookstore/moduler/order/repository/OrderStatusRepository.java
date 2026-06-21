package com.personal.bookstore.moduler.order.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.OrderStatus;

@Repository
public interface OrderStatusRepository extends CrudRepository<OrderStatus, Long>{

	
}
