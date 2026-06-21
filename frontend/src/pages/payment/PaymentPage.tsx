import "./PaymentPage.css";
import { Truck, Shop, X, QrCode, Cash, Ticket } from "react-bootstrap-icons";
import ReactCountryFlag from "react-country-flag";
import AppNavbar from "../../shared/components/navbar/AppNavbar";
import Footer from "../../shared/components/footer/Footer";
import { useEffect, useState } from "react";
import { useForm, useWatch } from "react-hook-form";

import { zodResolver } from "@hookform/resolvers/zod";

import {
  useDistricts,
  useProvinces,
  useWards,
} from "../../modules/order/hooks/UseAddress";
import type { AddrType } from "../../modules/order/type/address.type";
import { orderChekoutSchema } from "../../modules/order/schema/OrderCheckoutSchema";
import authService from "../../modules/auth/services/authService";
import { useCartStore } from "../../modules/cart/store/CartStore";
import LineItem from "../../shared/components/lineItem/LineItem";
import { DiscountFrame } from "../../shared/components/discount/DiscountFrame";
import { getShippingFee } from "../../modules/order/service/ShippingFeeService";
import { useCreateOrder } from "../../modules/order/hooks/UseOrder";
import type { OrderType } from "../../modules/order/type/order.type";
import LoginForm from "../../shared/components/loginForm/LoginForm";
import SuccessPopupOrder from "../../shared/components/popup/orderSucessfully/SuccessPopupOrder";

function PaymentPage() {
  const schema = orderChekoutSchema();

  type FormData = {
    fullName: string;
    phone: string;
    streetName: string;
    methodPayment: string;
    address: string;
  };

  type AddressType = {
    provinceId: number | null;
    provinceName: string | null;

    districtId: number | null;
    districtName: string;

    wardId: number | null;
    wardName: string | null;
  };
  const {
    register,

    handleSubmit,

    setValue,

    setError,

    trigger,

    getValues,

    control,

    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),

    mode: "onChange",

    defaultValues: {
      fullName: "",

      phone: "",

      streetName: "",

      methodPayment: "",

      address: "",
    },
  });

  console.log(errors);

  const [addr, setAddr] = useState<AddressType>({
    provinceId: null,
    provinceName: "",

    districtId: null,
    districtName: "",

    wardId: null,
    wardName: "",
  });
  const [shippingFee, setShippingFee] = useState<number | null>(null);
  const [methodPayment, setMethodPayment] = useState("");
  const [isShowVoucherForm, setIsShowVoucherForm] = useState(false);
  const [ordersuccessfully, setOrderSuccessfully] = useState(false);
  const [priceToPopup, setPriceToPopup] = useState(0);

  const username = authService();
  const clear = useCartStore((state) => state.clearCart);
  const [isOpenLoginForm, setIsOpenLoginForm] = useState(
    username ? false : true);

  // hien thi thong tin len bang address
  const provinces: AddrType[] | undefined = useProvinces().data;
  const districts: AddrType[] | undefined = useDistricts(addr.provinceId).data;
  const wards: AddrType[] | undefined = useWards(addr.districtId).data;

  const address = useWatch({
    control,
    name: "address",
  });

  const cart = useCartStore((state) => state);
  const totalPrice =
    shippingFee !== null
      ? cart.getTotalprice() + shippingFee
      : cart.getTotalprice();
  const createorder = useCreateOrder();

  const handleClickOnProvince = (province: AddrType) => {
    if (province) {
      setAddr((prev) => ({
        ...prev,
        provinceId: province.code,
        provinceName: province.name,
      }));
      setValue("address", address + province.name, {
        shouldValidate: true,
      });
    }
  };

  const handleClickOnDistrict = (district: AddrType) => {
    if (district) {
      setAddr((prev) => ({
        ...prev,
        districtId: district.code,
        districtName: district.name,
      }));
      setValue("address", address + ", " + district.name, {
        shouldValidate: true,
      });
    }
  };

  const handleClickOnWard = (ward: AddrType) => {
    if (ward) {
      setAddr((prev) => ({
        ...prev,
        wardId: ward.code,
        wardName: ward.name,
      }));
      setValue("address", address + ", " + ward.name, {
        shouldValidate: true,
      });
    }
  };

  const handleClickOnPaymentMethod = (methodPaym: string) => {
    setMethodPayment(methodPaym);
    setValue("methodPayment", methodPaym);
  };

  const OpenVoucherForm = () => {
    setIsShowVoucherForm(true);
  };

  const deleteAddress = () => {
    setValue("address", "", {
      shouldValidate: true,
    });
    setAddr((prev) => ({
      ...prev,
      provinceId: null,
      provinceName: "",

      districtId: null,
      districtName: "",

      wardId: null,
      wardName: "",
    }));
  };

  const onSubmit = () => {
    debugger;
    if (!methodPayment) {
      setError("methodPayment", {
        type: "manual",
        message: "Bạn chưa chọn phương thức thanh toán",
      });
      return;
    } else {
      debugger;
      // goi api dat hang
      const order: OrderType = {
        cart: cart.cart,
        address: address,
        phone: getValues("phone"),
        accountName: username ?? "",
        methodPayment: "COD",
        shippingMethodId: 1,
        shippingFee: shippingFee ?? 0,
        discountShippingMethodId: 0,
        shippingDiscountAmount: 0,
        voucherDiscountAmount: 0,
        totalPrice: totalPrice,
      };
      debugger;
      createorder.mutate(order, {
        onSuccess: (data) => {
          // lam gi do voi data = false, true
          if (data.data > 0) {
            clear();
            setOrderSuccessfully(true);
            setPriceToPopup(data.data)
          } else {
            // Lam gi do khi error
          }
        },
      });
    }
  };

  useEffect(() => {
    const shippingFn = async () => {
      const isValid = await trigger("address");
      if (!isValid) return;
      if (addr.provinceName && addr.districtName && addr.wardName) {
        const shippingF = await getShippingFee({
          province: editAdrress(addr.provinceName).trim(),

          district: editAdrress(addr.districtName).trim(),

          ward: editAdrress(addr.wardName).trim(),

          books: cart.getShortTypeCards(),
        });
        setShippingFee(shippingF ?? "");
      }
    };
    if (!username) {
      setIsOpenLoginForm(true);
    }
    shippingFn();
  }, [address, username]);

  const editAdrress = (dataAddr: string): string => {
    const result = dataAddr.replace(
      /^(Tỉnh|Huyện|Quận|Thành phố|Thị xã|Xã|Phường)\s+/,
      "",
    );
    return result;
  };

  return (
    <>
      <div className="header">
        <div className="payment-navbar">
          <AppNavbar></AppNavbar>
        </div>
      </div>
      <div className="payment-body">
        <form onSubmit={handleSubmit(onSubmit)}>
          <div className="payment-container">
            <div className="pm-left-side">
              <div className="account-area">
                <div className="acc-title-wrapper">
                  <p className="acc-title">Tài khoản</p>
                  <p className="logout">Đăng xuất</p>
                </div>
                <div className="member-cart-wrapper">
                  <div className="img-container">
                    <img src="./src/assets/img/KhongGiaDinh.jpg" alt="" />
                  </div>
                  <div className="acc-info">
                    <p className="acc-name">{username?.toString()}</p>
                    <p className="email">{username?.toString()}</p>
                  </div>
                </div>
              </div>
              <div className="shipping-info-area">
                <p className="title">Thông tin giao hàng</p>
                <div className="button-gr">
                  <button type="button" className="home-delivery">
                    <Truck size={20} />
                    Giao hàng tận nơi
                  </button>
                  <button type="button" className="in-store-pickup">
                    <Shop size={20} />
                    Nhận tại cửa hàng
                  </button>
                </div>
                <div className="shipping-info">
                  <div className="home-delivery-form">
                    <div className="form-area">
                      <div className="name">
                        <label htmlFor="fullName">Họ và tên</label>
                        <input
                          type="text"
                          {...register("fullName")}
                          id="fullName"
                          placeholder="Nhập họ và tên"
                        />
                        <p className="errors err-fullName">
                          {" "}
                          {errors.fullName?.message}
                        </p>
                      </div>
                      <div className="icon-area">
                        <X size={15} className="icon x-fullName"></X>
                      </div>
                    </div>

                    <div className="form-area">
                      <div className="sdt">
                        <input
                          type="text"
                          {...register("phone")}
                          id="phone"
                          placeholder="Nhập số điện thoại"
                        />
                        <p className="errors err-phone">
                          {" "}
                          {errors.phone?.message}
                        </p>
                      </div>
                      <div className="icon-area">
                        <ReactCountryFlag
                          countryCode="VN"
                          svg
                          className="icon-flag"
                        ></ReactCountryFlag>
                      </div>
                    </div>

                    <div className="form-area">
                      <div className="adr">
                        <label htmlFor="adr">Tên đường</label>
                        <input type="text" {...register("streetName")} />
                        <p className="errors err-addr">
                          {errors.streetName?.message}
                        </p>
                      </div>
                      <div className="icon-area">
                        <X size={15} className="icon x-streetName"></X>
                      </div>
                    </div>

                    <div className="form-area">
                      <div className="form-wrapper">
                        <div className="shipping-adr">
                          <input
                            type="text"
                            placeholder="Tỉnh/TP, Quận/Huyện, Phường/Xã"
                            {...register("address")}
                            readOnly
                          />
                          <p className="errors err-address">
                            {errors.address?.message}
                          </p>
                        </div>
                      </div>
                      <div
                        className="icon-area"
                        onClick={() => deleteAddress()}
                      >
                        <X size={15} className="icon x-addr"></X>
                      </div>
                    </div>
                    <div className="addr-container">
                      <div className="addr-title">
                        <div className="title">
                          {!address && !!provinces && (
                            <button type="button" className="btn-province">
                              Tỉnh/Thành
                            </button>
                          )}
                          {!!addr.provinceId && !wards && (
                            <button type="button" className="districts">
                              Quận/Huyện
                            </button>
                          )}

                          {!!addr.districtId && !addr.wardId && (
                            <button type="button" className="wards">
                              Xã/Phường
                            </button>
                          )}
                        </div>

                        <div className="addr-content">
                          {!address && !!provinces && (
                            <div className="pm-address addr-provinces">
                              {provinces.map((province) => (
                                <p
                                  className="addr-province"
                                  onClick={() =>
                                    handleClickOnProvince(province)
                                  }
                                >
                                  {province.name}
                                </p>
                              ))}
                            </div>
                          )}

                          {!!districts && !wards && (
                            <div className="pm-address addr-districts">
                              {districts.map((district) => (
                                <p
                                  className="addr-district"
                                  onClick={() =>
                                    handleClickOnDistrict(district)
                                  }
                                >
                                  {district.name}
                                </p>
                              ))}
                            </div>
                          )}

                          {!!wards && !addr.wardId && (
                            <div className="pm-address addr-wards">
                              {wards.map((ward) => (
                                <p
                                  className="addr-ward"
                                  onClick={() => handleClickOnWard(ward)}
                                >
                                  {ward.name}
                                </p>
                              ))}
                            </div>
                          )}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div className="payment-method">
                <div className="payment-method-container">
                  <p className="title">Phương thức thanh toán</p>
                  <div className="payment-method-wrapper">
                    <div
                      className={
                        methodPayment === "QR-ACB"
                          ? "bank-transfer-active"
                          : "bank-transfer"
                      }
                      onClick={() => handleClickOnPaymentMethod("QR-ACB")}
                    >
                      <QrCode size={20} className="bank-qr-code"></QrCode>
                      <span>Chuyển khoản qua QR-ACB</span>
                      <p></p>
                    </div>
                  </div>

                  <div className="payment-method-wrapper">
                    <div
                      className={
                        methodPayment === "QR-Tech"
                          ? "bank-transfer-active"
                          : "bank-transfer"
                      }
                      onClick={() => handleClickOnPaymentMethod("QR-Tech")}
                    >
                      <QrCode size={20} className="bank-qr-code"></QrCode>
                      <span>Chuyển khoản qua QR-Techcomnbank</span>
                      <p></p>
                    </div>
                  </div>

                  <div className="payment-method-wrapper">
                    <div
                      className={
                        methodPayment === "QR-VCB"
                          ? "bank-transfer-active"
                          : "bank-transfer"
                      }
                      onClick={() => handleClickOnPaymentMethod("QR-VCB")}
                    >
                      <QrCode size={20} className="bank-qr-code"></QrCode>
                      <span>Chuyển khoản qua QR-VCB</span>
                      <p></p>
                    </div>
                  </div>

                  <div className="payment-method-wrapper">
                    <div
                      className={
                        methodPayment === "COD"
                          ? "bank-transfer-active"
                          : "bank-transfer"
                      }
                      onClick={() => handleClickOnPaymentMethod("COD")}
                    >
                      <Cash size={20} className="bank-qr-code"></Cash>
                      <span>Thanh toán khi nhận hàng - COD</span>
                      <p></p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div className="right-side">
              <div className="rs-container">
                <div className="list-item">
                  {cart.cart.map((book) => (
                    <LineItem
                      key={book.id}
                      cartItem={book}
                      isEnabbeldCheckbox={false}
                    ></LineItem>
                  ))}
                </div>
                <div className="discount-code-area">
                  <p>Mã khuyến mãi</p>
                  <button
                    type="button"
                    className="dis-code-container"
                    onClick={OpenVoucherForm}
                  >
                    <Ticket size={22} className="icon"></Ticket>
                    Chọn mã
                  </button>
                  {isShowVoucherForm && (
                    <DiscountFrame
                      onClose={() => setIsShowVoucherForm(false)}
                    ></DiscountFrame>
                  )}
                  <div className="input-dis-code">
                    <input type="text" placeholder="Nhập mã khuyến mãi" />
                    <button type="button" className="submit-dis-code">
                      Áp dụng
                    </button>
                  </div>
                </div>
                <div className="order-info-container">
                  <div className="order-info-wrapper">
                    <p className="title">Tóm tắt đơn hàng</p>
                    <div className="order-info-cont">
                      <div className="orfer-info-item">
                        <p>Tổng tiền hàng</p>
                        <p>
                          {cart.getTotalprice().toLocaleString()}
                          <sup>đ</sup>
                        </p>
                      </div>
                      <div className="orfer-info-item">
                        <p>Phí vận chuyển</p>
                        <p>
                          {shippingFee?.toLocaleString()}
                          <sup>đ</sup>
                        </p>
                      </div>
                      <div className="orfer-info-item">
                        <p>
                          <b>Tổng thanh toán</b>
                        </p>
                        <p>
                          <b>
                            {totalPrice.toLocaleString()}
                            <sup>đ</sup>
                          </b>
                        </p>
                      </div>
                    </div>
                    <div className="order-info-btn">
                      <button type="submit">Đặt hàng</button>
                      <p className="errors err-fullName">
                        {!!methodPayment ? "" : errors.methodPayment?.message}
                      </p>
                    </div>
                    <div className="login-area">
                      {isOpenLoginForm && (
                        <div className="login-overlay">
                          <LoginForm
                            onClose={() => setIsOpenLoginForm(true)}
                          />
                        </div>
                      )}
                    </div>
                  </div>
                </div>
                { ordersuccessfully &&
                (<div className="popup-successful-overlay">
                  <div className="popup-successful-container">
                    <SuccessPopupOrder price={priceToPopup}>
                    </SuccessPopupOrder>
                      </div>
                </div>)}
              </div>
            </div>
          </div>
        </form>
      </div>
      <div className="footer">
        <Footer></Footer>
      </div>
    </>
  );
}

export default PaymentPage;
