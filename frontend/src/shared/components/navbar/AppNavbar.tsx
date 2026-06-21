import { Cart, Search } from "react-bootstrap-icons";
import "./AppNavbar.css";
import { Link, useNavigate } from "react-router-dom";
import SocialLoginButton from "../socialLoginButton/SocialLoginButton";

import logo from "../../../assets/img/KhongGiaDinh.jpg";
import { useCartStore } from "../../../modules/cart/store/CartStore";
import { useEffect, useRef, useState } from "react";
import type { BookType } from "../../../modules/book/type/Book.type";
import LineItem from "../lineItem/LineItem";
import { search } from "../../../modules/home/service/SearchService";
import { useAuthStore } from "../../../modules/auth/store/AuthStore";

function AppNavbar() {
  const getQuantity = useCartStore((state) => state.getQuantity());
  const [searchInput, setSearchInput] = useState<string>("");
  const [books, setBooks] = useState<BookType[]>();
  const [openLoginForm, setOpenLoginForm] = useState(false);
  const username = useAuthStore((state) => state.user?.username);
  const navigate = useNavigate();
  const ref = useRef<HTMLDivElement>(null);

  const handleSearch = (e: string) => {
    setSearchInput(e);
  };

  const handleClickCart = () => {
    if (username) {
      navigate("/shoppingCart");
    } else {
      setOpenLoginForm(true);
    }
  }

  useEffect(() => {
    const getBookFrSeach = async (name: string) => {
      const result = await search(name);
      setBooks(result ?? "");
    };
    getBookFrSeach(searchInput);

    const handleClickOutside = (e: MouseEvent) => {
      if (ref.current && !ref.current.contains(e.target as Node)) {
        console.log("outside");
        setSearchInput("");
      }
    }
      document.addEventListener("mousedown", handleClickOutside);
      window.dispatchEvent(new Event("resize"));
      return () => {
        document.removeEventListener("mousedown", handleClickOutside);
      };
  }, [searchInput]);

  return (
    <>
      <nav className="navbar">
        <div className="navbar-container">
          <div className="navbar-logo">
            <Link to="/">
              <img src={logo} alt="Trang chủ" />
            </Link>
          </div>
          <div className="nav-link-container">
            <div className="nav-link">
              <div className="navbar-search" ref={ref}>
                <input
                  type="text"
                  value={searchInput}
                  onChange={(e) => handleSearch(e.target.value)}
                />
                <button className="search">
                  <Search size={24} />
                </button>
                {searchInput && books && books?.length > 0 && (
                  <div className="search-result">
                    {books.map((book) => (
                      <LineItem
                        key={book.id}
                        cartItem={book}
                      ></LineItem>
                    ))}
                  </div>
                )}
              </div>
              <div className="account" onMouseLeave={() => setOpenLoginForm(false)}>
                <SocialLoginButton openLoginForm={openLoginForm} setOpenLoginFormFromCart={() => setOpenLoginForm} />
              </div>
              <div className="shopping-card-alert" data-count={getQuantity} onClick={() => handleClickCart()}>
                <Cart size={24}></Cart>
                  Giỏ hàng
              </div>
            </div>
          </div>
        </div>
      </nav>
    </>
  );
}

export default AppNavbar;
