import "./Header.css";
import AppNavbar from "../navbar/AppNavbar";
import Accordition from "../sidebar/Accordition";
import Breadcrumb from "../breadcrumb/AppBreadcrumb";
import {  List } from "react-bootstrap-icons";
import { Link } from "react-router-dom";

import quality from "../../../assets/img//header_03_policy_1_ico.png";
import free_transport from "../../../assets/img/header_03_policy_2_ico.png";
import check from "../../../assets/img/header_03_policy_3_ico.png";


function Header() {
  // Hàm lấy danh sách các thể loại sách

  return (
    <div className="header">
      <div className="top-area">
        <div className="top-area-container">
          <p className="hotline">
            Hotline: <strong>028.7301.9778</strong> (8h - 19h, thứ 2 đến thứ 7)
            |
          </p>
          <p className="checking-cart">
            <Link to="/shoppingCart">
              Kiểm tra đơn hàng
            </Link>
          </p>
        </div>
      </div>
      <div className="between-area">
        <AppNavbar></AppNavbar>
      </div>
      <div className="bottom-area">
        <div className="bt-container">
            <div className="sidebar-content">
              <div className="category-container">
                <div className="category-wrapper">
                  <div className="category-title">
                    <List size={24} />
                    <span >Danh mục sản phẩm</span>
                  </div>
                  <div className="category-content">
                  </div>
                </div>
              </div>
              <Accordition></Accordition>
            </div>

            <div className="box-policy">
                <div className="box-item">
                    <div className="img-container">
                        <div className="img-content">
                            <img src={quality} alt="" />
                        </div>
                        <span className="policy-label">Đảm bảo chất lượng</span>
                    </div>
                </div>
            </div>

            <div className="box-policy">
                <div className="box-item">
                    <div className="img-container">
                        <div className="img-content">
                            <img src={free_transport} alt="" />
                        </div>
                        <span className="policy-label">Miễn phí vận chuyển</span>
                    </div>
                </div>
            </div>

            <div className="box-policy">
                <div className="box-item">
                    <div className="img-container">
                        <div className="img-content">
                            <img src={check} alt="" />
                        </div>
                        <span className="policy-label">Mở hộp kiểm tra nhận hàng</span>
                    </div>
                </div>
            </div>

        </div>
        <div className="breadcrumb">
          <Breadcrumb></Breadcrumb>
        </div>
      </div>
    </div>
  );
}

export default Header;
