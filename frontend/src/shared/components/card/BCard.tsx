import "./BCard.css";
import { createPortal } from "react-dom";
import { Cart } from "react-bootstrap-icons";
import { Link } from "react-router-dom";
import type { BookType } from "../../../modules/book/type/Book.type";
import { useCartStore } from "../../../modules/cart/store/CartStore";
import { useState } from "react";
import AddToCartToast from "../addToCartToast/AddToCartToast";

const BCard = (data: BookType) => {
  const addToCart = useCartStore((func) => func.addToCart);
  const [toasts, setToasts] = useState<BookType[]>([]);

  const handleAddBook = () => {
    addToCart({
      id: data.id,
      name: data.name,
      price: data.price,
      discountPrice: data.discountPrice,
      discount: data.discount,
      quantity: 1,
      imgSrc: data.imgSrc,
    });
    setToasts((prev) => [...prev, data]);
  };
  return (
    <>
      <div className="card-container">
        <div className="book-img">
          <Link to={`/productDetail/${data.id}`}>
            <img src={data.imgSrc} alt="" />
          </Link>
        </div>
        <div className="card-content">
          <p className="producer">NXB</p>
          <span className="book-name" title={data.name}>
            {data.name}
          </span>
          <div className="price-box">
            <span className="price">{data.discountPrice.toLocaleString()}</span>
            <span className="pro-sale">{"-" + data.discount + "%"}</span>
          </div>
          <span className="price-del">{data.price.toLocaleString()}</span>
          <div className="shopping-card-container">
            <Cart size={15} />
            <span
              className="shopping-card-text"
              onClick={() => handleAddBook()}
            >
              THÊM VÀO GIỎ
            </span>
          </div>
        </div>
        {createPortal(
          toasts.map((toast) => (
            <div
              key={toast.id}
              className="cart-toast"
              onAnimationEnd={() => {
                setToasts((prev) => prev.filter((t) => t.id !== toast.id));
              }}
            >
              <AddToCartToast id={data.id} name={data.name} imgSrc={data.imgSrc} discount={data.discount} discountPrice={data.discountPrice} price={data.price}></AddToCartToast>
            </div>
          )),
          document.body,
        )}
      </div>
    </>
  );
};

export default BCard;
