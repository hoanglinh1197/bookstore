import { create } from "zustand";
import type AuthType from "../types/auth.type";
import { persist } from "zustand/middleware";

export const useAuthStore = create<AuthType>()(
  persist(
    (set) => ({
      user: null,
      accessToken: null,

      setAuth: (data) =>
        set((state) => ({
          ...state,
          ...data,
        })),

      clearAuth: () =>
        set({
          accessToken: null,
          user: null,
        }),
    }),
    {
      name: "auth-storage",
    },
  ),
);
