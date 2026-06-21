package com.personal.bookstore.moduler.auth.config;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.personal.bookstore.moduler.auth.handler.CustomAuthenticationEntryPoint;
import com.personal.bookstore.moduler.auth.handler.OAuth2SuccessHandler;

@Configuration
@EnableScheduling
public class SecurityConfig {

	@Autowired
	private OAuth2SuccessHandler successHandler;

	@Autowired
	private CustomAuthenticationEntryPoint customAuthenticationEntryPoint;

	@Autowired
	private JwtAuthenticationFilter jwtAuthenticationFilter;

	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http.cors(cors -> cors.configurationSource(corsConfigurationSource())).csrf(csrf -> csrf.disable())
		//  stateless
            .sessionManagement(sess ->
                sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )

				.authorizeHttpRequests(
						auth -> auth.requestMatchers("/books", "/books/**", "/oauth2/**", "/api/auth/**").permitAll()
								// SecurityContext có Authentication không? doFilterInternal kiem tra va set
								// SecurityContext de authenticated ktra
								.anyRequest().authenticated())
				.exceptionHandling(
						ex -> ex.authenticationEntryPoint((AuthenticationEntryPoint) customAuthenticationEntryPoint))

				// OAuth2 login
				.oauth2Login(oauth -> oauth
				        .authorizationEndpoint(auth -> auth.authorizationRequestRepository(
				                    new CustomAuthorizationRequestRepository()
				                )
				            ).successHandler(successHandler))

//            // add JWT filter
            .addFilterBefore(
            	jwtAuthenticationFilter,
                UsernamePasswordAuthenticationFilter.class
            );

		return http.build();
	}

	@Bean
	public CorsConfigurationSource corsConfigurationSource() {
		CorsConfiguration config = new CorsConfiguration();

		config.setAllowedOrigins(List.of("http://localhost:5173"));
		config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
		config.setAllowedHeaders(List.of("*"));
		config.setAllowCredentials(true);

		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", config);

		return (CorsConfigurationSource) source;
	}
	
	 @Bean
	    public RestTemplate restTemplate() {
	        return new RestTemplate();
	    }
}
