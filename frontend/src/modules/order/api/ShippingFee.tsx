import api from "../../auth/api/axiosClient";
import type { ShippingFeeRequest } from "../type/shippingFee.type";

const getShippingFeeApi = () : string => `api/shippingFee`;

export const fetchShippingFeeApi= (req : ShippingFeeRequest) => {
    return api.post(getShippingFeeApi(), req);
} 