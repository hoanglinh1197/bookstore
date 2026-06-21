package com.personal.bookstore.entity;
import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class OrderItem {
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(nullable = false)
	private Long orderId;
	
	@Column(nullable = false)
	private Long bookId;
	
	@Column(nullable = false)
	private Integer quantity;
	
	@Column(nullable = false)
	// Gia sach tai thoi diem mua gia sach chua ap discount
	private BigDecimal  unitPrice; 
}
