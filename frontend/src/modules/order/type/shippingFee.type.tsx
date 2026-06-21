export type ShippingFeeRequest = {
    province: string,

    district: string,

    ward: string,

    books : ShortTypeCard[]

}

export type ShortTypeCard = {
    bookId: number,
    
    quantity: number
    
}