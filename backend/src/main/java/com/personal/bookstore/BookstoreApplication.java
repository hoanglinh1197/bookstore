package com.personal.bookstore;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;

@SpringBootApplication
public class BookstoreApplication {

	public static void main(String[] args) {
		ApplicationContext context = SpringApplication.run(BookstoreApplication.class, args);

	}

}
