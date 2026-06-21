import "./HomePage.css";

import BCarousel from "../../shared/components/carousel/BCarousel";
import Slider from "../../shared/components/slider/Slider";
import BookSlider from "../../shared/components/slider/BookSlider";
import { useHome } from "../../modules/home/hooks/UseHome";

function HomePage() {
  // Lay data sach
  const { data, fetchNextPage, hasNextPage, isFetchingNextPage } = useHome(10);
  const books = data?.pages.flatMap((page) => page.content) || [];
  return (
    <>
      <div className="hp-body">
        <div className="hp-top">
          <div className="hp-left-body"></div>
          <div className="hp-right-body">
            <div className="hp-carousel">
              <BCarousel></BCarousel>
            </div>
          </div>
        </div>
        <div className="hp-bottom">
          <div className="main-slider">
            <Slider content={books}></Slider>
          </div>
          <div className="book-slider">
            <BookSlider
              title="Sản phẩm được yêu thích nhất"
              books={books}
            ></BookSlider>
          </div>
          {hasNextPage && (
            <div className="show-more-container">
              <button
                onClick={() => fetchNextPage()}
                className="show-more-btn"
                disabled={isFetchingNextPage}
              >
                {isFetchingNextPage ? "Đang tải" : "Hiển thị thêm"}
              </button>
            </div>
          )}
        </div>
      </div>
    </>
  );
}

export default HomePage;
