import { useMutation, useQuery } from "@tanstack/react-query";
import { createOrder } from "../api/OrderApi";
import { getOrdersByStatusOrder } from "../service/OrderService";

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
// export const updateOrder = async (order: Order) => {
//   const response = await api.put(`/orders/${order.}`, order);
//   return response.data;
// };

// export const deleteOrder = async (id: number) => {
//   const response = await api.delete(`/orders/${id}`);
//   return response.data;
// };