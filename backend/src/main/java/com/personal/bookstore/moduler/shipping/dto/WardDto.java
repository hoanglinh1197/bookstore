package com.personal.bookstore.moduler.shipping.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class WardDto {
	
	@JsonProperty("WardCode")
    private String wardCode;

    @JsonProperty("WardName")
    private String wardName;
}
