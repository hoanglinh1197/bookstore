package com.personal.bookstore.moduler.shipping.dto;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GhnProvinceResponse {
	
    private Integer code;

    private String message;

    private List<ProvinceDto> data;

}
