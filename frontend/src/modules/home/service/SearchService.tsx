import type { BookType } from "../../book/type/Book.type";
import { fetchSeachApi } from "../api/SearchApi"

export const search = async (name: string) : Promise<BookType[]> => {
    const response = await fetchSeachApi(name);
    return response.data;
}