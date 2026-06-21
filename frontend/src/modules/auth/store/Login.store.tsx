import { create } from "zustand"
import type { LoginState } from "../types/Login.type";

const createLoginStore = create<LoginState>((set, get) => ({
    isLogin: false,
    setIsLogin: (value) => set({isLogin: value}),
    getIsLogin: () => get().isLogin,
}));



export default createLoginStore;