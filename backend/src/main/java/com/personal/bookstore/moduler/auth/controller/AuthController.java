package com.personal.bookstore.moduler.auth.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.personal.bookstore.common.exception.ErrorCode;
import com.personal.bookstore.entity.RefreshToken;
import com.personal.bookstore.entity.User;
import com.personal.bookstore.moduler.auth.service.JwtService;
import com.personal.bookstore.moduler.auth.service.RefreshTokenService;
import com.personal.bookstore.service.UserService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

	@Autowired
	private RefreshTokenService refreshTokenService;

	@Autowired
	private JwtService jwtService;

	@Autowired
	private UserService userService;

	@PostMapping("/me")
	public ResponseEntity<?> me(@CookieValue(name = "refreshToken", required = false) String tokenHash) {
		// Check refreshToken
		System.out.println("Vao api auth/me");
		Long userId = refreshTokenService.findByTokenHash(tokenHash).get().getUserId();
		User user = userService.findById(userId).get();
		String accessToken = jwtService.generateAccessToken(user);
		System.out.println("Luu refreshToken");
		Map<String, String> map = new HashMap<String, String>();
		map.put("accessToken", accessToken);
		map.put("username", user.getEmail());
		return ResponseEntity.ok(map);
	}

	@PostMapping("/refresh")
	public ResponseEntity<?> refresh(@CookieValue(name = "refreshToken", required = true) String refreshToken) {
		Map<String, String> map = new HashMap<String, String>();
		System.out.println("RefreshToken: " + refreshToken);
		
		if (refreshToken == null) {
			System.out.println("Ham refresh -> RefreshToken khong co");
			map.put("code", String.valueOf(ErrorCode.Code.INVALID_REF_TOKEN.getValue()));
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(map);
		}
		
		System.out.println("Gia han accessToken");
		// 1. validate refresh token
		RefreshToken rfToken = null;
		ResponseCookie cookie = null;
		String newAccessToken = "";
		try {
			rfToken = refreshTokenService.verify(refreshToken);
			// 2. kiểm tra revoked / expired
			if (!refreshTokenService.validate(rfToken)) {
				throw new RuntimeException("refreshToken het han");
			}

			// 3. lấy user
			User user = null;
			try {
				user = userService.findById(rfToken.getUserId()).get();
				// 4. tạo access token mới
				newAccessToken = jwtService.generateAccessToken(user);

				// 5. rotate refresh token (quan trọng) tạo mới refreshTK và token, xoa refresh cu va tao moi
//				newRefreshToken = refreshTokenService.rotate(token);

				// 6. set lại cookie
//				cookie = ResponseCookie.from("refreshToken", newRefreshToken).httpOnly(true).secure(true) // production
//						.sameSite("None").path("/").maxAge(7 * 24 * 60 * 60).build();

			} catch (Exception e) {
				System.out.println("Ham refresh - Khong tim thay user");
			}
		} catch (RuntimeException e) {
			// verify false - refreshToken k co trong db
			cookie = ResponseCookie.from("refreshToken", "").httpOnly(true).secure(true) // production
					.sameSite("None").path("/").build();


			map.put("code", String.valueOf(ErrorCode.Code.INVALID_REF_TOKEN.getValue()));
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).header(HttpHeaders.SET_COOKIE, cookie.toString()).body(map);
		}
		map.put("accessToken", newAccessToken);
		return ResponseEntity.ok()
				.body(map);
	}

	private String extractFromCookie(HttpServletRequest request) {
		if (request.getCookies() == null)
			return null;
		System.out.println("RefreshToKen: " + Arrays.stream(request.getCookies())
				.filter(c -> "refreshToken".equals(c.getName())).map(Cookie::getValue).findFirst().get());
		return Arrays.stream(request.getCookies()).filter(c -> "refreshToken".equals(c.getName())).map(Cookie::getValue)
				.findFirst().orElse(null);
	}

	@PostMapping("/logout")
	public ResponseEntity<?> logout(HttpServletRequest request, HttpServletResponse response) {

		String refreshToken = extractFromCookie(request);
		String redirectUrl = request.getRequestURI();
		System.out.println("Ham logout kiem tra requestUri: " + redirectUrl);

//		refreshTokenService.revoke(refreshToken);
		boolean isSuccessful = refreshTokenService.deleteByTokenHash(refreshToken);
		System.out.println("Da xoa refreshToken chua? " + isSuccessful);

		ResponseCookie cookie = ResponseCookie.from("refreshToken", "").path("/").maxAge(0).build();
		System.out.println("Set lai cookie: " + cookie.getValue());

		Map<String, String> map = new HashMap<String, String>();
		System.out.println("redirectUrl: " + request.getRequestURI());

		return ResponseEntity.ok().header("Set-Cookie", cookie.toString()).body(map);
	}

}
