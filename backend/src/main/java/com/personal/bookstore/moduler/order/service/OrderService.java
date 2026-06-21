package com.personal.bookstore.moduler.order.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.personal.bookstore.entity.Account;
import com.personal.bookstore.entity.Book;
import com.personal.bookstore.entity.Order;
import com.personal.bookstore.entity.OrderItem;
import com.personal.bookstore.entity.ShippingMethod;
import com.personal.bookstore.moduler.book.dto.BookDto;
import com.personal.bookstore.moduler.book.dto.HisOrderBookResponseDto;
import com.personal.bookstore.moduler.book.service.BookService;
import com.personal.bookstore.moduler.order.dto.CartItem;
import com.personal.bookstore.moduler.order.dto.HistoryOrderResponseDto;
import com.personal.bookstore.moduler.order.dto.OrderRequestDto;
import com.personal.bookstore.moduler.order.repository.OrderRepository;
import com.personal.bookstore.moduler.order.utils.EncodedDecodeIdToOrderCode;
import com.personal.bookstore.moduler.shipping.dto.ShippingFeeRequestFromClient;
import com.personal.bookstore.moduler.shipping.dto.ShortTypeBook;
import com.personal.bookstore.moduler.shipping.service.GhnShippingService;
import com.personal.bookstore.moduler.shipping.service.ShippingMethodService;
import com.personal.bookstore.moduler.shipping.service.ShippingStatusService;
import com.personal.bookstore.service.AccountService;
import com.personal.bookstore.service.DiscountService;

import jakarta.transaction.Transactional;

@Service
@Transactional
public class OrderService {

	@Autowired
	private OrderRepository orderRepository;

	@Autowired
	private AccountService accService;

	@Autowired
	private BookService bookService;

	@Autowired
	private GhnShippingService ghnshinnGhnShippingService;

	@Autowired
	private OrderItemService orderItemService;

	@Autowired
	private ShippingMethodService shippingMethodService;

	@Autowired
	private EncodedDecodeIdToOrderCode encodedDecodeIdToOrderCode;

	@Autowired
	private OrderStatusService orderStatusService;

	@Autowired
	private AccountService accountService;

	@Autowired
	private DiscountService discountService;
	
	@Autowired
	private ShippingStatusService shippingStatusService;

	public Order save(Order order) {
		return orderRepository.save(order);
	}

	public BigDecimal order(OrderRequestDto orderDto) {
		List<CartItem> cartItems = orderDto.getCart();
		List<ShortTypeBook> shortTypeBooks = cartItems.stream()
				.map(item -> new ShortTypeBook(item.getId(), item.getQuantity())).toList();
		List<Long> bookIds = cartItems.stream().map(CartItem::getId).toList();
		List<Book> books = bookService.getBooks(bookIds);

		if (hasOutSufficentStock(cartItems, books))
			return BigDecimal.ZERO;

		// ktra shipping fee
		BigDecimal shippingFee = calShippingFee(orderDto.getAddress(), shortTypeBooks);
		boolean checkShippingFee = shippingFee.stripTrailingZeros()
				.equals(orderDto.getShippingFee().stripTrailingZeros());
		System.out.println("ShippingFee server: " + shippingFee.intValue() + "\n " + "ShippingFee client: "
				+ orderDto.getShippingFee().intValue());
		System.out.println("checkShippingFee " + checkShippingFee);
		if (!checkShippingFee)
			return BigDecimal.ZERO;

		// ktra accountName
		Long accId = haveAccount(orderDto.getAccountName());
		System.out.println("Ten tai khoan: " + orderDto.getAccountName() + "\t id la: " + accId.longValue());
		if (accId.longValue() < 1)
			return BigDecimal.ZERO;

		// ktra luong giam gia cho sach - gop lai thanh tinh tong gia sau khi da giam
		// Tong gia sach + phi ship - giam gia don hang(x) - giam gia sach - giam gia
		// ship(x)

		// Tinh gia truoc khi dung discount va luong discount
		BigDecimal totalPriceBeforeApplyDiscount = BigDecimal.ZERO, totalBooksDiscountAmount = BigDecimal.ZERO;
		Map<Long, Integer> quantites = cartItems.stream()
				.collect(Collectors.toMap(CartItem::getId, CartItem::getQuantity));
		List<BookDto> bookDtos = bookService.getBooksDtoFromIds(bookIds);
		for (BookDto dto : bookDtos) {
			System.out.println(dto.getId() + "\t" + dto.getName() + "\t" + dto.getPrice() + "\t" + dto.getDiscount()
					+ "\t" + quantites.get(dto.getId()));
			totalPriceBeforeApplyDiscount = totalPriceBeforeApplyDiscount
					.add(dto.getPrice().multiply(BigDecimal.valueOf(quantites.get(dto.getId()))));
			totalBooksDiscountAmount = totalBooksDiscountAmount
					.add(dto.getDiscountPrice().multiply(BigDecimal.valueOf(quantites.get(dto.getId()))));
		}
		System.out.println("Tong gia sach trc khi co discount: " + totalPriceBeforeApplyDiscount.doubleValue());
		System.out.println("Tong luong discount sach: " + totalBooksDiscountAmount.doubleValue());

		BigDecimal totalPrice = totalPriceBeforeApplyDiscount.subtract(totalBooksDiscountAmount);
		System.out.println("Tong gia sau khi ap discount sach: " + totalPrice.doubleValue());

		BigDecimal finalPrice = totalPrice.add(shippingFee);
		System.out.println("Gia phai tra o server: " + finalPrice.doubleValue());
		System.out.println("Gia phai tra o client: " + orderDto.getTotalPrice());

		boolean checkPrice = finalPrice.compareTo(orderDto.getTotalPrice()) == 0;
		if (!checkPrice)
			return BigDecimal.ZERO;

		// Tao don hang
		Order order = setOrder(accId, orderDto.getShippingMethodId(), orderDto.getPhone(), orderDto.getAddress(),
				shippingFee, totalBooksDiscountAmount, finalPrice);
		Order orderFrdb = save(order);
		createOrderItemForOrder(cartItems, orderFrdb.getId());
		return order.getFinalTotalPrice();

	}

	public boolean hasOutSufficentStock(List<CartItem> cartItems, List<Book> books) {
		Map<Long, Integer> stockMap = books.stream().collect(Collectors.toMap(Book::getId, Book::getStockQuantity));
		boolean result = cartItems.stream().anyMatch(item -> item.getQuantity() > stockMap.get(item.getId()));
		return result;
	}

	public Long haveAccount(String accName) {
		System.out.println("Vao ham have account");
		try {
			Account acc = accService.findByName(accName);
			return acc.getId();
		} catch (NoSuchElementException E) {
			return Long.valueOf(-1);
		}
	}

	private BigDecimal calShippingFee(String addr, List<ShortTypeBook> shortTypeBooks) {
		String address[] = List.of(addr.trim().split(",")).stream()
				.map(add -> add.replaceAll("^(Tỉnh|Huyện|Quận|Thành phố|Thị xã|Xã|Phường)\\s+", ""))
				.toArray(String[]::new);
		ShippingFeeRequestFromClient cart = new ShippingFeeRequestFromClient(address[0].trim(), address[1].trim(),
				address[2].trim(), shortTypeBooks);
		BigDecimal shippingFee = ghnshinnGhnShippingService.getShippingFee(cart);
		return shippingFee;
	}

	private Order setOrder(Long accId, Long shippingMethodId, String phone, String address, BigDecimal shippingFee,
			BigDecimal totalBooksDiscountAmount, BigDecimal finalPrice) {
		// Tao don hang
		Order order = new Order();
		order.setAccountId(accId);
		order.setSdt(phone);
		order.setAddress(address);
		order.setOrderStatusId(1L); // 1- pending
		order.setShippingStatusId(1L);
		ShippingMethod shippingMethod = shippingMethodService.findById(shippingMethodId).get();
		order.setShippingMethodId(shippingMethod.getId());
		order.setShippingFee(shippingFee);
		order.setProductDiscountAmount(totalBooksDiscountAmount);
		order.setFinalTotalPrice(finalPrice);
		order.setShippingDiscountAmount(BigDecimal.ZERO);
		order.setVoucherDiscountAmount(BigDecimal.ZERO);
		order.setReceivedDate(LocalDateTime.now().plus(shippingMethod.getEstimatedDays(), ChronoUnit.DAYS));
		return order;
	}

	private void createOrderItemForOrder(List<CartItem> cartItems, Long orderId) {
		// Map ID toi order item
		for (CartItem item : cartItems) {
			OrderItem orderItem = new OrderItem();
			orderItem.setBookId(item.getId());
			orderItem.setQuantity(item.getQuantity());
			orderItem.setUnitPrice(item.getPrice());
			orderItem.setOrderId(orderId);
			orderItemService.save(orderItem);
		}
	}

	public void updateShippingStatusAuto() {
		LocalDateTime time = LocalDateTime.now();
		int row = orderRepository.updateShippingStatusAuto(time);
		if (row > 0) {
			System.out.println("Update Order Successfully");
		} else {
			System.out.println("Update Order Failed");
		}
	}
	
	public List<HistoryOrderResponseDto> orders(String  accName) {
		// Tim id, loc order theo shippingStatusId va accountName
		Account acc = accountService.findByName(accName);
		List<HistoryOrderResponseDto> result = new ArrayList<HistoryOrderResponseDto>();
		List<Order> orders = orderRepository.findByAccountId(acc.getId());
		if (!orders.isEmpty()) {
			result = getHistoryOrderResponseDtos(orders);
		}
		return result;
	}

	public List<HistoryOrderResponseDto> orders(String  accName, String shippingStatus) {
		// Tim id, loc order theo shippingStatusId va accountName
		Long shippingStatusId = shippingStatusService.findByShippingStatus(shippingStatus).get().getId();
		Account acc = accountService.findByName(accName);
		List<HistoryOrderResponseDto> result = new ArrayList<HistoryOrderResponseDto>();
		List<Order> orders = orderRepository.findByAccountIdAndShippingStatusId(acc.getId(), shippingStatusId);
		if (!orders.isEmpty()) {
			result = getHistoryOrderResponseDtos(orders);
		}
		return result;
	}
	
	private List<HistoryOrderResponseDto> getHistoryOrderResponseDtos(List<Order> orders ){
		List<HistoryOrderResponseDto> result = new ArrayList<HistoryOrderResponseDto>();
		for (Order order : orders) {
			List<OrderItem> orderItems = orderItemService.orderItem(order.getId());
			
			List<HisOrderBookResponseDto> cartItems = orderItems.stream().map((orderItem) -> {
				Book book = bookService.getBook(orderItem.getBookId());
				HisOrderBookResponseDto cartItem = new HisOrderBookResponseDto();
				cartItem.setId(book.getId());
				cartItem.setName(book.getName());
				cartItem.setImgSrc(book.getImgSrc());
				cartItem.setPrice(orderItem.getUnitPrice());
				cartItem.setDiscount(discountService.findById(book.getDiscountId()).get().getValue());
				cartItem.setDiscountPrice(order.getProductDiscountAmount());
				cartItem.setQuantity(orderItem.getQuantity());
				cartItem.setDistributor(book.getDistributor());
				return cartItem;
			}).toList();
			
			
			result.add(new HistoryOrderResponseDto(encodedDecodeIdToOrderCode.encode(order.getId()),
					orderStatusService.orderStatus(order.getOrderStatusId()).getOrderStatus(), cartItems,
					accountService.findById(order.getAccountId()).getUsername(), order.getAddress(), order.getSdt(),
					order.getShippingFee(),
					shippingMethodService.findById(order.getShippingMethodId()).get().getDescription(),
					"Thanh toán tiền mặt khi nhận hàng", order.getCreatedAt(), order.getProductDiscountAmount(),
					order.getFinalTotalPrice(), order.getReceivedDate()));
		}
		return result;
	}

}
