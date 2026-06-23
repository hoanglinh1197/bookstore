import "./BookDetailPage.css";

import ProductDetail from "../../shared/components/productDetail/ProductDetail";
import ProductDescription from "../../shared/components/productDescription/ProductDescription";
import { useHome } from "../../modules/home/hooks/UseHome";
import { useLocation } from "react-router-dom";
import Slider from "../../shared/components/slider/Slider";
import { useEffect } from "react";

function BookDetailPage() {
  const data = useHome(10);
  const books = data?.data?.pages.flatMap((page) => page.content) || [];
  function ScrollToTop() {
    const { pathname } = useLocation();

    useEffect(() => {
      window.scrollTo(0, 0);
    }, [pathname]);

    return null;
  }
  
  ScrollToTop();
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
            <Slider title="Sản phẩm mua cùng" content={books}></Slider>
          </div>
        </div>
      </div>
    </>
  );
}

export default BookDetailPage;
