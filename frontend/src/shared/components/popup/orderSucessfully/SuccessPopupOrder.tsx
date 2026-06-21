import { useNavigate } from "react-router-dom";
import "./SuccessPopupOrder.css";

type Params = {
    price: number
}
function SuccessPopupOrder(params : Params) {
    const navigate = useNavigate();

    return <>
        <div className="ss-popup-od-container">
            <div className="ss-popup-od-header">
                <span className="ss-popup-od-title">Yay, đặt hàng thành công!</span>
                <span className="ss-popup-od-fee">Chuẩn bị tiền mặt {params.price.toLocaleString()}<sup>đ</sup></span>
            </div>
            <div className="ss-popup-od-body">
                <div className="ss-popup-od-mt-pm-container">
                <span className="ss-popup-od-mt-pm">Phương thức thanh toán</span>
                <span className="ss-popup-od-mt-pm-detail">Thanh toán tiền mặt</span>
                </div>
                <div className="ss-popup-od-total">
                <span className="ss-popup-od-total-title">Tổng cộng</span>
                    <span className="ss-popup-od-total-detail">{params.price.toLocaleString()}<sup>đ</sup></span>
                </div>
                <div className="ss-popup-od-vat">
                    <span className="ss-popup-od-vat-detail">(Đã bao gồm VAT nếu có)</span>
                </div>
            </div>
            <div className="ss-popup-od-footer">
                <button className="ss-popup-od-backhome" onClick={() => navigate("/")}>Trở về trang chủ</button>
                <button className="ss-popup-od-to-order" onClick={() => navigate("/historyOrder")}>Xem đơn hàng</button>
            </div>

        </div>
    </>
}

export default SuccessPopupOrder;