import type { BookType } from "../../../modules/book/type/Book.type";
import BCard from "../card/BCard";
import "./BookSlider.css";

 interface BookSliderData{
   title: string | null,
   books: BookType[] | undefined
 }

function BookSlider({title, books}: BookSliderData) {
  return (
    <>
      <div className="listBook">
        <div className="listBook-title">{title}</div>
        <div className="listBook-wrapper">
          {books?.map((book) => {
            return <BCard id={book.id} name={book.name} imgSrc={book.imgSrc} price={book.price} discountPrice={book.discountPrice} discount={book.discount}></BCard>
          })
          }
        </div>
      </div>
    </>
  );
}

export default BookSlider;
