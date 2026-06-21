import { useLocation } from "react-router-dom";
import "./LoginForm.css";
import { Google, Github, Facebook, X } from "react-bootstrap-icons";

interface Props {
  onClose: () => void
}

function loginForm({ onClose }: Props) {
  const location = useLocation();
  const handleLogin = (type: string) => {
    if (type === "google") {
      debugger
      window.location.href = `http://localhost:8080/oauth2/authorization/${type}?returnUrl=${encodeURIComponent(location.pathname)}`;
    }
  }
  return (
    <>
      <div className="login-form" >
        <div className="hiding-btn">
          <X size={24} onClick={onClose}/>
        </div>
        <div className="login-container">
          <div className="title">
            <p className="lg-title">Login</p>
          </div>
          <div className="container-wrapper">
            <div className="sign-in-container">
              <input type="text" placeholder="Email" />
              <input type="text" placeholder="password" />
              <button className="submit">Đăng nhập</button>
              <div className="divider">
                <div className="line"></div>
                <span>Hoặc đăng nhập với</span>
              </div>
            </div>
            <div className="fb-login" onClick={() => handleLogin("facebook")}>
              <Facebook size={24}  />
              <span>Facebook</span>
            </div>
            <div className="gg-login" onClick={() => handleLogin("google")}>
              <Google size={24}  />
              <span>Google</span>
            </div>
            <div className="github-login" onClick={() => handleLogin("github")}>
              <Github size={24}  />
              <span>Github</span>
            </div>
            <div className="sing-up-text">
              <span>Bạn có tài khoản chưa? </span>
              <a href=""><span>Đăng kí? </span></a>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}

export default loginForm;
