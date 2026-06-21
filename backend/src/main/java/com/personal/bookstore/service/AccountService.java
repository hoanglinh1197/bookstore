package com.personal.bookstore.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.Account;
import com.personal.bookstore.repository.AccountRepository;

@Service
public class AccountService {
	
	@Autowired
	private AccountRepository repository;
	
	public Account save(Account acc) {
		return repository.save(acc);
	}

	public Account findByName(String name) {
		return repository.findByUsername(name);
	}
	
	public Account findById(Long id) {
		return repository.findById(id).get();
	}
}
