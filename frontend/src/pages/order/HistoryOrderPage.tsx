import "./HistoryOrderPage.css";
import logo from "../../assets/img/KhongGiaDinh.jpg";

import { useEffect, useState } from "react";
import { Search } from "react-bootstrap-icons";
import Order from "../../shared/components/order/Order";
import { useOrders } from "../../modules/order/hooks/UseOrder";
import type { HistoryOrderType } from "../../modules/order/type/order.type";
import { useAuthStore } from "../../modules/auth/store/AuthStore";

function HistoryOrderPage() {
  const [searchInput, setSearchInput] = useState<string>("");
  const [activeTab, setActiveTab] = useState("ALL");
  const orders = useOrders(activeTab);
  const username = useAuthStore((state) => state.user?.username);
  const [hisOrdersContent, setHisOrderContent] = useState<
    HistoryOrderType[] | undefined
  >();
  const handleSearch = (e: string) => {
    setSearchInput(e);
  };

  const handleClickOnButtonCategory = (title: string) => {
    setActiveTab(title);
  };

  useEffect(() => {
    setHisOrderContent(orders.data);
  }, [orders.data]);

  return (
    <>
      <div className="his-order-container">
        <div className="his-order-left">
          <div className="account-area">
            <div className="avatar">
              <img src={logo} alt="" />
              <span className="account-name">
                {username}
              </span>
            </div>
          </div>
        </div>
        <div className="his-order-right">
          <div className="his-order-title">
            <span className="title-content">Đơn hàng của tôi</span>
          </div>
          <div className="his-order-category">
            <div className="his-order-category-container">
              <button
                className={
                  activeTab == "ALL"
                    ? "his-order-item active"
                    : "his-order-item"
                }
                onClick={() => handleClickOnButtonCategory("ALL")}
              >
                Tất cả đơn
              </button>
              <button
                className={
                  activeTab == "PENDING"
                    ? "his-order-item active"
                    : "his-order-item"
                }
                onClick={() => handleClickOnButtonCategory("PENDING")}
              >
                Chờ thanh toán
              </button>
              <button
                className={
                  activeTab == "PROCESSING"
                    ? "his-order-item active"
                    : "his-order-item"
                }
                onClick={() => handleClickOnButtonCategory("PROCESSING")}
              >
                Đang xử lí
              </button>
              <button
                className={
                  activeTab == "SHIPPING"
                    ? "his-order-item active"
                    : "his-order-item"
                }
                onClick={() => handleClickOnButtonCategory("SHIPPING")}
              >
                Đang vận chuyển
              </button>
              <button
                className={
                  activeTab == "DELIVERED"
                    ? "his-order-item active"
                    : "his-order-item"
                }
                onClick={() => handleClickOnButtonCategory("CANCELLED")}
              >
                Đã giao
              </button>
              <button
                className={
                  activeTab == "CANCELLED"
                    ? "his-order-item active"
                    : "his-order-item"
                }
                onClick={() => handleClickOnButtonCategory("CANCELLED")}
              >
                Đã hủy
              </button>
            </div>
          </div>
          <div className="his-order-search">
            <div className="his-order-search-container">
              <input
                type="text"
                value={searchInput}
                onChange={(e) => handleSearch(e.target.value)}
                placeholder="Tìm đơn hàng theo mã đơn hàng"
              />
              <button className="search">
                <Search size={20} />
              </button>
              <span className="his-order-search-title">Tìm đơn hàng</span>
            </div>
          </div>
          {hisOrdersContent &&
            hisOrdersContent.map((hOrder) => {
              return (
                <div className="his-order-item-container">
                  <Order
                    address={hOrder.address}
                    carts={hOrder.carts}
                    createDate={hOrder.createDate}
                    finalTotalPrice={hOrder.finalTotalPrice}
                    orderCode={hOrder.orderCode}
                    orderStatus={hOrder.orderStatus}
                    paymentMethod={hOrder.paymentMethod}
                    phone={hOrder.phone}
                    productDiscountAmount={hOrder.productDiscountAmount}
                    shippingFee={hOrder.shippingFee}
                    shippingMethod={hOrder.shippingMethod}
                    receiveDate={hOrder.receiveDate}
                  ></Order>
                </div>
              );
            })}
        </div>
      </div>
    </>
  );
}
export default HistoryOrderPage;
