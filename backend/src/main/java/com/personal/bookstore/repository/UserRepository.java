package com.personal.bookstore.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.User;

@Repository
public interface UserRepository extends CrudRepository<User, Long> {
	
	Optional<User> findById(Long id);
	Optional<User> findByEmail(String email);
	
	List<User> findByEmailContaining(String name);
	List<User> findByGender(Integer gender);
	
	User save(User user);

	
	
	
	
	
}
