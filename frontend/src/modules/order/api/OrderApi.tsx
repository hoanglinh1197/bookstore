import api from "../../auth/api/axiosClient";
import type { HistoryOrderType, OrderType } from "../type/order.type";

const createOrderApi = "/orders";
const ordersApi = (shippingStatus : string) => `/orders?shippingStatus=${shippingStatus}`;
// const updateOrderApi =  (id: number) : string => `/orders?id=${id}`;
// const deleteOrderApi = (id: number) : string => `/orders?id=${id}`;
const orderApi = (orderCode: string): string => `/orders/order?orderCode=${orderCode}`;

export const createOrder = (order : OrderType) => {
  return api.post(createOrderApi, order, {
    withCredentials: true,
  })
}

export const fetchOrders = () => {
  return api.get(createOrderApi, {
    withCredentials: true,
  }
  )
}

export const fetchOrder = (orderCode: string) => {
  return api.get(orderApi(orderCode), {
     withCredentials: true,
  })
}

export const fetchOrdersByStatusOrder = (shippingStatus: string) => {
  return api.get(ordersApi(shippingStatus), {
    withCredentials: true,
  })
}

// export const fetchUpdateOrderApi = axios.create({
//   baseURL: createOrderApi,
// }); 

// export const fetchDeleteOrderApi = axios.create({
//   baseURL: createOrderApi,
// }); 

