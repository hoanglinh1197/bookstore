package com.personal.bookstore.moduler.shipping.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ShippingFeeRequestFromClient {
	
	private String province;

    private String district;

    private String ward;

    private List<ShortTypeBook> books;
}
