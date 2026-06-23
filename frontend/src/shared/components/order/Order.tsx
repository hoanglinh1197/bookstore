import "./Order.css";
import { Ban, Truck } from "react-bootstrap-icons";
import OrderItem from "./OrderItem";
import { useState } from "react";
import type { HistoryOrderType } from "../../../modules/order/type/order.type";
import { useCartStore } from "../../../modules/cart/store/CartStore";
import { useNavigate } from "react-router-dom";

type Params = {
  historyOrders: HistoryOrderType,
} 

function Order(params : Params ) {
  const [isShowMore, setIsShowMore] = useState(false);

  const length = params.historyOrders.carts ? params.historyOrders.carts.length : 0;
  const addToCart = useCartStore((c) => c.addToCart);
  const navigate = useNavigate();

  const buyAgain = () => {
    // Add vao gio hang - > chuyen huong sang dat hang voi dia chi co san
    params.historyOrders.carts.map((order) => {
      addToCart({
        id: order.id,

        name: order.name,

        price: order.price,

        discountPrice: order.price * (100 - order.discount) / 100,

        discount: order.discount,

        imgSrc: order.imgSrc,

        quantity: order.quantity,
      });
    });
    navigate("/shoppingCart");
  };

  const showDetail = () => {
    navigate("/historyOrder/orderDetail", {
      state: {
        orderCode: params.historyOrders.orderCode
      },
    });
  };

  return (
    <>
      {params.historyOrders && (
        <div className="order-item-container">
          <div className="order-status">
            <div className="cancel-order-container">
              <Ban size={15} className="x-circle-fill-icon" />
              <span className="cancel-order-title">
                {params.historyOrders.orderStatus}
              </span>
            </div>
          </div>
          {/* {
          isShowMore &&
          historyOrders.carts.map((item) => {
            return <OrderItem name={item.name} id={item.id} discount={item.discount} discountPrice={item.discountPrice} imgSrc={item.imgSrc} price={item.price} quantity={item.quantity}></OrderItem>

          })
        } */}
          <OrderItem
            name={params.historyOrders.carts[0].name}
            id={params.historyOrders.carts[0].id}
            discount={params.historyOrders.carts[0].discount}
            discountPrice={params.historyOrders.carts[0].discountPrice}
            imgSrc={params.historyOrders.carts[0].imgSrc}
            price={params.historyOrders.carts[0].price}
            quantity={params.historyOrders.carts[0].quantity}
            distributor={params.historyOrders.carts[0].distributor}
          ></OrderItem>
          {length > 1 ? (
            <div className="more-book-container">
              <button className="btn-more" onClick={() => setIsShowMore(true)}>
                Xem thêm {length.toString()} sản phẩm
              </button>
            </div>
          ) : (
            ""
          )}
          <div className="order-total-price-container">
            <div className="order-total-price">
              <span className="total-price-title">Tổng tiền:</span>
              <span className="total-price">
                {params.historyOrders.finalTotalPrice.toLocaleString()}
                <sup>đ</sup>
              </span>
            </div>
            <div className="more-infomation">
              <button className="buy-again" onClick={() => buyAgain()}>
                Mua lại
              </button>
              <button className="more-detail" onClick={() => showDetail()}>
                Xem chi tiết
              </button>
            </div>
          </div>
        </div>
      )}
    </>
  );
}

export default Order;