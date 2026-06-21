import "./ShoppingCartPage.css";
import LineItem from "../../shared/components/lineItem/LineItem";
import OrderInformation from "../../shared/components/orderInformation/OrderInformation";
import { useCartStore } from "../../modules/cart/store/CartStore";
import { useState } from "react";
import DeletePopup from "../../shared/components/popup/deletePopup/DeletePopup";

function ShoppingCartBody() {
  const [ischeckedAll, setCheckedAll] = useState(false);
  const [showDeletePopup, setShowDeletePopup] = useState(false);

  const cart = useCartStore((state) => state.cart);
  const quantity = useCartStore().getQuantity();
  const totalPrice = useCartStore().getTotalprice();

  const handleDelete = () => {
    setShowDeletePopup(true);
  };

  const getBookIds = (): number[] => {
    const ids: number[] = cart.map((book) => book.id);
    return ids;
  };
  return (
    <>
      <div className="sc-container">
        <div className="body">
          <div className="left">
            <div className="mainCart-detail">
              <h5>Giỏ hàng của bạn</h5>
              <p>
                Bạn đang có <b>{quantity}</b> sản phẩm trong giỏ hàng
              </p>
              <div className="title-number-cart">
                <div className="title-card">
                  <label>
                    <input
                      type="checkbox"
                      checked={ischeckedAll && cart.length > 0}
                      onChange={(e) => {
                        setCheckedAll(e.target.checked);
                      }}
                    />{" "}
                    Chọn tất cả
                  </label>
                  {ischeckedAll && cart.length > 0 && (
                    <button
                      className="delete-cartstore"
                      onClick={() => handleDelete()}
                    >
                      Xóa
                    </button>
                  )}
                </div>

                <div className="lineItem-container">
                  {cart.map((book) => (
                    <LineItem
                      key={book.id}
                      cartItem={book}
                      isEnabbeldCheckbox={ischeckedAll}
                      setAllChecked={() => setCheckedAll}
                    ></LineItem>
                  ))}
                </div>
              </div>
            </div>
          </div>
          <div className="right">
            <OrderInformation totalprice={totalPrice}></OrderInformation>
          </div>
          {showDeletePopup && (
            <div className="delete-popup-container">
              <div className="delete-popup-container">
                <DeletePopup
                  bookIds={getBookIds()}
                  cancel={() => setShowDeletePopup(false)}
                ></DeletePopup>
              </div> 
            </div>
          )}
        </div>
      </div>
    </>
  );
}

export default ShoppingCartBody;
