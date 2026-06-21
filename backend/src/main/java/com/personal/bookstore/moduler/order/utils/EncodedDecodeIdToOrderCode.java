package com.personal.bookstore.moduler.order.utils;

import org.hashids.Hashids;
import org.springframework.stereotype.Component;

@Component
public class EncodedDecodeIdToOrderCode {
	
	private static final String secretKey ="Book@Store26";
	
	public String encode(Long id) {
		return new Hashids(secretKey, 6).encode(id);
	}
	
	public Long decode(String code) {
		return new Hashids(secretKey, 6).decode(code)[0];
	}

}
