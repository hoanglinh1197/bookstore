import type { BookType } from "../../../modules/book/type/Book.type";
import "./AddToCartToast.css"
import { X } from "react-bootstrap-icons";

// children : { children: React.ReactNode }
function AddToCartToast(data:BookType) {
  return (
    <>
        <div className="cart-toast-container">
            <div className="cart-toast-wrapper">
                <div className="notify-title">
                    <span>Đã thêm vào giỏ hàng thành công!</span>
                    <X className="closing-icon" size={20}/>
                </div>
                <div className="product-info">
                    <div className="product-img">
                          <img src={data.imgSrc} alt="" />
                    </div>
                    <div className="product-content">
                        <p className="product-title">{data.name}</p>
                          <span className="product-price">{data.discountPrice}<sub>đ</sub></span>
                    </div>
                </div>
            </div>
        </div>
    </>
  )
}

export default AddToCartToast