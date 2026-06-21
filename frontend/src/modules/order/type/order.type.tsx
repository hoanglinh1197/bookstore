import type { HisOrderBookReponseType } from "../../book/type/Book.type"
import type { CartItem } from "../../cart/type/cart.type"

export type OrderType = {
    // danh sach san pham
    // tai khoan account id
    // gia, dia chi, sdt
    // discout id
    // phuong thuc van chuyen
    cart: CartItem[],

    accountName: string,

    discountShippingMethodId: number,

    address: string, // Address da duoc loc de gui lay phi ship

    phone: string,

    // Chua them truong vao db, mac dinh cod
    methodPayment: string,

    // mac dinh giao hang tieu chuan, chinh sua sau: id = 2, db- ghn = 1, ghn - ghc = 2
    shippingMethodId: number,

    shippingFee: number,

    totalPrice: number, // tong tien phai tra

    // hien tai chua bo sung, giam gia cho don hang
    voucherDiscountAmount: number,

    // hien tai chua bo sung
    shippingDiscountAmount: number

}

export type HistoryOrderType = {
    orderCode: String,
   
    orderStatus: String,
    
    carts: HisOrderBookReponseType[],
       
    address: String,
    
    phone: String,
    
    shippingFee: number,
    
    shippingMethod: String,
    
    paymentMethod: String,
    
    createDate: String,
    
    receiveDate: String,
    
    productDiscountAmount: number,
    
    finalTotalPrice: number
}