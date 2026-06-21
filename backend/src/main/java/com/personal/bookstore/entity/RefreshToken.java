package com.personal.bookstore.entity;

import java.time.Instant;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Entity(name = "refresh_token")
@Data
@Getter
@Setter
public class RefreshToken {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(name ="user_id")
	private Long userId;
	
	@Column(name ="token_hash")
	private String tokenHash;
	
	@Column(name ="expires_at")
	private Instant expiresAt ;
	
	@Column(name ="created_at")
	private Instant createdAt ;
	
	// Chặn sử dụng token khi logout, lộ token, không kiểm soát được session
	@Column
	private boolean revoked ;
	
}
