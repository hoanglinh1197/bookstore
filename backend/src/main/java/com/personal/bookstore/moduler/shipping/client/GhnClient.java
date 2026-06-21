package com.personal.bookstore.moduler.shipping.client;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.personal.bookstore.moduler.shipping.config.GhnProperties;
import com.personal.bookstore.moduler.shipping.dto.GhnDistrictReponse;
import com.personal.bookstore.moduler.shipping.dto.GhnProvinceResponse;
import com.personal.bookstore.moduler.shipping.dto.GhnWardResponse;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class GhnClient {

	private final RestTemplate restTemplate;

	private final GhnProperties ghnProperties;

	public GhnProvinceResponse getProvinces() {
		HttpEntity<?> entity = setHeader(null);
		ResponseEntity<GhnProvinceResponse> response = restTemplate.exchange(
				ghnProperties.getBaseUrl() + "/shiip/public-api/master-data/province", HttpMethod.GET, entity,
				GhnProvinceResponse.class);

		return response.getBody();
	}

	public GhnDistrictReponse getDistrict(Long provinceId) {
		Map<String, Object> body = new HashMap<>();
		body.put("province_id", provinceId);
		HttpEntity<?> entity = setHeader(body);
		ResponseEntity<GhnDistrictReponse> response = restTemplate.exchange(
				ghnProperties.getBaseUrl() + "/shiip/public-api/master-data/district", HttpMethod.POST, entity,
				GhnDistrictReponse.class);
		return response.getBody();
	}

	public GhnWardResponse getWardCode(Long districtId) {
		Map<String, Object> body = new HashMap<>();
		body.put("district_id", districtId);
		HttpEntity<?> entity = setHeader(body);
		ResponseEntity<GhnWardResponse> response = restTemplate.exchange(
				ghnProperties.getBaseUrl() + "/shiip/public-api/master-data/ward", HttpMethod.POST, entity,
				GhnWardResponse.class);
		return response.getBody();
	}

	public BigDecimal calculateFee(ShippingFeeRequest request) {

		String url = ghnProperties.getBaseUrl() + "/shiip/public-api/v2/shipping-order/fee";

		HttpHeaders headers = new HttpHeaders();

		headers.set("Token", ghnProperties.getToken());

		headers.set("ShopId", String.valueOf(ghnProperties.getShopId()));

		headers.setContentType(MediaType.APPLICATION_JSON);

		Map<String, Object> body = new HashMap<>();
		
		System.out.println("Tu - from_district_id: "+ ghnProperties.getFromDistrictId()+" - from_ward_code: "+ ghnProperties.getFromWardCode()
		+"/n Den - to_district_id: "+ request.getToDistrictId()+ " - to_ward_code: "+ request.getToWardCode());
		
		// 1: giao hang nhanh, 2: giao hang tieu chuan
		body.put("service_type_id", 2);

        body.put("from_district_id",
                ghnProperties.getFromDistrictId());
        
        body.put("from_ward_code", ghnProperties.getFromWardCode());

        body.put("to_district_id",
                request.getToDistrictId());

        body.put("to_ward_code",
                request.getToWardCode());

        // height,length, width tam thoi set cung do chua tao data
		body.put("height", 10);
		body.put("length", 20);
		body.put("weight", request.getWeight());
		body.put("width", 20);

		HttpEntity<?> entity = new HttpEntity<>(body, headers);

		ResponseEntity<Map> response = restTemplate.exchange(url, HttpMethod.POST, entity, Map.class);

		Map data = (Map) response.getBody().get("data");
		Number total = (Number) data.get("total");
		return BigDecimal.valueOf(total.doubleValue()) ;
	}

	private HttpEntity<?> setHeader(Map<String, Object> body) {
		HttpHeaders headers = new HttpHeaders();
		headers.set("Token", ghnProperties.getToken());
		HttpEntity<?> entity;
		if (body != null) {
			headers.setContentType(MediaType.APPLICATION_JSON);
			entity = new HttpEntity<>(body, headers);
		} else {
			entity = new HttpEntity<>(headers);
		}

		return entity;
	}

}
