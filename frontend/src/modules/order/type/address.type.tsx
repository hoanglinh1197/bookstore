import * as z from "zod";
import type { orderChekoutSchema } from "../schema/OrderCheckoutSchema";
export type AddrType = {
  code: number;
  name: string;
}

export type orderCheckoutFormData = z.infer<typeof orderChekoutSchema>;