import { useEffect, useRef, useState } from "react";
import "./BCarousel.css";

const BCarousel = () => {
  const carouselRef = useRef<HTMLDivElement>(null);
  const [currentIndex, setCurrentIndex] = useState(0);


  // Cần sửa lại hành động scroll khi có dữ liệu thật
   const nextSlide = () => {
    setCurrentIndex((prev) =>
      prev === 4 - 1 ? 0 : prev + 1
    );
  };

  const prevSlide = () => {
    setCurrentIndex((prev) =>
      prev === 0 ? 4 - 1 : prev - 1
    );
  };

  
  useEffect(() => {
    const interval = setInterval(() => {
      nextSlide();
    }, 3000);

    return () => clearInterval(interval);
  }, []);
  return (
    <>
      <div className="section-main">
        <div className="carousel-container">
          <div className="c-container">
            <div className="img-container" ref={carouselRef} style={{
          transform: `translateX(-${currentIndex * 100}%)`,
        }}>
              <img key={1} src="//theme.hstatic.net/200000979221/1001338250/14/slide_1_img.jpg?v=388" alt="" className="card" />
              <img key={2} src="//theme.hstatic.net/200000979221/1001338250/14/slide_2_img.jpg?v=388" alt="" className="card" />
              <img key={3} src="//theme.hstatic.net/200000979221/1001338250/14/slide_3_img.jpg?v=388" alt="" className="card" />
              <img key={4} src="//theme.hstatic.net/200000979221/1001338250/14/slide_4_img.jpg?v=388" alt="" className="card" />
            </div>
            <button className="btn-prev" onClick={prevSlide}>
              <span className="icon-arrow left"> ←</span>
            </button>
            <button className="btn-next" onClick={nextSlide}>
              <span className="icon-arrow right">→</span>
            </button>
          </div>
        </div>
        <div className="right-banner">
          <div className="rbanner-container">
            <img src="//theme.hstatic.net/200000979221/1001338250/14/banner_top_1_img.jpg?v=388" alt="" className="rb-card" />
            <img src="//theme.hstatic.net/200000979221/1001338250/14/banner_top_2_img_large.jpg?v=388" alt="" className="rb-card" />
            <img src="//theme.hstatic.net/200000979221/1001338250/14/banner_top_3_img_large.jpg?v=388" alt="" className="rb-card" />
          </div>
        </div>
      </div>
    </>
  );
};

export default BCarousel;
