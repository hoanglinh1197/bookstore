package com.personal.bookstore.repository;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.RefreshToken;

@Repository
public interface RefreshTokenRepository extends CrudRepository<RefreshToken, Long> {

    Optional<RefreshToken> findByTokenHash(String tokenHash);
    
    RefreshToken save(RefreshToken refreshToken);
    
    // tra ve so ban ghi da xoa
    long deleteByTokenHash(String tokenHash);
    

}