package com.personal.bookstore.moduler.book.dto;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class HisOrderBookResponseDto extends BookDto{
	
	private Integer quantity;
	
	private String distributor;

}
