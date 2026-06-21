import { fecthLogoutApi } from "../api/LogoutApi"

export const logout = async () => {
    return await fecthLogoutApi();
}