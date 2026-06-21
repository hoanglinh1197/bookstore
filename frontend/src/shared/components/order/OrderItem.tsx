import "./OrderItem.css";
import type { HisOrderBookReponseType } from "../../../modules/book/type/Book.type";

function OrderItem(param: HisOrderBookReponseType) {
  const discountPrice = param.price * param.discount / 100;
  return (
    <>
      <div className="order-item-content">
        <div className="order-book-img-container">
          <div className="order-book-img">
            <img src={param.imgSrc} alt="" />
            <div className="book-quantity">
              <span className="quantity">x{param.quantity}</span>
            </div>
          </div>
          <div className="order-book-info-container">
            <span className="book-title">{param.name}</span>
            <span className="shop-name">{param.distributor}</span>
          </div>
        </div>
        <div className="book-discount-price-container">
          <span className="discount-price">
            {discountPrice.toLocaleString()}
            <sup>đ</sup>
          </span>
        </div>
        <div className="book-price-container">
          <span className="it-price">
            {param.price.toLocaleString()}
            <sup>đ</sup>
          </span>
        </div>
      </div>
    </>
  );
}

export default OrderItem;
