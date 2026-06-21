import { useAuthStore } from "../store/AuthStore";

export default function authService() { 
    return useAuthStore((state) => state.user?.username);
}
