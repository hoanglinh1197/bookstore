package com.personal.bookstore.moduler.order.dto;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CartItem {
	
	private Long id;
	
	 private String name;
	 
	 private BigDecimal price;
	 
	 private BigDecimal discountPrice;
	 
	 private BigDecimal discount;
	 
	 private Integer quantity;

	 
}
