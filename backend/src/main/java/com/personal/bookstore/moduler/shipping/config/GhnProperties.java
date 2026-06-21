package com.personal.bookstore.moduler.shipping.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import lombok.Getter;
import lombok.Setter;

@Configuration
@ConfigurationProperties(prefix = "ghn")
@Getter
@Setter
public class GhnProperties {
	
	private String token;

    private Long shopId;
    
    private String baseUrl;

    private Long fromDistrictId;
    
    private String fromWardCode;
}
