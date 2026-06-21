package com.personal.bookstore.moduler.shipping.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.ShippingStatus;
import com.personal.bookstore.moduler.shipping.repository.ShippingStatusRepository;

@Service
public class ShippingStatusService {
	
	@Autowired
	private ShippingStatusRepository shippingStatusRepository;
	
	public Optional<ShippingStatus> findByShippingStatus(String shippingStatus){
		return shippingStatusRepository.findByShippingStatus(shippingStatus);
	}
}
