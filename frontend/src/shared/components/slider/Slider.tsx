import "./Slider.css";
import BCard from "../card/BCard";
import { ChevronRight, ChevronLeft } from "react-bootstrap-icons";
import type { BookType } from "../../../modules/book/type/Book.type";
import { useRef, useState } from "react";

interface ChildProps{
  content: BookType[] | undefined;
  title: string;
}

const Slider = (data: ChildProps) => {
  const carouselRef = useRef<HTMLDivElement>(null);
  const [currentIndex, setCurrentIndex] = useState(0);
  
  
    // Cần sửa lại hành động scroll khi có dữ liệu thật
  const nextSlide = () => {
    
    setCurrentIndex((prev) => {
      if (data.content)
        return prev === data.content?.length - 1 ? 0 : prev + 1
      return prev+1;
    })
  };
  
  const prevSlide = () => {
    setCurrentIndex((prev) => {
        if (data.content)
        return prev === 0 ? data.content?.length - 1 : prev - 1
      return prev - 1;
      }
      );
    };
  
  return (
    <>
      <div className="slider">
        <div className="slider-container">
          <div className="slider-title">
            <div className="sl-title-left">
              <div className="title">
                <div className="circle-wrapper">
                  <div className="outer-circle"></div>
                  <div className="inner-circle"></div>
                </div>
                <div>
                  <p>{data.title}</p>
                </div>
              </div>
              <div className="discount-time">
                <button>Ngày</button>
                <button>Giờ</button>
                <button>Phút</button>
                <button>Giây</button>
              </div>
            </div>
            <div className="sl-title-right">
              <div className="moving">
                <button className="sli-prev" onClick={prevSlide}><ChevronLeft size={15}/></button>
                <button className="sli-next" onClick={nextSlide}><ChevronRight size={15}/></button>
              </div>
            </div>
          </div>
          <div className="slider-ct-container">
            <div className="slider-ct" ref={carouselRef} style={{
          transform: `translateX(-${currentIndex * 20}%)`,
        }}>
              {data.content?.map((book => {
                return <BCard id={book.id} name={book.name} imgSrc={book.imgSrc} price={book.price} discountPrice={book.discountPrice} discount={book.discount}></BCard>
              }))}
            </div>
          </div>
        </div>
      </div>
    </>
  );
};

export default Slider;
