package com.personal.bookstore.repository;


import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.RefreshToken;

@Repository
public interface TokenRepository extends CrudRepository<RefreshToken, Long>{
	

}
