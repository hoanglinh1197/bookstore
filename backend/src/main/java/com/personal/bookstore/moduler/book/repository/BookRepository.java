package com.personal.bookstore.moduler.book.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.personal.bookstore.entity.Book;
import com.personal.bookstore.moduler.book.dto.BookDto;

@Repository
public interface BookRepository extends JpaRepository<Book, Long> {
		
	Optional<Book> findById(Long id);
		
	Book save(Book book);
	
	boolean existsById(Long id);

	@Query("""
		    SELECT b.stockQuantity
		    FROM Book b
		    WHERE b.id = :id
		""")
		Integer findStockQuantityById(
		    @Param("id") Long id
		);
	
	@Query("""
			SELECT b 
			FROM Book b
			WHERE b.id IN :ids
			""")
		List<Book> finBooksById(@Param("ids") List<Long> ids); 
	
	
	@Query("""
			SELECT new com.personal.bookstore.moduler.book.dto.BookDto( 
			b.id, 
			b.name, 
			b.imgSrc, 
			b.price, 
			d.value,
			b.price * d.value / 100)
			FROM Book b
			JOIN Discount d on b.discountId = d.id
			WHERE b.name like %:name%
			""")
		List<BookDto> findByNameContaining(String name);
	
	
	@Query("""
			SELECT new com.personal.bookstore.moduler.book.dto.BookDto( 
			b.id, 
			b.name, 
			b.imgSrc, 
			b.price, 
			d.value,
			b.price * d.value / 100)
			FROM Book b
			JOIN Discount d on b.discountId = d.id
			WHERE b.id IN :ids
			""")
		List<BookDto> findBookDtoByIds(List<Long> ids);

	
	
	
}
