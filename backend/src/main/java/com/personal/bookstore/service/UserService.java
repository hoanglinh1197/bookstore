package com.personal.bookstore.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.personal.bookstore.entity.User;
import com.personal.bookstore.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserService {
	
	@Autowired
	private UserRepository userRepository;
	
	public boolean isExisted(String email) {
		Optional<User> op = findByEmail(email);
		System.out.println("email: "+ email + "co ton tai k: "+ !op.isEmpty());
		return !op.isEmpty();
	}
	
	
	public Optional<User> findById(Long id) {
		return userRepository.findById(id);
	}
	

	public Optional<User> findByEmail(String email){
		return userRepository.findByEmail(email);
	}
	

	public List<User> findByGender(Integer gender){
		return userRepository.findByGender(gender);
	}
	
	@Transactional
	public User save(User user) {
		return userRepository.save(user);
	}
	
	
	
	
}
