package com.personal.bookstore.moduler.shipping.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.Province;
import com.personal.bookstore.moduler.shipping.repository.ProvinceRepository;

import jakarta.transaction.Transactional;

@Service
@Transactional
public class GhnProvinceService {

	@Autowired
	private ProvinceRepository provinceRepository;

	public boolean hasData() {
		boolean result = false;
		try {
			if (provinceRepository.count() > 0)
				return true;
		} catch (Exception e) {
			
		}
		return result;
	}

	public Optional<Province> findByName(String name) {
		return provinceRepository.findByName(name);
	}

	public Province save(Province province) {
		return provinceRepository.save(province);
	}
}
