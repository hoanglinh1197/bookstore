import { createBrowserRouter } from 'react-router-dom';
import MainLayout from '../layouts/MainLayout';
import BookDetailPage from '../../pages/book/BookDetailPage';
import ShoppingCartPage from '../../pages/order/ShoppingCartPage';
import AuthLogin from '../../modules/auth/hooks/AuthLogin';
import HomePage from '../../pages/home/HomePage';
import PaymentPage from '../../pages/payment/PaymentPage';
import HistoryOrderPage from '../../pages/order/HistoryOrderPage';
import HistoryOrder from '../../pages/order/HistoryOrder';
import OrderDetail from '../../pages/order/OrderDetail';

const router = createBrowserRouter(
    [
        {
            path:'/',
            element: <MainLayout/>,
            children: [
                {index:true, element: <HomePage/>},
                {path:'productDetail/:id', element: <BookDetailPage/>},
                { path: 'shoppingCart', element: <ShoppingCartPage /> },
                {
                    path: 'historyOrder', element: <HistoryOrderPage />
                    , children: [
                        { index: true, element: <HistoryOrder /> },
                        {path:'orderDetail', element: <OrderDetail/>}
                    ]
                },
                { path: 'auth/success', element: <AuthLogin /> }]
        },
        {
            path:'/payment',
            element: <PaymentPage/>
        }
    ]);

export default router;