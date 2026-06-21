import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { getBooks, getNumberOfBooks } from "../service/HomeService";
import type { BookReponseType } from "../../book/type/Book.type";


export const useHome = (size: number) => {
  
  return useInfiniteQuery({
    queryKey: ["books"],

    initialPageParam: 1,

    queryFn: ({ pageParam }) => getDataSlider(pageParam, size),
    
    getNextPageParam: (lastPage) => {

      if (lastPage.last) {
        return undefined;
      }

      return lastPage.number + 1;
    }
  })
};

export const useCountBook = () => {
  return useQuery({
    queryKey: ["numberOfBooks"],
    queryFn: () => countBooks(),
  });
}

  const getDataSlider = (page: number, size: number): Promise<BookReponseType> => {
    return getBooks(page, size).then((list: BookReponseType) => list);
  };

  const countBooks = () => {
    return getNumberOfBooks();
  }
