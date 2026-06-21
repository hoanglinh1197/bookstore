package com.personal.bookstore.moduler.order.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import com.personal.bookstore.entity.Order;

public interface OrderRepository extends CrudRepository<Order, Long>{
	
	Order save(Order order);
	
	 @Modifying
	    @Query("""
	        UPDATE Order o
	        SET o.shippingStatusId = 2
	        WHERE o.shippingStatusId = 1
	          AND o.createdAt <= :time
	    """)
	int updateShippingStatusAuto(LocalDateTime time);
	 
	List<Order> findByAccountId(Long accId);
	
	List<Order> findByAccountIdAndShippingStatusId(Long orderId, Long shippingStatusId);
	
	Optional<Order> findById(Long id);
		 
}
