import api from "../../auth/api/axiosClient";
import type { CartItem } from "../type/cart.type";

const cartValidateApi = "/cart/validate";
const validateCartItemApi = (id : number, quantityInCartItem: number) => `books/check?id=${id}&quantityInCartItem=${quantityInCartItem}`;


export const fetchValidateCartApi = (carts : CartItem[])  => {
    return api.post(cartValidateApi, carts);
}

export const fetchIsQuantityInCartItemValid = (id: number, quantityInCartItem: number) => {
    return api.get(validateCartItemApi(id, quantityInCartItem));
}