package com.personal.bookstore.entity;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

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
@Table(name = "orders")
@AllArgsConstructor
@NoArgsConstructor
public class Order {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(nullable = false)
	private Long accountId;
	
	@Column(nullable = false)
	private Long shippingMethodId;
	
	@Column(nullable = false)
	private Long shippingStatusId;
	
	@Column(nullable = false)
	private Long orderStatusId;
	
	@Column(nullable = false)
	private String address;
	
	@Column(nullable = false)
	private String sdt;
	
	@Column(nullable = false)
	// tong gia giam cua don hang tinh rieng sp
	private BigDecimal productDiscountAmount;
	
	@Column(nullable = false)
	private BigDecimal shippingFee;
	
	@Column(nullable = false)
	private BigDecimal shippingDiscountAmount;
	
	@Column(nullable = false)
	// giam gia cho don hang
	private BigDecimal voucherDiscountAmount;
	
	@Column(nullable = false)
	private BigDecimal finalTotalPrice;

	@Column
	// TIMESTAMP
	private LocalDateTime receivedDate;
	
	@CreationTimestamp 
	private LocalDateTime createdAt;

	@UpdateTimestamp
	private LocalDateTime updatedAt;
	
	
}
