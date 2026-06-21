import axios from "axios";

const addressApi = "https://provinces.open-api.vn/api";

export const fetchAddressApi = axios.create({
  baseURL: addressApi,
}); 
