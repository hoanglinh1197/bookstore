package com.personal.bookstore.moduler.book.controller;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.personal.bookstore.entity.Book;
import com.personal.bookstore.entity.Discount;
import com.personal.bookstore.moduler.book.dto.BookDto;
import com.personal.bookstore.moduler.book.dto.StockReponseDto;
import com.personal.bookstore.moduler.book.service.BookService;
import com.personal.bookstore.service.DiscountService;

@RestController
@RequestMapping("/books")
public class BookController {

	@Autowired
	private BookService bookService;

	@Autowired
	private DiscountService discountService;

	@GetMapping
	public ResponseEntity<Page<BookDto>> getBooks(@RequestParam int page, @RequestParam int size) {

		Page<Book> books = bookService.getBooks(page, size);
		Page<BookDto> response = books.map(book ->{
			 Discount discount = discountService
			            .findById(book.getDiscountId())
			            .orElseThrow();
			  BigDecimal discountPrice = book.getPrice()
			            .multiply(BigDecimal.valueOf(100)
			            .subtract(discount.getValue()))
			            .divide(BigDecimal.valueOf(100));
			  return new BookDto(
				        book.getId(),
				        book.getName(),
				        book.getImgSrc(),
				        book.getPrice(),
				        discount.getValue(),
				        discountPrice
				    );
		});
		List<BookDto> list = response.getContent();
		for (BookDto b : list) {
			System.out.println(b.getName());
		}
		return ResponseEntity.ok(response);
	}

	@GetMapping("/count")
	public long count() {
		return bookService.count();
	}

	@GetMapping("/{id}")
	public Book getBook(@PathVariable long id) {
		return bookService.getBook(id);
	}

	@GetMapping("/check")
	// URL .../books/check?id=...&quantityInCart=...
	public ResponseEntity<StockReponseDto> isStockQuantityValid(@RequestParam long id,
			@RequestParam int quantityInCartItem) {
		int quantity = bookService.findStockQuantityById(id);
		boolean isValid = 3 > quantityInCartItem;
		StockReponseDto reponseDto = new StockReponseDto(isValid, 3);
		return ResponseEntity.ok(reponseDto);
	}

	@GetMapping("/search")
	public ResponseEntity<List<BookDto>> search(@RequestParam String name) {
		List<BookDto> books = bookService.search(name);
		return ResponseEntity.ok(books);
	}

}
