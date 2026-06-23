import { useState } from "react";
import "./ProductDetail.css";
import { Twitter, Pinterest, Link45deg, Facebook } from "react-bootstrap-icons";
import { useCartStore } from "../../../modules/cart/store/CartStore";
import { useBook } from "../../../modules/book/hooks/useBook";
import { useParams } from "react-router-dom";
import deliverly1 from "../../../assets/img/product_deliverly_1_ico.png";
import deliverly2 from "../../../assets/img/product_deliverly_2_ico.png";
import deliverly3 from "../../../assets/img/product_deliverly_3_ico.png";
import deliverly4 from "../../../assets/img/product_deliverly_4_ico.png";
import deliverly5 from "../../../assets/img/product_deliverly_5_ico.png";
import deliverly6 from "../../../assets/img/product_deliverly_6_ico.png";
import type { BookType } from "../../../modules/book/type/Book.type";
import { createPortal } from "react-dom";
import AddToCartToast from "../addToCartToast/AddToCartToast";

function ProductDetail() {
  const [quantity, setQuantity] = useState(1);
  const { id } = useParams();
  const productId = Number(id);
  const { data, isLoading } = useBook(productId);
  const [toasts, setToasts] = useState<BookType[]>([]);
  const addToCart = useCartStore((func) => func.addToCart);

  const decrease = () => {
    if (quantity > 1) {
      setQuantity(quantity - 1);
    }
  };

  const increase = () => {
    if (quantity < 100) {
      setQuantity(quantity + 1);
    }
  };

  const handleAddBook = () => {
    if (data) {
      addToCart({
        id: data.id,
        name: data.name,
        price: data.price,
        discountPrice: data.price * 0.8,
        quantity: quantity,
        imgSrc: data.imgSrc,
        discount: data.discount,
      });
      setToasts((prev) => [...prev, data]);
    }
  };

  // Them book vao gio hang va cap nhat gio hang
  // Them thanh cong -> hien thi addToCartToast o giuwa man hinh canh ben phai

  const buy = () => {
    // goi addToCart roi redirect toi gio hang
  };

  return !data ? (
    <div>....Error</div>
  ) : (
    <>
      <div className="pr-dt-wrapper">
        <div className="pr-dt-container">
          <div className="pr-dt-inf">
            <div className="pr-dt-img">
              <img src={data?.imgSrc} alt="" />
            </div>
            <div className="area-inf">
              <div className="pr-inf">
                <p className="pr-title">{data?.name}</p>
                <div className="status">
                  <p className="inf pr-status">
                    Tình trạng:
                    <span className="result pr-status-rs">{data.status}</span>
                  </p>
                  <p className="inf pr-brand">
                    Thương hiệu:
                    <span className="result pr-brand-rs">
                      {data.distributor}
                    </span>
                  </p>
                </div>
                <p className="inf author">
                  Tác giả:{" "}
                  <span className="result pr-status-rs">{data.author}</span>
                </p>
                <p className="inf translater">
                  Người dịch:
                  <span className="result pr-status-rs">{data.translator}</span>
                </p>
                <p className="inf prod">
                  Công ty phát hành:
                  <span className="result pr-producer-rs">
                    {data.publisher}
                  </span>
                </p>
                <p className="inf pages">
                  Số trang:{" "}
                  <span className="result pr-status-rs">{data.pageCount}</span>
                </p>
                <p className="inf cover-design">
                  Hình thức bìa:{" "}
                  <span className="result pr-status-rs">{data.coverType}</span>
                </p>
                <p className="inf weight">
                  Trọng lượng:{" "}
                  <span className="result pr-status-rs">{data.weight}</span>
                </p>
              </div>
              <div className="pr-flex-wrap">
                <div className="wrapbox-detail">
                  <div className="price">
                    <span className="price-title">Giá: </span>
                    <span className="new-price">
                      {(data.price / 2).toLocaleString()}₫
                    </span>
                    <span className="old-price">
                      {data.price.toLocaleString()}₫
                    </span>
                    <span className="discount">-50%</span>
                  </div>
                  <div className="quantity">
                    <span className="title">Số lượng: </span>
                    <div className="gr-buttn">
                      <button className="decreasing" onClick={decrease}>
                        -
                      </button>
                      <input type="number" placeholder="1" value={quantity} />
                      <button className="increasing" onClick={increase}>
                        +
                      </button>
                    </div>
                  </div>
                  <div className="wrapbox-delivery">
                    {data && (
                      <button
                        className="adding-product-btn"
                        onClick={() => handleAddBook()}
                      >
                        THÊM VÀO GIỎ
                      </button>
                    )}
                    <button className="buying-btn" onClick={buy}>
                      MUA NGAY
                    </button>
                  </div>
                  <div className="pr-toshare">
                    <span className="title">Chia sẻ: </span>
                    <div className="icon-tohare-container">
                      <Twitter size={24} className="icon-toshare twitter" />
                      <Facebook size={24} className="icon-toshare fb" />
                      <Pinterest size={24} className="icon-toshare pin" />
                      <Link45deg size={24} className="icon-toshare link45deg" />
                    </div>
                  </div>
                </div>
                <div className="wrapbox-detail-right">
                  <p className="title">Chính sách bán hàng</p>
                  <div className="infoList-deliverly">
                    <div className="delivery-item">
                      <span>
                        <img src={deliverly1} />
                      </span>
                      <p>Cam kết 100% chính hãng</p>
                    </div>
                    <div className="delivery-item">
                      <span>
                        <img src={deliverly2} />
                      </span>
                      <p>
                        Miễn phí giao hàng từ 250k (nội thành HCM), và từ 500k
                        (ngoại thành HCM và tỉnh)
                      </p>
                    </div>
                    <div className="delivery-item">
                      <span>
                        <img src={deliverly3} />
                      </span>
                      <p>Hỗ trợ từ thứ 2 đến thứ 7 (8h - 18h)</p>
                    </div>
                  </div>
                  <p className="title">Thông tin thêm</p>
                  <div className="infoList-deliverly">
                    <div className="delivery-item">
                      <span>
                        <img src={deliverly4} />
                      </span>
                      <p>Hoàn tiền 111% nếu hàng giả</p>
                    </div>
                    <div className="delivery-item">
                      <span>
                        <img src={deliverly5} />
                      </span>
                      <p>Mở hộp kiểm tra nhận hàng</p>
                    </div>
                    <div className="delivery-item">
                      <span>
                        <img src={deliverly6} />
                      </span>
                      <p>Đổi trả trong 7 ngày</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
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
              <AddToCartToast
                id={data.id}
                name={data.name}
                imgSrc={data.imgSrc}
                discount={data.discount}
                discountPrice={data.discountPrice}
                price={data.price}
              ></AddToCartToast>
            </div>
          )),
          document.body,
        )}
      </div>
    </>
  );
}

export default ProductDetail;
