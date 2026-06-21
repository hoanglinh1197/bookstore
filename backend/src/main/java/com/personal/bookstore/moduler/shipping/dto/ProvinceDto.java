package com.personal.bookstore.moduler.shipping.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProvinceDto {
	
	@JsonProperty("ProvinceID")
    private Long provinceId;

    @JsonProperty("ProvinceName")
    private String provinceName;
}
