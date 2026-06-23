import { useParams } from "react-router-dom";
import { useBook } from "../../../modules/book/hooks/useBook";
import "./ProductDescription.css";
import { useEffect, useRef, useState } from "react";

function ProductDescription() {
  const [isClicked, setClick] = useState(false);
  const [showButton, setShowButton] = useState(false);
  const { id } = useParams();
  const productId = Number(id);
  const { data } = useBook(productId);
  const descriptionRef = useRef<HTMLDivElement>(null);
  debugger;
  useEffect(() => {
    const clientH = descriptionRef.current?.clientHeight;
    const scrollH = descriptionRef.current?.scrollHeight;
    if (clientH && scrollH) setShowButton(scrollH > clientH);
  }, [data]);
  return (
    <>
      <div className="pr-description-container">
        <div className="pr-description-title">
          <p>MÔ TẢ SẢN PHẨM</p>
        </div>
        <div
          className={
            isClicked ? "pr-description-ct expanded" : "pr-description-ct"
          }
          ref={descriptionRef}
        >
          <p >{data?.description}</p>
        </div>
        {isClicked ? showButton &&  (
          <button className="desc-btn" onClick={() => setClick(false)}>
            Thu gọn nội dung
          </button>
        ) : showButton &&  (
          <button className="desc-btn" onClick={() => setClick(true)}>
            Xem thêm nội dung
          </button>
        )}
      </div>
    </>
  );
}

export default ProductDescription;
