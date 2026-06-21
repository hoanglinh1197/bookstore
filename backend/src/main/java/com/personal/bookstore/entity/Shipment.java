package com.personal.bookstore.entity;

import java.math.BigDecimal;

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
public class Shipment {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(nullable = false)
	private Long orderId;
	
	@Column(nullable = false)
	private Long shippingMethodId;
	
	@Column(nullable = false)
	// Don vi van chuyen sinh ra -  o day minh se random 
	private String shippingProvider;
	
	@Column(nullable = false)
	private BigDecimal fee;
	
	@Column(nullable=false)
	private String status;
	
	
}
