import * as z from "zod";

export const orderChekoutSchema = () => {
    return z.object({
        fullName: z.string().min(5, "Tên tối thiểu 5 kí tự"),

        phone: z.string().regex(/^0\d{9}$/, "Số điện thoại không hợp lệ"),
    
        streetName: z.string().min(5, "Tên đường quá ngắn"),

        methodPayment: z.string().min(2, "Xin hãy chọn phương thức thanh toán"),

        address: z.string().min(1, "Vui lòng chọn địa chỉ giao hàng").refine((value) =>
        {
            const addr = value.split(",").map((part) => part.trim());
            return addr.length === 3
        },{
                message: "Vui lòng chọn đầy đủ tỉnh, huyện, xã.",
         })
    })
}
    
