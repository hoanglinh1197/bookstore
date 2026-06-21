package com.personal.bookstore.moduler.shipping.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ShortTypeBook {
	private Long bookId;
	
	private Integer quantity;
}
