package com.personal.bookstore.moduler.shipping.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.Book;
import com.personal.bookstore.entity.Province;
import com.personal.bookstore.moduler.book.service.BookService;
import com.personal.bookstore.moduler.shipping.client.GhnClient;
import com.personal.bookstore.moduler.shipping.client.ShippingFeeRequest;
import com.personal.bookstore.moduler.shipping.dto.DistrictDto;
import com.personal.bookstore.moduler.shipping.dto.GhnProvinceResponse;
import com.personal.bookstore.moduler.shipping.dto.ProvinceDto;
import com.personal.bookstore.moduler.shipping.dto.ShippingFeeRequestFromClient;
import com.personal.bookstore.moduler.shipping.dto.ShortTypeBook;
import com.personal.bookstore.moduler.shipping.dto.WardDto;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class GhnShippingService {

	@Autowired
	private GhnProvinceService ghnProvinceService;

	@Autowired
	private BookService bookService;

	private final GhnClient ghnClient;

	public BigDecimal getShippingFee(ShippingFeeRequestFromClient req) {
		// tu req client tinh ra weight, va lay provinceId, districtId va wardCode
		Long provinceId = Long.valueOf(0), districtId = Long.valueOf(0);
		String wardCode = "";
		if (ghnProvinceService.hasData()) {
			provinceId = ghnProvinceService.findByName(req.getProvince()).get().getGhnProvinceId();
			System.out.println("ProvinceId la: "+provinceId);
		} else {
			System.out.println("Khong co du lieu province");
			// Lay data tu ghn va save vao bang province
			provinceId = saveProvinceFromGhn(req.getProvince());
		}

		districtId = findDistrictIdForShippingFee(provinceId, req.getDistrict());
		wardCode = findWardCodeForShippingFee(districtId, req.getWard());

		Integer weight = calWeightFrClient(req.getBooks());

		ShippingFeeRequest request = new ShippingFeeRequest();
		request.setToDistrictId(districtId);
		request.setToWardCode(wardCode);
		request.setWeight(weight);
		BigDecimal fee = ghnClient.calculateFee(request);
		System.out.println("Chi phi cua kien hang: "+ weight.intValue());

		return fee;
	}

	public GhnProvinceResponse getProvinces() {
		return ghnClient.getProvinces();
	}

	private Integer calWeightFrClient(List<ShortTypeBook> booksFromClient) {
		Integer weight = 0;
		for (ShortTypeBook b : booksFromClient) {
			Book book = bookService.getBook(b.getBookId());
			weight += book.getWeight() * b.getQuantity();
		}
		System.out.println("Can nag cua kien hang: "+ weight.intValue());
		return weight;
	}

	private Long saveProvinceFromGhn(String provinceName) {
		Long provinceId = Long.valueOf(0);
		GhnProvinceResponse ghnProvince = ghnClient.getProvinces();
		List<ProvinceDto> ghnProvinceResponse = ghnProvince.getData();
		for (ProvinceDto dto : ghnProvinceResponse) {
			if (dto.getProvinceName().equalsIgnoreCase(provinceName)) {
				provinceId = dto.getProvinceId();
			}
			Province province = new Province();
			province.setGhnProvinceId(dto.getProvinceId());
			province.setName(dto.getProvinceName());
			ghnProvinceService.save(province);
		}
		// Xu li neu provinceId = 0
		System.out.println("provinceId la: "+provinceId.intValue());
		return provinceId;
	}

	private Long findDistrictIdForShippingFee(Long provinceId, String districtName) {
		Long districtId = Long.valueOf(0);
		List<DistrictDto> districts = ghnClient.getDistrict(provinceId).getData();
		System.out.println("Ten quan /t Input:"+districtName);
		for (DistrictDto dto : districts) {
			System.out.println(dto.getDistrictName());
			if (dto.getDistrictName().contains(districtName)) {
				districtId = dto.getDistrictId();
			}
		}
		System.out.println("districtId la: "+districtId.intValue());

		return districtId;
	}

	private String findWardCodeForShippingFee(Long districtId, String wardName) {
		String wardCode = "";
		List<WardDto> wards = ghnClient.getWardCode(districtId).getData();
		for (WardDto dto : wards) {
			if (dto.getWardName().contains(wardName)) {
				wardCode = dto.getWardCode();
			}
		}
		return wardCode;
	}

}
