package com.personal.bookstore.moduler.auth.service;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Base64;
import java.util.NoSuchElementException;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.personal.bookstore.entity.RefreshToken;
import com.personal.bookstore.repository.RefreshTokenRepository;

import jakarta.servlet.http.HttpServletRequest;

@Service
@Transactional
public class RefreshTokenService {

	@Autowired
	private RefreshTokenRepository repository;

	public RefreshToken verify(String rawToken) {

		return repository.findByTokenHash(rawToken).orElseThrow(() -> new RuntimeException("Invalid token"));
	}
	
	public RefreshToken create(String email, String provider, Long userId) {
		String token = UUID.randomUUID().toString();
		// lưu DB (email, provider, expiry, revoked=false)
		RefreshToken refreshToken = new RefreshToken();
		refreshToken.setUserId(userId);
		try {
			refreshToken.setTokenHash(hash(token));
		} catch (NoSuchAlgorithmException e) {

		}
		Instant now = Instant.now();
		refreshToken.setCreatedAt(now);
		refreshToken.setExpiresAt(now.plus(7, ChronoUnit.DAYS));
		refreshToken.setRevoked(false);
		RefreshToken ref = repository.save(refreshToken);
		if (ref == null) {
			throw new RuntimeException("RefreshToken chưa được lưu");
		}
		return ref;
	}

	//cấp refresh token mới (B)
	//vô hiệu hóa (revoke) token cũ (A)
//	public String rotate(RefreshToken oldToken) {
//		oldToken.setRevoked(true);
//		repository.save(oldToken);
//
//		String newToken = UUID.randomUUID().toString();
//
//		RefreshToken newEntity = new RefreshToken();
//		newEntity.setUserId(oldToken.getUserId());
//		
//		try {
//			newEntity.setTokenHash(hash(newToken));
//		} catch (NoSuchAlgorithmException e) {
//			
//		}
////		newEntity.setExpiresAt();
//
//		repository.save(newEntity);
//
//		return newToken;
//	}

	public boolean validate(RefreshToken token) {
		// check DB:
		// - tồn tại
		// - chưa expired
		// - chưa revoke
		try {
			RefreshToken refreshToken = findByTokenHash(token.getTokenHash()).get();
			Instant now = Instant.now();
			return refreshToken.getExpiresAt().isAfter(now);
		} catch (Exception e) {
			return false;
		}
	}

	public void revoke(String token) {
		// mark revoked khi co nhieu user dung cung refreshToken or token da cu
		// khi user logout  revoked token hien tai
	}

	private String hash(String refreshToken) throws NoSuchAlgorithmException {
		MessageDigest digest = MessageDigest.getInstance("SHA-256");
	    byte[] hash = digest.digest(refreshToken.getBytes());
	    return Base64.getEncoder().encodeToString(hash);

	}

	public String extractCookie(HttpServletRequest request) {
		String token = request.getParameter("refreshToken");
		return token;
	}

	public String getRefreshTokenService(String username) {
		return null;
	}

	public Optional<RefreshToken> findByTokenHash(String tokenHash) {
		return repository.findByTokenHash(tokenHash);
	}
	
	public boolean deleteByTokenHash(String tokenHash) {
		Optional<RefreshToken> op = repository.findByTokenHash(tokenHash);
		if(op.isEmpty()) {
			throw new NoSuchElementException("RefreshToken khong ton tai");
		}
		return repository.deleteByTokenHash(tokenHash) != 0;
	}
}