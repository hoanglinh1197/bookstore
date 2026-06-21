package com.personal.bookstore.moduler.book.dto;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BookDto {

	private Long id;

	private String name;

	private String imgSrc;

	private BigDecimal price;
	
	private BigDecimal discount;
	
	private BigDecimal discountPrice;

}
