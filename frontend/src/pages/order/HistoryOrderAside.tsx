import "./HistoryOrderAside.css";
import logo from "../../assets/img/KhongGiaDinh.jpg";
import { useAuthStore } from "../../modules/auth/store/AuthStore";

function HistoryOrderAside() {
    const username = useAuthStore((state) => state.user?.username);
  return (
    <>
      <div className="his-order-left">
        <div className="account-area">
          <div className="avatar">
            <img src={logo} alt="" />
            <span className="account-name">{username}</span>
          </div>
        </div>
      </div>
    </>
  );
}

export default HistoryOrderAside;
