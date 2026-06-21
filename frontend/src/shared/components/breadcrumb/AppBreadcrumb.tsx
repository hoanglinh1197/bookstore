import Breadcrumb from "react-bootstrap/Breadcrumb";

function AppBreadcrumb() {
  return (
    <>
      <Breadcrumb>
        <Breadcrumb.Item href="#">Home</Breadcrumb.Item>
        <Breadcrumb.Item href="">Library</Breadcrumb.Item>
        <Breadcrumb.Item active>Data</Breadcrumb.Item>
      </Breadcrumb>
    </>
  );
}

export default AppBreadcrumb;
