import "./LineItem.css";
import { Link } from "react-router-dom";
import { validateCartSchema } from "../../../modules/cart/schema/ValidateCartSchema";
import { useCartStore } from "../../../modules/cart/store/CartStore";
import type { CartItem } from "../../../modules/cart/type/cart.type";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm, useWatch } from "react-hook-form";
import { Trash } from "react-bootstrap-icons";
import { useEffect, useState } from "react";

type Params = {
  cartItem: CartItem;
  isEnabbeldCheckbox?: boolean;
  setAllChecked?: Function;
  setSearchInput?: Function;
};
function LineItem(params: Params) {
  if (params.setSearchInput) params.setSearchInput();
  const [isChecked, setChecked] = useState(false);
  const addToCart = useCartStore((state) => state.addToCart);
  const removeFromCart = useCartStore((state) => state.removeFromCart);
  const deleteBookFromCart = useCartStore((state) => state.deleteBook)
  
  const schema = validateCartSchema(params.cartItem.id);

  type FormData = {
    quantity: number;
  };

  const {
    setValue,
    control,
    register,
    trigger,
    formState: { errors },
  } = useForm<FormData>({
    resolver: zodResolver(schema),
    mode: "onChange",
    defaultValues: {
      quantity: params.cartItem.quantity,
    },
  });

  const quantity =
    useWatch({
      control,
      name: "quantity",
    }) ?? 1;

  // khi click tăng hoac giam thi se goi api check`
  const decrease = (book: CartItem) => {
    if (quantity < 2) return;
    removeFromCart(book);
    setValue("quantity", quantity - 1, {
      shouldValidate: true,
    });
  };

  const increase = (book: CartItem) => {
    if (!errors.quantity?.message) {
      setValue("quantity", quantity + 1, {
        shouldValidate: true,
      });
      addToCart(book);
    }
    return;
  };

  const handleChecked = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.checked && params.setAllChecked) params.setAllChecked()(false);
    setChecked(e.target.checked);
  };

  useEffect(() => {
    trigger("quantity");
    if (params.isEnabbeldCheckbox !== undefined) setChecked(params.isEnabbeldCheckbox);
  }, [trigger, params.isEnabbeldCheckbox]);
  return (
    <>
      <div className="shoppingcard-container">
        <div className="img-container">
          <div className="selected-button">
            <label className="label-check">
              <input
                type="checkbox"
                checked={isChecked}
                onChange={(e) => handleChecked(e)}
              />
            </label>
          </div>
          <Link to={`/productDetail/${params.cartItem.id}`}>
            <img src={params.cartItem.imgSrc} alt="" />
          </Link>
        </div>
        <div className="content">
          <Link
            to={`/productDetail/${params.cartItem.id}`}
            style={{ textDecoration: "none" }}
          >
            <p>{params.cartItem.name}</p>
          </Link>
          <div className="price">
            <span>{params.cartItem.price.toLocaleString()}</span>
            <span>{params.cartItem.discountPrice.toLocaleString()}</span>
          </div>
        </div>
        <div className="number">
          <p>
            <b>
              {params.cartItem.discountPrice.toLocaleString()}
              <sup>đ</sup>
            </b>
          </p>
          <div className="book-quantity">
            <button type="button" onClick={() => decrease(params.cartItem)}>
              -
            </button>
            <input type="text" {...register("quantity")} readOnly />
            <button type="button" onClick={() => increase(params.cartItem)}>
              +
            </button>
          </div>
          <p className="errors error-quantity">{errors.quantity?.message}</p>
        </div>
        <div className="delete-container">
          <button className="delete-btn" onClick={() => deleteBookFromCart(params.cartItem.id)}>
            <Trash size={20}></Trash>
          </button>
          </div>
      </div>
    </>
  );
}

export default LineItem;
