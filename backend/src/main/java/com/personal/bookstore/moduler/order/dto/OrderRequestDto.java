package com.personal.bookstore.moduler.order.dto;

import java.math.BigDecimal;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class OrderRequestDto {
	
	private List<CartItem> cart;
	
	private String accountName;
	
	private Long discountShippingMethodId;
	
	private String address;
	
	private String phone;
	
	private BigDecimal shippingFee;
	
	private BigDecimal totalPrice;
	
	// Chua them truong vao db, mac dinh cod
	private String methodPayment;
	
	// mac dinh giao hang tieu chuan 1, chinh sua sau
	private Long shippingMethodId;
	
	// chua
	private BigDecimal voucherDiscountAmount;
	
	// chua
	private BigDecimal shippingDiscountAmount;
	

}
