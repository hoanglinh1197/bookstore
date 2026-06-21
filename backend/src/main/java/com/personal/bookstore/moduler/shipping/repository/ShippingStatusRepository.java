package com.personal.bookstore.moduler.shipping.repository;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.ShippingStatus;

@Repository
public interface ShippingStatusRepository extends CrudRepository<ShippingStatus, Long>{
	
	Optional<ShippingStatus> findByShippingStatus(String shippingStatus);

}
