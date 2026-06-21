package com.personal.bookstore.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.Account;

@Repository
public interface AccountRepository extends CrudRepository<Account, Long>{
	
	Account save(Account acc);
	
	Account findByUsername(String name);
	
}
