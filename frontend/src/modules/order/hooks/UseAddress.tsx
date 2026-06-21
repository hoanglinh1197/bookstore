import { useQuery } from "@tanstack/react-query"
import { getProvinces, getDistricts, getWards } from "../service/AddressService";

export const useProvinces = () => {
  return useQuery({
    queryKey: ["provinces"],
    queryFn: getProvinces,
    staleTime: Infinity,
  });
};

export const useDistricts = (
  provinceCode: number | null
) => {
  return useQuery({
    queryKey: ["districts", provinceCode],
    queryFn: () => getDistricts(provinceCode!),
    enabled: !!provinceCode,
  });
};

export const useWards = (
  districtCode: number | null
) => {
  return useQuery({
    queryKey: ["wards", districtCode],
    queryFn: () => getWards(districtCode!),
    enabled: !!districtCode,
  });
};