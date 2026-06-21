import "./DiscountFrame.css";
import { Ticket, X } from "react-bootstrap-icons";
import { DiscoountItem } from "./DiscountItem";
import { useEffect, useState } from "react";

interface discountType {
  onClose: () => void
}
export const DiscountFrame = (onClose : discountType) => {

  return <>
      <div className="voucher-forn">
        <div className="voucher-form-container">
          <div className="discFr-countainer">
            <div className="discFr-wrapper">
              <div className="discFr-top">
                <p className="discFr-title">Khuyến mãi</p>
                <div className="closing-discFr-container">
                  <X
                    size={20}
                    className="closing-discFr"
                    onClick={onClose.onClose}
                  />
                </div>
              </div>
              <div className="discount-search-area">
                <div className="discount-search">
                  <input type="text" placeholder="Nhập mã giảm giá" />
                  <Ticket size={20} className="icon-discount" />
                </div>
                <button className="discount-submit">Áp dụng</button>
              </div>
              <div className="discFr-bottom">
                <DiscoountItem></DiscoountItem>
              </div>
            </div>
          </div>
        </div>
      </div>
    </>
};
