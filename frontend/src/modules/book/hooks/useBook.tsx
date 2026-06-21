import { useQuery } from "@tanstack/react-query";
import type { BookDetailType } from "../type/Book.type";
import { fetchBookApi } from "../api/BookApi";

export const useBook = (id: number) => {
  return useQuery({
    queryKey: ["book", id],
    queryFn: () => getBook(id),
  });
}

const  getBook = (id : number) : Promise<BookDetailType> => {
    return fetchBookApi(id).then((book): BookDetailType => book.data);
}