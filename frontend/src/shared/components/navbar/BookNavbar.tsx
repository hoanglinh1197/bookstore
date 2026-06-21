// import 'BookNavbar.css';

const BookNavbar = () => {
  return (
        <div className ='navbar'>
            <div className='container'>
                <div className='wrap-logo box'>
                    <div className='logo'>
                        <a>
                            <img></img>
                        </a>
                    </div>
                </div>

                <div className='search-box box'>
                    <form>
                        <div className='search-inner'>
                            <input type='search'> Thanh tìm kiếm</input>
                            <input> Nút tìm kiếm</input>
                        </div>
                    </form>
                </div>

                <div className='account box' >

                </div>

                <div className='side-card box'>

                </div>
            </div>
        </div>
  )
}

export default BookNavbar