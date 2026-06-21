import "./Footer.css";
import {
  Envelope,
  Twitter,
  Google,
  Facebook,
  Instagram,
  Youtube,
  GeoAlt, // address
  Telephone,
} from "react-bootstrap-icons";

function Footer() {
  return (
    <div className="main-footer">
      <div className="mf-container">
        <div className="mf-ft-top">
          <div className="newsletter-title">
            <span className="receive-news">Đăng ký nhận bản tin</span>
            <span className="text-receive-news">
              Đế nhận các thông tin mới cũng như các chương trình khuyến mãi
            </span>
          </div>
          <div className="newsletter-form">
            <div className="input-wrapper">
              <input
                type="email"
                placeholder="Vui lòng nhập email của bạn..."
              />
              <Envelope size={24} className="icon" />
              <button className="email-register">Đăng kí</button>
            </div>
          </div>
        </div>
      </div>
      <div className="about-me-container">
        <div className="about-me">
          <p className="ft-title">Khai Tâm</p>
          <p>
            Bạn muốn mua một cuốn sách, một sản phẩm có giá trị về đời sống tinh
            thần một cách nhanh chóng, hãy để Khai Tâm giúp bạn tuyển chọn!
          </p>
          <img src="./src/assets/img/footer_logobct_img.png" alt="" />
          <div className="social-contact-container">
            <span className="social-contact">
              <Facebook />
            </span>
            <span className="social-contact">
              <Twitter />
            </span>
            <span className="social-contact">
              <Instagram />
            </span>
            <span className="social-contact">
              <Google />
            </span>
            <span className="social-contact">
              <Youtube />
            </span>
          </div>
        </div>
        <div className="about-me">
          <p className="ft-title">Thông tin liên lạc</p>
          <p>
            Bạn muốn mua một cuốn sách, một sản phẩm có giá trị về đời sống tinh
            thần một cách nhanh chóng, hãy để Khai Tâm giúp bạn tuyển chọn!
          </p>
          <div className="address">
            <span className="address icon">
              <GeoAlt size={18} className="icon" />
              Võ Thi Sáu, P. Thạnh Mỹ, TP.HCM
            </span>{" "}
            <br />
            <span className="phone icon">
              <Telephone size={18} className="icon" />
              0967523645
            </span>
            <br />
            <span className="mail icon">
              <Envelope size={18} className="icon" />
              songtot@abc.com
            </span>
          </div>
        </div>
        <div className="about-me">
          <p className="ft-title">Hỗ trợ khách hàng</p>
          <ul>
            <li>Phương thức giao hàng</li>
            <li>Phương thức thanh toán</li>
            <li>Liên lạc</li>
          </ul>
        </div>
        <div className="about-me">
          <p className="ft-title">Vì sao chọn Khai Tâm</p>
          <ul>
            <li>Phương thức giao hàng</li>
            <li>Phương thức thanh toán</li>
            <li>Liên lạc</li>
          </ul>
        </div>
        <div className="about-me">
          <p className="ft-title">Chính sách</p>
          <ul>
            <li>Phương thức giao hàng</li>
            <li>Phương thức thanh toán</li>
            <li>Liên lạc</li>
          </ul>
        </div>
      </div>
    </div>
  );
}

export default Footer;
