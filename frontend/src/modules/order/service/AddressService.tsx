import { fetchAddressApi } from "../api/AddressApi";
import type { AddrType } from "../type/address.type";

export const getProvinces = async () : Promise<AddrType[]> => {
  const response = await fetchAddressApi.get("/p/");
  return response.data;
};

export const getDistricts = async (provinceCode: number): Promise<AddrType[]> => {
  const response = await fetchAddressApi.get(
    `/p/${provinceCode}?depth=2`
  );

  return response.data.districts;
};

export const getWards = async (districtCode: number) : Promise<AddrType[]> => {
  const response = await fetchAddressApi.get(
    `/d/${districtCode}?depth=2`
  );

  return response.data.wards;
};