package com.personal.bookstore.entity;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

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
public class ShippingMethod {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(nullable=false, unique=true)
	private String code;
	
	@Column( nullable = false)
	private String name;
	
	@Column 
	String description;
	
	@Column( nullable = false)
	private Integer estimatedDays;
	
	@CreationTimestamp 
	// Tu gan thoi gian hien tai luc tao
	// TIMESTAMP
	private LocalDateTime createdAt;

	@UpdateTimestamp
	// Tu dong cap nhat tg moi lan sua
	// Don hang duoc chinh sua lan cuoi
	private LocalDateTime updatedAt;
}
