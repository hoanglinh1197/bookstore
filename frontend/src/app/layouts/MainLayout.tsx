import "./MainLayout.css";
import { Outlet } from "react-router-dom";

import Header from "../../shared/components/header/Header";
import Footer from "../../shared/components/footer/Footer";




// param: { children }: { children: React.ReactNode }
const MainLayout = () => {

  return (
    <>
      <div className="mainL-container">          
        <div className="main-header">
          <Header></Header>
        </div>
        <Outlet />
        <Footer></Footer>
      
      </div>
    </>
  );
};

export default MainLayout;
