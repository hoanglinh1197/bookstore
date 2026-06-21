import { useNavigate } from "react-router-dom";
import api from "../../modules/auth/api/axiosClient";
import { useAuthStore } from "../../modules/auth/store/AuthStore";
import { startsWith } from "zod";

export function setInterceptors() {
  api.interceptors.request.use((config) => {
    const url = ["pay", "api/shippingFee","/orders"];
    const isIn = url.some(x => {
      return (config?.url ?? "").startsWith(x);
    });
    debugger
    if (isIn) {
      const token = useAuthStore.getState().accessToken;
      if (token) config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  });

  api.interceptors.response.use(
    (response) => {
      const url = response.data?.redirectUrl;
      const setAuth = useAuthStore.getState().setAuth;
      // const clearCart = useCartStore((state) => state.clearCart);
     
   if (url === "/api/auth/logout") {
        setAuth({
          user: null,
          accessToken: "",
        })
        // clearCart();
      }
        return response;
    },
    (error) => Promise.reject(error),
  );

  // Kiem tra errorCode response gui ve:
//      TOKEN_EXPIRED(1001),
// 	    INVALID_TOKEN(1002),
// 	    UNAUTHORIZED(1003),
// 	    INVALID_REF_TOKEN(1004),
// 	    ACCESS_DENIED(1005);
  api.interceptors.response.use(
    (response) => response,
    async (error) => {
      // kiem tra loi , neu la token het han thi xin cap lai

      //  config co dang
      //  {
      //   url: "/users",
      //   method: "get",
      //   headers: {
      //     Authorization: "Bearer abc"
      //   },
      //   baseURL: "http://localhost:8080"
      // }
      const returnUrl = window.location.pathname;
      const originalReq = error.config;
      const setAuth = useAuthStore.getState();
      //originalReq._retry -> xac nhan da retry roi
      // status 1001 -> TOKEN EXPIRED
      debugger
      if (error.response?.status === 401 && error.response?.data?.code === 1001 && !originalReq._retry) {
        originalReq._retry = true;
        const res = await api.post(
          `api/auth/refresh`, {},
          {
            withCredentials: true,
          },
        );
        const newToken = res.data.accessToken;
        setAuth.accessToken = newToken;

        // originalReq.headers.Authorization = `Bearer ${newToken}`;
        useNavigate()(returnUrl);
        return api(originalReq);
      }
      //INVALID_REF_TOKEN(1004)
      if (error.response?.status === 401 && error.response?.data?.code == 1004) {
        // yeu cau dang nhap lai, hien thi bang login
        setAuth.setAuth({
          user: null,
          accessToken: "",
        });
      }
      return Promise.reject(error);
    },
  );
}
