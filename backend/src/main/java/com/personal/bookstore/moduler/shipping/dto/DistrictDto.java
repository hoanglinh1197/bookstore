package com.personal.bookstore.moduler.shipping.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DistrictDto {
	
	@JsonProperty("DistrictID")
    private Long districtId;

    @JsonProperty("DistrictName")
    private String districtName;
}
