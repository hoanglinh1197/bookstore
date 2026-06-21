package com.personal.bookstore.moduler.auth.handler;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseCookie;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.personal.bookstore.entity.Account;
import com.personal.bookstore.entity.RefreshToken;
import com.personal.bookstore.entity.User;
import com.personal.bookstore.moduler.auth.service.RefreshTokenService;
import com.personal.bookstore.service.AccountService;
import com.personal.bookstore.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class OAuth2SuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

	@Autowired
	private RefreshTokenService refreshTokenService;

	@Autowired
	private UserService userService;
	
	@Autowired
	private AccountService accountService;
	// Vai tro luu db user data va refreshToken 
	// setcookie chua refreshToken va redirect vef client -> client nhan va gui api ve thong tin user
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws IOException {
		OAuth2AuthenticationToken token = (OAuth2AuthenticationToken) authentication;
		System.out.println("Vao onAuthenticationSuccess");
		OAuth2User oauth2User = token.getPrincipal();
		String email = oauth2User.getAttribute("email");
		User user = checkUserAccountAndUpdate(email, 1L);
		String provider = token.getAuthorizedClientRegistrationId();
		
		// Tạo refresh token, lưu reFreshToken xuống db
		RefreshToken refToken = refreshTokenService.create(email, provider, user.getId());
		long expireTime = refToken.getExpiresAt().toEpochMilli()-refToken.getCreatedAt().toEpochMilli();

		// Lay returnUrl de tro ve trang client dang hien thi
	    String returnUrl = (String) request.getSession().getAttribute("RETURN_URL");
	    if (returnUrl == null) {
	        returnUrl = "/";
	    }
		System.out.println("Trang o client la--------------------------------: "+ returnUrl);
		// K tao token lan goi api dau tien se check bang refreshToken
		// set cookie
		ResponseCookie cookie = ResponseCookie.from("refreshToken", refToken.getTokenHash()).httpOnly(true).secure(true)
				.sameSite("Strict").path("/").maxAge(expireTime).build();
		response.setContentType("application/json");
		response.setHeader("Set-Cookie", cookie.toString());
		System.out.println("Login gg thanh cong va setCookie voi refreshToken la: "+ refToken.getTokenHash());
		getRedirectStrategy().sendRedirect(request, response, "http://localhost:5173/auth/success?returnUrl=" + URLEncoder.encode(returnUrl, StandardCharsets.UTF_8));
		
	}
	
	private User checkUserAccountAndUpdate(String email, Long roleId){
		Optional<User> optional = userService.findByEmail(email);
		User result;
		try {
			result = optional.get();
		}catch (NoSuchElementException e) {
			User user  = new User();
			user.setEmail(email);
			user.setRoleId(roleId);
			result = userService.save(user);
			
			Account account = new Account();
			account.setUsername(email);
			account.setPassword(null);
			account.setUserId(user.getId());
			accountService.save(account);
		}
		return result;
	}
 
}