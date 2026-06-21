import "./SocialLoginButton.css";
import logo from "../../../assets/img/KhongGiaDinh.jpg";
import { Person } from "react-bootstrap-icons";
import LoginForm from "../loginForm/LoginForm";
import { useEffect, useRef, useState } from "react";
import authService from "../../../modules/auth/services/authService";
import { logout } from "../../../modules/home/service/LogoutService";
import { useAuthStore } from "../../../modules/auth/store/AuthStore";
import { useNavigate } from "react-router-dom";
type OpenLoginFormFromCart = {
  openLoginForm: boolean,
  setOpenLoginFormFromCart: () => Function
}
const SocialLoginButton = (openLoginFormFrCart : OpenLoginFormFromCart) => {
  const ref = useRef<HTMLDivElement>(null);
  const [isOpenLoginForm, setIsOpenLoginForm] = useState(false);
  const [isOpenMenu, setIsOpenMenu] = useState(false);
  const clear = useAuthStore((state) => state.clearAuth);
  const navigate = useNavigate();
  const username = authService();

  const handleClick = () => {
    if (username) {
      setIsOpenLoginForm(false);
      setIsOpenMenu(true);
    } else {
      setIsOpenLoginForm(true);
      setIsOpenMenu(false)
    }
  }

  const handleLogout = () => {
    const logoutFn = async () => {
      await logout();
      clear();
    } 
    logoutFn();
    navigate("/")
  }

  useEffect(() => {
    setIsOpenLoginForm(openLoginFormFrCart.openLoginForm);
    const handleClickOutside = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        setIsOpenMenu(false);
      }
    };

    document.addEventListener("mousedown", handleClickOutside);

    // window.dispatchEvent(new Event("resize"));
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [openLoginFormFrCart.openLoginForm]);
  
  return (
    <>
      <button className="btn-login" onClick={() => handleClick()}>
        <Person className="login-icon" size={24} />
        <span className="login-text" title={username?.toString()}>
          {username ?? "Đăng nhập"}
        </span>
      </button>
      { !username && isOpenLoginForm && (
        <div className="login-overlay">
          <LoginForm onClose={() => { setIsOpenLoginForm(false); openLoginFormFrCart.setOpenLoginFormFromCart()(false) }} />
        </div>
      )}
        
      { !!username && isOpenMenu && (
        <div ref={ref} className="account-menu" onMouseLeave={() => setIsOpenMenu(false)}>
          <div className="account-area">
            <img src={logo} alt="" />
            <span title={username?.toString()} className="account-text">
              {username}
            </span>
          </div>
            <p>Thông tin tài khoản</p>
            <p onClick={() => navigate("/historyOrder")}>Đơn hàng của tôi</p>
          <p>Thông tin hỗ trợ</p>
          <p className="logout" onClick={() => handleLogout()}>Đăng xuất</p>
        </div>
      )}
    </>
  );
};
export default SocialLoginButton;
