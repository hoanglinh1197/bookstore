export type BookType = {
  id: number;

  name: string;

  imgSrc: string;

  price: number;

  discountPrice: number,

  discount: number
};

export type HisOrderBookReponseType = BookType & {
  quantity: number,
  
  distributor: string
};

export type BookReponseType = {
  content: BookType[];

  number: number;

  size: number;

  last: boolean;
};

export type BookDetailType = BookType & {
  description: string;

  status: string;

  publishDate: string;

  author: string;

  translator: string;

  publisher: string;

  distributor: string;

  pageCount: number;

  coverType: string;

  weight: number;
}