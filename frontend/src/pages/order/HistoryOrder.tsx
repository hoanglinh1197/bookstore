import "./HistoryOrder.css";
import { useState } from "react";
import type { HistoryOrderType } from "../../modules/order/type/order.type";
import { useOrders } from "../../modules/order/hooks/UseOrder";
import Order from "../../shared/components/order/Order";
import { Search } from "react-bootstrap-icons";

function HistoryOrder() {
  const [searchData, setSearchData] = useState<string>();
  const [resultSearch, setResultSearch] = useState<HistoryOrderType | null>();
  const [activeTab, setActiveTab] = useState("ALL");
  const { data } = useOrders(activeTab);

  const handleClickOnButtonCategory = (title: string) => {
    setSearchData("");
    setResultSearch(null);
    setActiveTab(title);
  };

  const searchOrder = () => {
    if (data) {
      const result = data.filter((ele) => ele.orderCode == searchData)[0];
      debugger
      if (result) {
        setResultSearch(result);
      }
    }
  };

  return (
    <>
      <div className="his-order-right">
        <div className="his-order-title">
          <span className="title-content">Đơn hàng của tôi</span>
        </div>
        <div className="his-order-category">
          <div className="his-order-category-container">
            <button
              className={
                activeTab == "ALL" ? "his-order-item active" : "his-order-item"
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
              onClick={() => handleClickOnButtonCategory("DELIVERED")}
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
              value={searchData}
              onChange={(e) => setSearchData(e.target.value)}
              placeholder="Tìm đơn hàng theo mã đơn hàng"
            />
            <button className="search">
              <Search size={20} />
            </button>
            <span className="his-order-search-title" onClick={() => searchOrder()}>Tìm đơn hàng</span>
          </div>
        </div>
        {resultSearch ? (
          <div className="his-order-item-container">
            <Order historyOrders={resultSearch}></Order>
          </div>
        ) : (
          data &&
          data.map((hOrder) => {
            return (
              <div className="his-order-item-container">
                <Order historyOrders={hOrder}></Order>
              </div>
            );
          })
        )}
      </div>
    </>
  );
}

export default HistoryOrder;
