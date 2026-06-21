package com.personal.bookstore.moduler.auth.handler;

import java.io.IOException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;
import com.personal.bookstore.common.exception.ErrorCode;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

//Request -> Security Filter
//-> kiểm tra auth
//-> chưa login
//-> gọi AuthenticationEntryPoint.commence()

@Component
public class CustomAuthenticationEntryPoint implements AuthenticationEntryPoint {

	@Override
	public void commence(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException authException) throws IOException, ServletException {
		// Xử lí gửi về error code khi login chưa được

		response.setContentType("application/json");
		if (response.getStatus() == HttpServletResponse.SC_UNAUTHORIZED) {
			response.getWriter().write("""
					{
					  "code": %d
					}
					""".formatted(ErrorCode.Code.INVALID_TOKEN));
			return;
		}
		response.getWriter().write("""
					    {
				        "message": "%s"
				    }
				""".formatted(authException.getMessage()));

		authException.getMessage();
	}

}
