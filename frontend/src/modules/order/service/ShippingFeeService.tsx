import { fetchShippingFeeApi } from "../api/ShippingFee";
import type { ShippingFeeRequest } from "../type/shippingFee.type";

export const getShippingFee = async (req: ShippingFeeRequest): Promise<number> => {
    const response = await fetchShippingFeeApi(req);
    return response.data;
};
