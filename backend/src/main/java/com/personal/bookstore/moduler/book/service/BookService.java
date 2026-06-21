package com.personal.bookstore.moduler.book.service;


import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.Book;
import com.personal.bookstore.moduler.book.dto.BookDto;
import com.personal.bookstore.moduler.book.repository.BookRepository;


@Service
public class BookService{

	@Autowired
	private BookRepository bookRepository;
	
	public Page<Book> getBooks(int page, int size) { // Moi trang co bao nhieu phan tu size
	    Pageable pageable = PageRequest.of(page, size, Sort.by("id"));
	    return bookRepository.findAll(pageable);
	}
	
	public long count() {
	return bookRepository.count();
	}
	
	public Book getBook(long id) {
		Optional<Book> book = bookRepository.findById(id);
		if(book.isEmpty()) {
			throw new NoSuchElementException("Khong tim thay sach co id: "+id);
		}
		return book.get();
	}
	
	public int findStockQuantityById(long id) {
		return bookRepository.findStockQuantityById(id);
	}

	
	public List<Book> getBooks(List<Long> ids){
		return bookRepository.finBooksById(ids);
	}
	
	public List<BookDto> search(String name){
		return bookRepository.findByNameContaining(name);
	}
	
	
	public List<BookDto> getBooksDtoFromIds(List<Long> ids){
		return bookRepository.findBookDtoByIds(ids);
	}

}
