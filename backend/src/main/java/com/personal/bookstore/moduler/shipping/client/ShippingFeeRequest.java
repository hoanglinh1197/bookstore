package com.personal.bookstore.moduler.shipping.client;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ShippingFeeRequest {
	
	private Long toDistrictId;
	
	private String toWardCode;
	
	private Integer weight;
	

}
