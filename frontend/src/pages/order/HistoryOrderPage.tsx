import "./HistoryOrderPage.css";
import { Outlet } from "react-router-dom";
import HistoryOrderAside from "./HistoryOrderAside";

function HistoryOrderPage() {

  return (
    <>
      <div className="his-order-container">
        <HistoryOrderAside></HistoryOrderAside>
        <Outlet></Outlet>
      </div>
    </>
  );
}
export default HistoryOrderPage;
