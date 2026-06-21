import type { BookType } from "../../book/type/Book.type"
import type { ShortTypeCard } from "../../order/type/shippingFee.type"

export type CartItem = {
    id: number,

    name: string,

    price: number,

    discountPrice: number,

    discount: number,

    imgSrc: string,

    quantity?: number
}

export type CartType = {
    cart: CartItem[],

    getQuantity: () => number,

    getTotalprice: () => number,

    getShortTypeCards: () => ShortTypeCard[],

    addToCart: (book: CartItem) => void,
    
    removeFromCart: (book: CartItem) => void,

    deleteBook: (id : number) => void,
    
    clearCart: () => void
}

export type ValidateCartType = {
    books: BookType[], 

    availableStock: number,

    requestedQuantity: number,

    isAvailable: boolean
    
}

export type CartCheckout = ValidateCartType & {
    shippingFee: number,

    discountShipId: number,

    voucherId: number, // day la voucher rieng cua moi cua hang - co trong discount
    
    totalPrice : number
}

export type ValidateQuantityCartItem = {
    valid: boolean,

    stockQuantity: number
}
