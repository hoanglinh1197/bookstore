import "./DiscountItem.css";
import { InfoCircle } from "react-bootstrap-icons";
import FreeShipExtra from "../../../assets/img/discount/free-ship-extra.jpg";

export const DiscoountItem = () => {
  return (
    <>
      <div className="discItem-frame">
        <div className="left-side">
          <img src={FreeShipExtra} alt="" />
        </div>
        <div className="right-side">
          <div className="discount-detail">
            <div className="top-area">
              <div className="head-area">
                <div className="badge-area">
                  <span className="badge-title">Thành viên</span>
                </div>
                <InfoCircle className="discount-info" size={20} />
              </div>
              <div className="body-area">
                <span className="discount-name">Giảm 50K</span>
                <span className="discount-notice">Số lượng có hạn</span>
              </div>
            </div>
            <div className="bottom-area">
              <span className="discount-exp">HSD: 31/03/2027</span>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};
