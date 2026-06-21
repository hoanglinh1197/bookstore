import "./OrderInformation.css";
import { useNavigate } from "react-router-dom";
import LoginForm from "../loginForm/LoginForm";
import { useEffect, useState } from "react";
import authService from "../../../modules/auth/services/authService";

interface TotalPrice {
  totalprice: number
}

function OrderInformation(totalPrice: TotalPrice) {
  const navigate = useNavigate();
  const username = authService();
  const [isOpenLoginForm, setIsOpenLoginForm] = useState(username ? false : true);
  const pay = () => {
    // sua lai kiem tra token con han k
    if (username) {
      navigate("/payment")
    } else {
      setIsOpenLoginForm(true);
    }
  }

  useEffect(() => {
    if (!username) {
      setIsOpenLoginForm(true);
    }
  }, [username]);

  return (
    <>
      <div className="orderInfor-container">
        {isOpenLoginForm && (<div className="login-overlay">
          <LoginForm onClose={() => setIsOpenLoginForm(true)} />
        </div>)}
        <div className="order-summary-block">
          <p>Thông tin đơn hàng</p>
          <div className="total-price">
            <span className="total-price-label">Tổng tiền:</span>
            <span className="price">
              
              {totalPrice.totalprice.toLocaleString()}
              
              <span className="up">đ</span>
            </span>
          </div>
          <div className="summary-action">
            <ul>
              <li>Phí vận chuyển sẽ được tính ở trang thanh toán</li>
              <li>Bạn cũng có thể nhập mã giảm giá ở trang thanh toán</li>
            </ul>
            <button className="payment" onClick={() => pay()}>ĐẶT HÀNG</button>
          </div>
        </div>
        <div className="alert-order">
          <span>Chính sách mua hàng:</span>
          <span>
            Hiện chúng tôi chỉ áp dụng thanh toán với đơn hàng có giá trị tối
            thiểu <b>10.000</b>
            <span className="up">đ</span> trở lên.
          </span>
        </div>
      </div>
    </>
  );
}

export default OrderInformation;
