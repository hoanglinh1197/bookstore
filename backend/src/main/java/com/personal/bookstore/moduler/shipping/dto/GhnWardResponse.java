package com.personal.bookstore.moduler.shipping.dto;

import java.util.List;


import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GhnWardResponse {
	
    private Integer code;

    private String message;

    private List<WardDto> data;
}