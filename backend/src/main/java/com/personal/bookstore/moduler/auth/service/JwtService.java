package com.personal.bookstore.moduler.auth.service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.User;

import javax.crypto.SecretKey;

import java.time.Instant;
import java.util.Base64;
import java.util.Date;

@Service
public class JwtService {
	
	@Autowired
	private RefreshTokenService refreshTokenService;

    private final String SECRET = "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"; // >= 32 bytes

    public JwtService() {
	}

	private SecretKey getKey() {
        return Keys.hmacShaKeyFor(
            Base64.getEncoder().encode(SECRET.getBytes())
        );
    }

    // tạo access token
    public String generateAccessToken(User user) {
    	Instant now = Instant.now();
    	Instant expiresAt = now.plusSeconds(60);
    	
//    	now.plus(7, ChronoUnit.DAYS);
        return Jwts.builder()
                .setSubject(user.getEmail())
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(expiresAt))
                .signWith(getKey())
                .compact();
    }

    // parse token
    public Claims parseToken(String token) throws ExpiredJwtException{
    	
        return Jwts.parser()
                .verifyWith(getKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    public String extractUserfromToken(String token) throws ExpiredJwtException{
        return parseToken(token).getSubject();
    }

    public boolean hasExpired(String token) throws ExpiredJwtException{
        // kiem tra token nay da het han chua
    	Claims payload = parseToken(token);
    	Instant issueAt = payload.getIssuedAt().toInstant();
    	Instant expiredDate = payload.getExpiration().toInstant();
    	System.out.println("Còn  hạn k?  "+ issueAt.isBefore(expiredDate) +"/n"+ Date.from(expiredDate).toLocaleString());
    	if(issueAt.isAfter(expiredDate)) return false;
    	return true;
    }
}