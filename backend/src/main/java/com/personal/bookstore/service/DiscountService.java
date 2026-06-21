package com.personal.bookstore.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.Discount;
import com.personal.bookstore.repository.DiscountRepository;

@Service
public class DiscountService {
	
	@Autowired
	private DiscountRepository repository;
	
	public Optional<Discount> findById(long id){
		return repository.findById(id);
	}
}
