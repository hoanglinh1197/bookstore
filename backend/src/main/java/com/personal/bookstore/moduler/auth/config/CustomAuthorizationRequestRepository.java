package com.personal.bookstore.moduler.auth.config;

import java.util.HashMap;
import java.util.Map;

import org.springframework.security.oauth2.client.web.AuthorizationRequestRepository;
import org.springframework.security.oauth2.client.web.HttpSessionOAuth2AuthorizationRequestRepository;
import org.springframework.security.oauth2.core.endpoint.OAuth2AuthorizationRequest;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class CustomAuthorizationRequestRepository
		implements AuthorizationRequestRepository<OAuth2AuthorizationRequest> {

	private final HttpSessionOAuth2AuthorizationRequestRepository defaultRepo = new HttpSessionOAuth2AuthorizationRequestRepository();

	@Override
	public OAuth2AuthorizationRequest loadAuthorizationRequest(HttpServletRequest request) {
		return defaultRepo.loadAuthorizationRequest(request);
	}

	@Override
	public void saveAuthorizationRequest(OAuth2AuthorizationRequest authorizationRequest, HttpServletRequest request,
			HttpServletResponse response) {
		System.out.println("Vao ham saveAuthorizationRequest");
		// lấy returnUrl từ query param
		String returnUrl = request.getParameter("returnUrl");
		
		if (returnUrl != null) {
			Map<String, Object> extraParams = new HashMap<>(authorizationRequest.getAdditionalParameters());
			extraParams.put("returnUrl", returnUrl);
			System.out.println("RETURN URL ------------------------------------------- "+ returnUrl);
			authorizationRequest = OAuth2AuthorizationRequest.from(authorizationRequest)
					.additionalParameters(extraParams).build();
		}

		defaultRepo.saveAuthorizationRequest(authorizationRequest, request, response);
	}


	@Override
	public OAuth2AuthorizationRequest removeAuthorizationRequest(HttpServletRequest request, HttpServletResponse response) {
		OAuth2AuthorizationRequest authRequest =
	            defaultRepo.loadAuthorizationRequest(
	                    request);

	    if (authRequest != null) {

	        String returnUrl =
	                (String) authRequest
	                        .getAdditionalParameters()
	                        .get("returnUrl");

	        request.getSession()
	               .setAttribute(
	                   "RETURN_URL",
	                   returnUrl);
	        System.out.println("Vao removeAuthorizationRequest ------------- RETURN_URL------------------------------"+ returnUrl);
	    }
		return defaultRepo.removeAuthorizationRequest(request, response);
	}
}