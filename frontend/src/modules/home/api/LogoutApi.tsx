import api from "../../auth/api/axiosClient";

const logoutApi = () : string => "/api/auth/logout";

export const fecthLogoutApi = () => {
    return api.post(logoutApi(), {},
  {
    withCredentials: true,
  });
}