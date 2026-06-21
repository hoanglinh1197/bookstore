import type { CartItem, ValidateCartType, ValidateQuantityCartItem } from "../type/cart.type";
import { fetchIsQuantityInCartItemValid, fetchValidateCartApi } from "../api/CartApi";


const getValidateCart = (cart: CartItem[]): Promise<ValidateCartType> => {
    return fetchValidateCartApi(cart).then((validateCartObj): ValidateCartType => validateCartObj.data);
}

export const isQuantityInCartItemValid = async(id: number, quantityInCartItem: number) : Promise<ValidateQuantityCartItem> => {
    const response =  await fetchIsQuantityInCartItemValid(id, quantityInCartItem);
    return response.data;
} 