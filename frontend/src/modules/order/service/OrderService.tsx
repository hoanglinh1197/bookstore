import { fetchOrder, fetchOrdersByStatusOrder } from "../api/OrderApi"
import type { HistoryOrderType } from "../type/order.type";

export const getOrdersByStatusOrder = async (orderStatus: string) : Promise<HistoryOrderType[]> => {
    const response = await fetchOrdersByStatusOrder(orderStatus);
    return response.data;
}

export const getOrder = async (orderCode: string): Promise<HistoryOrderType> => {
    const response = await fetchOrder(orderCode);
    return response.data;
}