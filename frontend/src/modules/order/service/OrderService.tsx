import { fetchOrdersByStatusOrder } from "../api/OrderApi"
import type { HistoryOrderType } from "../type/order.type";

export const getOrdersByStatusOrder = async (orderStatus: string) : Promise<HistoryOrderType[]> => {
    const response = await fetchOrdersByStatusOrder(orderStatus);
    return response.data;
}