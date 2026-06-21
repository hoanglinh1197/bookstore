import { useCartStore } from "../../../../modules/cart/store/CartStore";
import "./DeletePopup.css";
import { ExclamationTriangle } from "react-bootstrap-icons";

type Params = {
    bookIds: number[],
    cancel: () => void
}

function DeletePopup(params: Params) {
    const deleteBookFromCart = useCartStore((store) => store.deleteBook) 
    const deleteFromCart = () => {
        params.bookIds.map((id) => {
            deleteBookFromCart(id);
        });
    }

    const submit = () => {
        deleteFromCart();
        params.cancel();
        
    }
    return <>
    <div className="popup-delete-container">
            <div className="popup-delete-title-header">
                <ExclamationTriangle size={20} className="exclamation-triangle"/>
                <span className="popup-delete-title">Xóa sản phẩm</span>
            </div>
            <div className="popup-delete-content-body">
                <span className="popup-delete-content">
                    Bạn có muốn xóa sản phẩm đang chọn?
                </span>
            </div>
            <div className="popup-delete-footer">
                <button className="popup-submit" onClick={() => submit()}>Xác nhận</button>
                <button className="popup-cancel" onClick={() => params.cancel()}>Hủy</button>
            </div>
    </div>
    </>
}

export default DeletePopup;