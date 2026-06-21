package com.personal.bookstore.moduler.auth.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.User;
import com.personal.bookstore.service.UserService;

@Service
public class UserDetailsServiceImpl implements UserDetailsService{

	@Autowired
	private UserService userService;
	
	@Autowired
	private RoleService roleService;
	
	// day la ham check authenticated login thuong
	// chay o DaoAuthenticationProvider
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		// Lay role cua username
		//mục đích:
		//lấy user từ DB
		//lấy password hash + role
		//so sánh password
		
		User user = userService.findByEmail(username).orElseThrow(() -> new UsernameNotFoundException("User not found"));
 		List<SimpleGrantedAuthority> authorization = roleService.findById(user.getId()).stream().map(role -> new SimpleGrantedAuthority(role.getRole())).toList();
		
 		return new org.springframework.security.core.userdetails.User(username, null, authorization);
	}
	

}
