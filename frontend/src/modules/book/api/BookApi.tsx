import api from "../../auth/api/axiosClient"

const getBookApi = (id: number) : string => `/books/${id}`; 

export const fetchBookApi = (id: number) => {
    return api.get(getBookApi(id));
}
