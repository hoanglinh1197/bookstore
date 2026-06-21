import { useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { useAuthStore } from "../store/AuthStore";
import api from "../api/axiosClient";

export default function AuthLogin() {
  const navigate = useNavigate();
  const location = useLocation();
  const params = new URLSearchParams(location.search);
  const setAuth = useAuthStore((state) => state.setAuth);

  useEffect(() => {
    // server response dang
    // return ResponseEntity.ok(
    //     Map.of(
    //         "success", true,
    //         "data", bookDto,
    //         "redirect", true,
    //         "url", "/productDetail/" + book.getId()
    //     )
    // );
    const fetchAuth = async () => {
      try {
        const res = await api.post("api/auth/me", {}, {
          withCredentials: true,
        });
        setAuth({
          user: { username: res.data?.username },
          accessToken: res.data?.accessToken,
        });
        debugger
        navigate(params.get("returnUrl") ?? "/");
      } catch (error) {
        console.error(error);
        // navigate('trang loi')
      }
    };
    fetchAuth();
  }, []);

  return <div>Đang đăng nhập...</div>;
}
