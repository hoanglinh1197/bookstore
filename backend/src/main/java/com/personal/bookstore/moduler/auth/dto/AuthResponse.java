package com.personal.bookstore.moduler.auth.dto;

public class AuthResponse {
	
	    private String accessToken;
	    private String email;

	    public AuthResponse(String accessToken, String email) {
	        this.accessToken = accessToken;
	        this.email = email;
	    }

	    public String getAccessToken() {
	        return accessToken;
	    }

	    public String getEmail() {
	        return email;
	    }
}
