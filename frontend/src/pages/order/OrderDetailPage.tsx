import { useLocation, useNavigate } from "react-router-dom";
import OrderItem from "../../shared/components/order/OrderItem";
import "./OrderDetailPage.css";
import type { HisOrderBookReponseType } from "../../modules/book/type/Book.type";
import { useAuthStore } from "../../modules/auth/store/AuthStore";

function OrderDetail() {
  const location = useLocation();
  const historyOrders = location.state;
    const price = historyOrders
      ? historyOrders.finalTotalPrice -
        historyOrders.shippingFee 
      : 0;
  const username = useAuthStore((state) => state.user?.username);

  const navigate = useNavigate();
  return (
    <>
      {historyOrders && (
        <div className="order-detail-container">
          <div className="order-detail-title-container">
            <span className="title">
              Chi tiết đơn hàng #{historyOrders.orderCode} -{" "}
              {historyOrders.orderStatus}
            </span>
          </div>
          <div className="order-date-container">
            <span className="order-date">
              Ngày đặt hàng: {historyOrders.createDate}
            </span>
          </div>
          <div className="order-detail-user-info">
            <div className="address-container">
              <span className="order-detail-address-title">
                Địa chỉ người nhận
              </span>
              <div className="order-detail-address-detail">
                <span className="order-detail-username">{username}</span>
                <span className="order-detail-address">
                  Địa chỉ: {historyOrders.address}
                </span>
                <span className="order-detail-phone">
                  Điện thoại: {historyOrders.phone}
                </span>
              </div>
            </div>
            <div className="shipping-type-container">
              <span className="order-detail-shipping-type-title">
                Hình thức giao hàng
              </span>
              <div className="order-detail-shipping-type-wrapper">
                <span className="order-detail-shipping-type">
                  {historyOrders.shippingMethod}
                </span>
                <span className="order-detail-shipping-date">
                  {historyOrders.receiveDate}
                </span>
                <span className="order-detail-shipping-fee">
                  Phí vận chuyển: {historyOrders.shippingFee.toLocaleString()}
                  <sup>đ</sup>
                </span>
              </div>
            </div>
            <div className="payment-type-container">
              <span className="order-detail-payment-type-title">
                Hình thức thanh toán
              </span>
              <div className="order-detail-payment-type-wrapper">
                <span className="order-detail-payment-type">
                  {historyOrders.paymentMethod}
                </span>
              </div>
            </div>
          </div>
          <div className="order-items-container">
            <div className="order-items-columnn-title">
              <p>Sản phẩm</p>
              <p>Giảm giá</p>
              <p>Giá</p>
            </div>

            {historyOrders.carts &&
              historyOrders.carts.map((item: HisOrderBookReponseType) => {
                return (
                  <OrderItem
                    name={item.name}
                    id={item.id}
                    imgSrc={item.imgSrc}
                    discount={item.discount}
                    discountPrice={item.discountPrice}
                    price={item.price}
                    quantity={item.quantity}
                    distributor={item.distributor}
                  ></OrderItem>
                );
              })}
               <div className="order-detail-fee-container">
              <div className="order-detail-fee-left">
                <span className="sub-total-title">Tạm tính:</span>
                <span className="shipping-fee-title">Phí vận chuyển:</span>
                <span className="total-price-title">Tổng cộng:</span>
              </div>
              <div className="order-detail-fee-right">
                <span className="sub-total-fee">
                  {price.toLocaleString()}
                  <sup>đ</sup>
                </span>
                <span className="shipping-fee-fee">
                  {historyOrders.shippingFee.toLocaleString()}
                  <sup>đ</sup>
                </span>
                <span className="total-price-fee">
                  {historyOrders.finalTotalPrice.toLocaleString()}
                  <sup>đ</sup>
                </span>
              </div>
            </div>
          </div>
        
          <div className="back-to-previous-container">
            <span
              className="back-to-previous"
              onClick={() => navigate("/historyOrder")}
            >
              Quay lại đơn hàng của tôi
            </span>
          </div>
        </div>
      )}
    </>
  );
}

export default OrderDetail;
