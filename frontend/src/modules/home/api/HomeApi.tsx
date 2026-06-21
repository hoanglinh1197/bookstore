import api from "../../auth/api/axiosClient"

const homeApi = (page: number, size: number) : string => `/books?page=${page}&size=${size}`; 
const countBooksApi = (): string => `/books/count`;


export const fetchHomeApi = (page: number, size: number) => {
    return api.get(homeApi(page, size));
}

export const countBooks = () => {
    return api.get(countBooksApi());    
}