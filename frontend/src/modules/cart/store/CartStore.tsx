import { create } from "zustand";
import { persist } from "zustand/middleware";
import type { CartType } from "../type/cart.type";
import type { ShortTypeCard } from "../../order/type/shippingFee.type";

export const useCartStore = create<CartType>()(
  persist(
    (set, get) => ({
      cart: [],

      getQuantity: () => {
        return get().cart.reduce((total, book) => total + book.quantity, 0);
      },

      getTotalprice: () => {
        return get().cart.reduce(
          (total, book) => total + book.quantity * book.discountPrice,
          0,
        );
      },

      getShortTypeCards: (): ShortTypeCard[] => {
        return get().cart.map((cartItem) => {
          return {
            bookId: cartItem.id,
            quantity: cartItem.quantity,
          };
        });
      },

      addToCart: (book) => {
        const currentCart = get().cart;

        const existed = currentCart.find((item) => item.id === book.id);

        if (existed) {
          set({
            cart: currentCart.map((item) =>
              item.id === book.id
                ? {
                    ...item,
                    quantity: item.quantity + 1,
                  }
                : item,
            ),
          });
        } else {
          set({
            cart: [...currentCart, book],
          });
        }
      },
      
      removeFromCart: (book) => {
        const currentCart = get().cart;

        const existed = currentCart.find((item) => item.id === book.id);

        if (existed) {
          set({
            cart: currentCart.map((item) =>
              item.id === book.id
                ? {
                    ...item,
                    quantity: item.quantity - 1,
                  }
                : item,
            ),
          });
        } else {
          set({
            cart: get().cart.filter((item) => item.id !== book.id),
          });
        }
      },

      deleteBook: (id) => {
        const currentCart = get().cart;

        const existed = currentCart.find((item) => item.id === id);

        if (existed) {
         set({
            cart: get().cart.filter((item) => item.id !== id),
          });
        }
      },

      clearCart: () => {
        set({ cart: [] });
      },
    }),
    {
      name: "auth-storage",
    },
  ),
);
