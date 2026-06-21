package com.personal.bookstore.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

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
public class Book {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
	@Column(nullable = false)
	private String name;
	
	@Column(nullable = false)
	private Long categoryId;
	
	@Column(columnDefinition = "LONGTEXT")
	private String description;
	
	@Column(name="img_src", nullable = false)
	private String imgSrc;
	
	@Column(nullable = false)
	private BigDecimal price;
	
	@Column(nullable = false)
	private String status;
	
	@Column(name = "publish_date")
	private LocalDate publishDate;
	
	@Column(nullable = false)
	private String author;
	
	@Column
	private String translator;
	
	@Column
	private String publisher;
	
	@Column
	private String distributor;
	
	@Column(name="page_count", nullable = false)
	private Integer pageCount;
	
	@Column(name = "cover_type", nullable= false)
	private String coverType;
	
	@Column(nullable = false)
	private Integer weight;
	
	@Column
	private Integer stockQuantity;
	
	@Column
	private Long discountId;

}
