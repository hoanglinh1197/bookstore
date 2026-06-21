package com.personal.bookstore.entity;

import java.math.BigDecimal;
import java.time.Instant;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@AllArgsConstructor(access = AccessLevel.PROTECTED)
@NoArgsConstructor
public class Discount {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(nullable = false)
	private String code;
	
	@Column(name="start_date", nullable = false)
	private Instant startDate;
	
	@Column(name="exp_date", nullable = false)
	private Instant expDate;
	
	@Column(name = "discount_type", nullable = false)
	private String discountType;
	
	@Column(nullable = false)
	private BigDecimal value;
	


}
