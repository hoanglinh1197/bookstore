package com.personal.bookstore.moduler.shipping.repository;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.ShippingMethod;

@Repository
public interface ShippingMethodRepository extends CrudRepository<ShippingMethod, Long>{

	Optional<ShippingMethod> findById(Long id);
	
	Optional<ShippingMethod> findByCode(String code);
	
}
