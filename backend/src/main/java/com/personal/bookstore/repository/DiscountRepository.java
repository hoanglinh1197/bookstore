package com.personal.bookstore.repository;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.Discount;

@Repository
public interface DiscountRepository extends CrudRepository<Discount, Long>{
	Optional<Discount> findById(Long id);
}
