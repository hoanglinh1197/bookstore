package com.personal.bookstore.moduler.auth.config;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.personal.bookstore.common.exception.ErrorCode;
import com.personal.bookstore.moduler.auth.service.JwtService;
import com.personal.bookstore.moduler.auth.service.UserDetailsService;

import io.jsonwebtoken.ExpiredJwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

	@Autowired
	private JwtService jwtService;

	@Autowired
	private UserDetailsService userDetailsService;

	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException {

		// Chay bat cu khi nao co req

		String header = request.getHeader("Authorization");
		if (header != null && header.startsWith("Bearer ")) {

			String token = header.substring(7);
			System.out.println("Token la " + token);
			try {
				if (jwtService.hasExpired(token)) {

					// UserDetails ở đay chỉ để spring check authentication trong hàm
					// isAuthenticated
					String username = jwtService.extractUserfromToken(token);

					UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(username, null,
							userDetailsService.loadUserByUsername(username).getAuthorities());
					SecurityContextHolder.getContext().setAuthentication(auth);
				}
			} catch (Exception e) {
				System.out.println("Token hết hiệu lực " +  e.getClass().getName());
				if (e  instanceof ExpiredJwtException) {
					response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
					response.getWriter().write(
						    """
						    {
						      "code": %d
						    }
						    """.formatted(ErrorCode.Code.TOKEN_EXPIRED.getValue())
						);
					return;
				}
			}
		}

		filterChain.doFilter(request, response);
	}
}