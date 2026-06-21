import "./BookDetailPage.css";

import ProductDetail from "../../shared/components/productDetail/ProductDetail";
import ProductDescription from "../../shared/components/productDescription/ProductDescription";
import BookSlider from "../../shared/components/slider/BookSlider";
import { useHome } from "../../modules/home/hooks/UseHome";
import { useParams } from "react-router-dom";



function BookDetailPage() {
  const data = useHome(10);
  const books = data?.data?.pages.flatMap((page) => page.content) || [];
  const { bookId } = useParams();
  return (
    <>
    <div className="body">
            <div className="product-detail-container">
              <div className="book-detai">
            <ProductDetail></ProductDetail>
              </div>
              <div className="book-description">
                <ProductDescription></ProductDescription>
              </div>
              <div className="book-slider">
                <BookSlider
                  title="Sản phẩm thường được mua cùng"
                  books={books}
                ></BookSlider>
              </div>
              <div className="book-slider">
                <BookSlider
                  title="Sản phẩm đã xem"
                  books={books}
                ></BookSlider>
              </div>
            </div>
          </div></>
  )
}

export default BookDetailPage