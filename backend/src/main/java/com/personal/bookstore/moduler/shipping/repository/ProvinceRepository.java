package com.personal.bookstore.moduler.shipping.repository;

import java.util.Optional;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.Province;

@Repository
public interface ProvinceRepository extends CrudRepository<Province, Long>{
	
	Optional<Province> findByName(String name);
	
	Province save(Province province);
	
}
