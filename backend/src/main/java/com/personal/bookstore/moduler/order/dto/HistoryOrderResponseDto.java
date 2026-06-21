package com.personal.bookstore.moduler.order.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import com.personal.bookstore.moduler.book.dto.HisOrderBookResponseDto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class HistoryOrderResponseDto {
	
	private String orderCode;
	
	private String orderStatus;
	
	private List<HisOrderBookResponseDto> carts;
	
	private String accountName;
		
	private String address;
	
	private String phone;
	
	private BigDecimal shippingFee;
	
	private String shippingMethod;
	
	private String paymentMethod;
	
	private LocalDateTime createDate;
	
	private BigDecimal productDiscountAmount;
	
	private BigDecimal finalTotalPrice;
	
	private LocalDateTime receiveDate;

	
}
