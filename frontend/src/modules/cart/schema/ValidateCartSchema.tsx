import * as z from "zod";
import { isQuantityInCartItemValid } from "../hooks/useValidateCart";

export const validateCartSchema = (bookId: number) => {
    return z.object({
        quantity: z.number().min(1, {message: "Tối thiểu chọn 1"}).refine(
            async (quantity) : Promise<boolean> => {
                const result = await isQuantityInCartItemValid(bookId, quantity);
                return result.valid;
            }, {
                message: "Số lượng đã đạt tối đa",
            }
        )
    })
}