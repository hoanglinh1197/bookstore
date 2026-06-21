package com.personal.bookstore.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table
@AllArgsConstructor
@NoArgsConstructor
public class ShippingRate {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(nullable = false)
	private Long shippingMethodId;
	
	@Column(nullable = false)
	private Long shippingZoneId;
	
	@Column(nullable = false)
	private Integer minWeightGr;
	
	@Column(nullable = false)
	private Integer maxWeightGr;
	
	@Column(nullable = false)
	private BigDecimal fee;
	
	@Column(nullable = false, columnDefinition = "BOOLEAN DEFAULT TRUE")
	private Boolean isActive;
	
}
