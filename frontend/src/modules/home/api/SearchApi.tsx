import api from "../../auth/api/axiosClient";

const searchApi = (name: string) => `books/search?name=${name}`;

export const fetchSeachApi = (name: string) => {
    return api.get(searchApi(name));
}