package com.personal.bookstore.moduler.shipping.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.ShippingMethod;
import com.personal.bookstore.moduler.shipping.repository.ShippingMethodRepository;

@Service
public class ShippingMethodService {
	
	@Autowired
	private ShippingMethodRepository shippingMethodRepository;
	
	public Optional<ShippingMethod> findByCode(String code){
		return shippingMethodRepository.findByCode(code);
	}
	
	public Optional<ShippingMethod> findById(Long id){
		return shippingMethodRepository.findById(id);
	}

}
