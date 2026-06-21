import { fetchHomeApi, countBooks } from "../api/HomeApi"
import type { BookReponseType } from "../../book/type/Book.type";

export const getBooks = async (page: number, size: number) : Promise<BookReponseType> => {
    const response = await fetchHomeApi(page, size);
    return response.data;
}

export const getNumberOfBooks = async () => {
    const response = await countBooks();
    return response.data;
}