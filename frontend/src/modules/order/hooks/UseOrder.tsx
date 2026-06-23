import { useMutation, useQuery } from "@tanstack/react-query";
import { createOrder } from "../api/OrderApi";
import { getOrder, getOrdersByStatusOrder } from "../service/OrderService";

export const useCreateOrder = () => {
  return useMutation({
    mutationFn: createOrder,
  });
}

export const useOrders = (shippingStatus: string) => {
  return useQuery({
    queryKey: ["orders", shippingStatus],
    queryFn: () => getOrdersByStatusOrder(shippingStatus),
    enabled: true
  })
}

export const useOrder = (orderCode: string) => {
  return useQuery({
    queryKey: ["order", orderCode],
    queryFn: () => getOrder(orderCode),
    enabled: true
  })
}


// export const updateOrder = async (order: Order) => {
//   const response = await api.put(`/orders/${order.}`, order);
//   return response.data;
// };

// export const deleteOrder = async (id: number) => {
//   const response = await api.delete(`/orders/${id}`);
//   return response.data;
// };