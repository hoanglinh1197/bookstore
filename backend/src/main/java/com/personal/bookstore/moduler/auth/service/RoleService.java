package com.personal.bookstore.moduler.auth.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.Role;
import com.personal.bookstore.repository.RoleRepository;

@Service
public class RoleService {
	
	@Autowired
	private RoleRepository roleRepository;
	
	public Optional<Role> findById(Long id){
		return roleRepository.findById(id);
	}
}
