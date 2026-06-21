-- =========================
-- ORDER STATUS
-- =========================
CREATE TABLE order_status (
    id BIGSERIAL PRIMARY KEY,
    order_status VARCHAR(255) NOT NULL
);

-- =========================
-- ROLE
-- =========================
CREATE TABLE role (
    id BIGSERIAL PRIMARY KEY,
    role VARCHAR(255) NOT NULL
);

-- =========================
-- DISCOUNT
-- =========================
CREATE TABLE discount (

    id BIGSERIAL PRIMARY KEY,

    code VARCHAR(100) NOT NULL UNIQUE,

    start_date TIMESTAMP NOT NULL,

    exp_date TIMESTAMP NOT NULL,

    discount_type VARCHAR(50) NOT NULL,

    value NUMERIC(12,2) NOT NULL
);


-- =========================
-- CATEGORY
-- =========================
CREATE TABLE category (
    id BIGSERIAL PRIMARY KEY,
    type VARCHAR(255) NOT NULL
);

-- =========================
-- BOOK
-- =========================
CREATE TABLE book (

    id BIGSERIAL PRIMARY KEY,

    name VARCHAR(255) NOT NULL,

    category_id BIGINT NOT NULL,

    description TEXT,

    img_src VARCHAR(500) NOT NULL,

    price NUMERIC(12,2) NOT NULL,

    status VARCHAR(50) NOT NULL,

    publish_date DATE,

    author VARCHAR(255) NOT NULL,

    translator VARCHAR(255),

    publisher VARCHAR(255),

    distributor VARCHAR(255),

    page_count INTEGER NOT NULL,

    cover_type VARCHAR(100) NOT NULL,

    weight INTEGER NOT NULL,

    stock_quantity INTEGER,

    discount_id BIGINT,

    CONSTRAINT fk_book_category
        FOREIGN KEY (category_id)
        REFERENCES category(id),

    CONSTRAINT fk_book_discount
        FOREIGN KEY (discount_id)
        REFERENCES discount(id)
);

-- =========================
-- SHIPPING STATUS
-- =========================
CREATE TABLE shipping_status (
    id BIGSERIAL PRIMARY KEY,
    shipping_status VARCHAR(255) NOT NULL
);

-- =========================
-- USERS
-- =========================
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    gender INTEGER,
    role_id BIGINT NOT NULL,

    CONSTRAINT fk_users_role
        FOREIGN KEY (role_id)
        REFERENCES role(id)
);

-- =========================
-- ACCOUNT
-- =========================
CREATE TABLE account (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    password VARCHAR(255),
    user_id BIGINT,

    CONSTRAINT fk_account_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
);

-- =========================
-- REVIEW
-- =========================
CREATE TABLE review (
    id BIGSERIAL PRIMARY KEY,
    star INTEGER NOT NULL,
    book_id BIGINT NOT NULL,
    account_id BIGINT NOT NULL,

    CONSTRAINT fk_review_book
        FOREIGN KEY (book_id)
        REFERENCES book(id),

    CONSTRAINT fk_review_account
        FOREIGN KEY (account_id)
        REFERENCES account(id)
);



-- =========================
-- COMMENT
-- =========================
CREATE TABLE comment (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    book_id BIGINT NOT NULL,
    account_id BIGINT NOT NULL,

    CONSTRAINT fk_comment_book
        FOREIGN KEY (book_id)
        REFERENCES book(id),

    CONSTRAINT fk_comment_account
        FOREIGN KEY (account_id)
        REFERENCES account(id)
);
-- =========================
-- SHIPPING_ZONE
-- =========================
CREATE TABLE shipping_zone (

    id BIGSERIAL PRIMARY KEY,

    code VARCHAR(100) NOT NULL UNIQUE,

    name VARCHAR(255) NOT NULL,

    description TEXT,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- SHIPPING_METHOD
-- =========================
CREATE TABLE shipping_method (

    id BIGSERIAL PRIMARY KEY,

    code VARCHAR(100) NOT NULL UNIQUE,

    name VARCHAR(255) NOT NULL,

    description TEXT,

    estimated_days INTEGER NOT NULL,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- =========================
-- ORDERS
-- =========================
CREATE TABLE orders (

    id BIGSERIAL PRIMARY KEY,

    account_id BIGINT NOT NULL,

    shipping_method_id BIGINT NOT NULL,

    shipping_status_id BIGINT NOT NULL,

    order_status_id BIGINT NOT NULL,

    address VARCHAR(500) NOT NULL,

    sdt VARCHAR(20) NOT NULL,

    product_discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0,

    shipping_fee NUMERIC(12,2) NOT NULL DEFAULT 0,

    shipping_discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0,

    voucher_discount_amount NUMERIC(12,2) NOT NULL DEFAULT 0,

    final_total_price NUMERIC(12,2) NOT NULL DEFAULT 0,

    received_date TIMESTAMP,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_account
        FOREIGN KEY (account_id)
        REFERENCES account(id),

    CONSTRAINT fk_orders_shipping_method
        FOREIGN KEY (shipping_method_id)
        REFERENCES shipping_method(id),

    CONSTRAINT fk_orders_shipping_status
        FOREIGN KEY (shipping_status_id)
        REFERENCES shipping_status(id),

    CONSTRAINT fk_orders_order_status
        FOREIGN KEY (order_status_id)
        REFERENCES order_status(id)
);


-- =========================
-- SHIPMENT
-- =========================
CREATE TABLE shipment (

    id BIGSERIAL PRIMARY KEY,

    order_id BIGINT NOT NULL,

    shipping_method_id BIGINT NOT NULL,

    shipping_provider VARCHAR(100) NOT NULL,

    fee NUMERIC(12,2) NOT NULL DEFAULT 0,

    status VARCHAR(50) NOT NULL,

    CONSTRAINT fk_shipment_order
        FOREIGN KEY (order_id)
        REFERENCES orders(id),

    CONSTRAINT fk_shipment_shipping_method
        FOREIGN KEY (shipping_method_id)
        REFERENCES shipping_method(id)
);

-- =========================
-- SHIPPING_RATE
-- =========================

CREATE TABLE shipping_rate (

    id BIGSERIAL PRIMARY KEY,

    shipping_method_id BIGINT NOT NULL,

    shipping_zone_id BIGINT NOT NULL,

    min_weight_gr INTEGER NOT NULL,

    max_weight_gr INTEGER NOT NULL,

    fee NUMERIC(12,2) NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_shipping_rate_method
        FOREIGN KEY (shipping_method_id)
        REFERENCES shipping_method(id),

    CONSTRAINT fk_shipping_rate_zone
        FOREIGN KEY (shipping_zone_id)
        REFERENCES shipping_zone(id),

    CONSTRAINT chk_shipping_rate_weight
        CHECK (min_weight_gr <= max_weight_gr),

    CONSTRAINT uq_shipping_rate
        UNIQUE (
            shipping_method_id,
            shipping_zone_id,
            min_weight_gr,
            max_weight_gr
        )
);


-- =========================
-- ORDER_ITEM
-- =========================

CREATE TABLE order_item (

    id BIGSERIAL PRIMARY KEY,

    order_id BIGINT NOT NULL,

    book_id BIGINT NOT NULL,

    quantity INTEGER NOT NULL,

    -- Giá sách tại thời điểm mua
    unit_price NUMERIC(12,2) NOT NULL
);


-- =========================
-- REFRESH TOKEN
-- =========================
CREATE TABLE refresh_token (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    token_hash TEXT,
    expires_at TIMESTAMP,
    created_at TIMESTAMP,
    revoked BOOLEAN,

    CONSTRAINT fk_refresh_token_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
);

INSERT INTO shipping_method (
    code,
    name,
    description,
    estimated_days
)
VALUES
(
    'STANDARD',
    'Standard Delivery',
    'Giao hàng tiêu chuẩn',
    5
),
(
    'EXPRESS',
    'Express Delivery',
    'Giao hàng nhanh',
    2
),
(
    'SAME_DAY',
    'Same Day Delivery',
    'Giao trong ngày',
    1
);


INSERT INTO shipping_zone (
    code,
    name,
    description
)
VALUES
(
    'HCM_INNER',
    'Nội thành TP.HCM',
    'Khu vực nội thành Hồ Chí Minh'
),
(
    'HCM_OUTER',
    'Ngoại thành TP.HCM',
    'Khu vực ngoại thành Hồ Chí Minh'
),
(
    'SOUTH',
    'Miền Nam',
    'Các tỉnh miền Nam'
),
(
    'CENTRAL',
    'Miền Trung',
    'Các tỉnh miền Trung'
),
(
    'NORTH',
    'Miền Bắc',
    'Các tỉnh miền Bắc'
);

INSERT INTO shipping_rate (
    shipping_method_id,
    shipping_zone_id,
    min_weight_gr,
    max_weight_gr,
    fee,
    is_active
)
VALUES
(
    1,
    1,
    0,
    1000,
    25000,
    true
),
(
    1,
    1,
    1001,
    3000,
    40000,
    true
),
(
    1,
    5,
    0,
    1000,
    45000,
    true
),
(
    2,
    5,
    0,
    1000,
    70000,
    true
),
(1, 2, 0, 1000, 35000, true),
(1, 2, 1001, 3000, 50000, true),
(1, 3, 0, 1000, 40000, true),
(1, 3, 1001, 3000, 60000, true),
(1, 4, 0, 1000, 50000, true),
(1, 4, 1001, 3000, 70000, true),
(2, 2, 0, 1000, 55000, true),
(2, 2, 1001, 3000, 75000, true),
(2, 3, 0, 1000, 60000, true),
(2, 3, 1001, 3000, 85000, true),
(2, 4, 0, 1000, 75000, true),
(2, 4, 1001, 3000, 100000, true),
(3, 2, 0, 1000, 80000, true),
(3, 3, 0, 1000, 120000, true),
(3, 4, 0, 1000, 150000, true),
(3, 5, 0, 1000, 180000, true);


INSERT INTO shipping_status (shipping_status)
VALUES 
('PENDING'),
('PROCESSING'),
('READY_TO_SHIP'),
('SHIPPING'),
('OUT_FOR_DELIVERY'),
('DELIVERED'),
('FAILED'),
('CANCELLED'),
('RETURNED');

INSERT INTO order_status (order_status)
VALUES
('PENDING'),
('PAID'),
('CANCELLED');

INSERT INTO discount (
    code,
    start_date,
    exp_date,
    discount_type,
    value
)
VALUES
---- Voucher giảm %-----
(
    'SALE10',
    NOW(),
    NOW() + INTERVAL '30 days',
    'PERCENTAGE',
    10
),
(
    'BOOK10',
    NOW(),
    NOW() + INTERVAL '7 days',
    'PERCENTAGE',
    10
),
(
    'SAVE50000',
    NOW(),
    NOW() + INTERVAL '15 days',
    'FIXED_AMOUNT',
    50000
),
(
    'FREESHIP30K',
    NOW(),
    NOW() + INTERVAL '7 days',
    'FREE_SHIPPING',
    30000
),
(
    'FREESHIP15K',
    NOW(),
    NOW() + INTERVAL '7 days',
    'FREE_SHIPPING',
    15000
);


INSERT INTO public."role"
(id, "role")
VALUES(1, 'USER');
INSERT INTO public."role"
(id, "role")
VALUES(2, 'ADMIN');


INSERT INTO public."category" 
(type)
VALUES
('Tâm linh'),
('Thiền'),
('Minh triết phương Đông'),
('Triết học phương Tây'),
('Văn học Việt Nam'),
('Văn học Thế Giới'),
('Quản trị & Lãnh đạo'),
('Tài chính & Kế toán'),
('Tiếp thị & Bán hàng'),
('Kỹ năng làm việc'),
('Thành tựu kinh doanh'),
('Nghiên cứu & Phân tích'),
('Lịch sử Việt Nam'),
('Lịch sử Thế giới'),
('Nghệ thuật sống'),
('Tấm gương vĩ đại'),
('Âm nhạc'),
('Hội Họa'),
('Thi ca'),
('Mỹ thuật - Kiến trúc'),
('Du lịch'),
('Khoa học Tự nhiên'),
('Khoa học Xã hội'),
('Khoa học Vũ trụ'),
('Y học - Thực dưỡng'),
('Dưỡng sinh - Yoga'),
('Ẩm thực'),
('Địa lý - Phong thủy'),
('Nghiệp vụ'),
('Từ điển'),
('Ngoại ngữ');


INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(12, 'Chánh Niệm là nguồn năng lượng tỉnh thức đưa ta trở về với giây phút hiện tại và giúp ta tiếp xúc sâu sắc với sự sống trong mỗi phút giây của đời sống hằng ngày. Chúng ta không cần phải đi đâu xa để thực tập chánh niệm. Chúng ta có thể thực tập chánh niệm ngay trong phòng mình hoặc trên đường đi từ nơi này đến nơi khác. Ta vẫn có thể tiếp tục làm những công việc ta thường làm hằng ngày như đi, đứng, nằm, ngồi, làm việc, ăn, uống, giao tiếp, chuyện trò… nhưng với ý thức là mình đang làm những công việc ấy.

Hãy tưởng tượng ta đang ngắm mặt trời mọc với một số người. Trong khi những người khác đang thưởng thức khung cảnh đẹp đẽ ấy thì ta lại “bận rộn” với những thứ trong đầu mình. Ta bận rộn và lo lắng cho những kế hoạch của ta. Ta nghĩ về quá khứ hoặc tương lai mà không thực sự có mặt để trân quý cơ hội đó. Thay vì thưởng thức cảnh đẹp của buổi bình minh, ta lại để cho những khoảnh khắc quý giá ấy trôi qua oan uổng.
 
Nếu quả thực như vậy, ta có thể sử dụng một phương pháp khác. Mỗi khi tâm ta đi lang thang thì ta kéo tâm về và tập trung tâm ý vào hơi thở vào - ra. Thực tập hơi thở ý thức giúp ta trở về với giây phút hiện tại. Thân tâm hợp nhất, ta sẽ có mặt trọn vẹn để ngắm nhìn, quán chiếu và thưởng thức khung cảnh đẹp đẽ ấy. Bằng cách trở về với hơi thở, ta lấy lại được sự mầu nhiệm của buổi bình minh.

Chúng ta thường quá bận rộn đến nỗi quên mình đang làm gì, hoặc có khi ta quên mình là ai. Thậm chí có người quên mất là mình đang thở. Ta quên nhìn những người thương của ta và trân quý sự có mặt của họ, cho đến một ngày họ đi xa hay qua đời ta mới thấy hối tiếc. Có khi rảnh rỗi đi nữa, ta cũng không biết cách tiếp xúc với những gì đang xảy ra trong ta. Vì vậy ta mở ti vi lên xem hoặc nhấc điện thoại gọi cho ai đó. Ta nghĩ làm như thế là ta có thể trốn thoát được chính mình.

Ý thức về hơi thở là tinh yếu của chánh niệm. Theo lời Bụt dạy, chánh niệm là nguồn suối phát sinh hỷ lạc. Hạt giống chánh niệm có trong mỗi chúng ta nhưng thường thì ta quên tưới tẩm hạt giống đó. Nếu biết cách nương vào hơi thở, nương vào bước chân của mình, chúng ta có thể tiếp xúc được với những hạt giống an lành ấy và cho phép chúng biểu hiện. Thay vì nương vào những ý niệm trừu tượng về Bụt, về Chúa hoặc về Allah, chúng ta có thể tiếp xúc được với Bụt, với Chúa trong từng hơi thở và bước chân của mình.

Điều này nghe có vẻ dễ dàng và ai cũng có thể làm được, tuy nhiên đòi hỏi ở chúng ta một sự tập luyện. Quan trọng là tập dừng lại. Dừng lại như thế nào? Dừng lại bằng hơi thở vào ra và bước chân của mình. Vì vậy pháp môn căn bản của chúng ta là hơi thở ý thức và bước chân chánh niệm. Nếu nắm vững những pháp môn này, chúng ta có thể ăn, uống, nấu nướng, làm việc, lái xe… trong chánh niệm. Và chúng ta luôn luôn an trú trong giây phút hiện tại, bây giờ ở đây.

Thực tập Chánh Niệm (smrti) đưa đến Định (samadhi) và định đưa đến Tuệ (prajna). Tuệ giác mà ta đạt được từ sự thực tập chánh niệm có khả năng giải phóng chúng ta ra khỏi những tình trạng sợ hãi, lo âu, tuyệt vọng và đem lại hạnh phúc đích thực cho ta. Chúng ta có thể sử dụng những đối tượng đơn giản như bông hoa để thực tập chánh niệm. Khi cầm bông hoa trong tay, chúng ta ý thức về bông hoa. Hơi thở vào ra giúp ta duy trì ý thức. Thay vì để cho những suy nghĩ trấn ngự hoặc lôi kéo, ta trở về có mặt cho bông hoa và thưởng thức vẻ đẹp của bông hoa. Định lực sẽ trở thành nguồn suối phát sinh niềm vui trong ta.

Để thưởng thức trọn vẹn những món quà mà cuộc sống ban tặng, chúng ta phải thực tập chánh niệm trong mọi lúc, mọi nơi dù đang đánh răng, chuẩn bị thức ăn sáng hay lái xe đi làm. Mỗi bước chân, mỗi hơi thở có thể là một cơ hội đem đến cho ta niềm vui và hạnh phúc. Cuộc sống đầy dẫy khổ đau. Nếu không đủ hạnh phúc, ta sẽ không chăm sóc được nỗi khổ đau và tuyệt vọng của mình. Chúng ta hãy thực tập với tinh thần nhẹ nhàng thư thái, với tâm hồn rộng mở bao la và với một trái tim sẵn sàng lắng nghe, chấp nhận. Thực tập là để nuôi lớn hiểu biết chứ không phải để phô trương hình thức. Có chánh niệm, ta có thể nuôi lớn được niềm vui trong ta, giúp ta xử lý tốt hơn những khó khăn thách thức trong cuộc sống và biết cách chế tác tự do, an lạc, thương yêu trong mỗi chúng ta.', '//cdn.hstatic.net/products/200000979221/952900264_image_677556948f3242fc803abbe4793ec2cb_master_91134fbce50742a3b6c9c91c74f0ef7f_medium.jpg', 'Gieo Trồng Hạnh Phúc', 3, 95200, 'Còn hàng', NULL, 'Thích Nhất Hạnh', 'Chân Hội Nghiêm - Chân Duyệt Nghiêm', 'NXB Lao Động', 'Thái Hà', 279, 'Bìa mềm', 320, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(2, 'Việt sử: Xứ Đàng Trong (1558-1777) - Cuộc Nam tiến của dân tộc Việt Nam

In lần thứ 3

 

... Trong những công trình sử học của Phan Khoang ở thập kỷ 50 - 70 của thế kỷ XX, người ta còn chú ý đến tác giả này bởi lẽ, ông đã dành rất nhiều công sức của mình vào việc nghiên cứu Lịch sử xứ Đàng Trong. Tất nhiên ông không phải là người duy nhất để tâm, có nhiều tác giả ở miền Nam trước 1975 đã có những thành công nhất định trong việc khai phá địa hạt này như Lê Kim Ngân, Nguyễn Thế Anh, Sơn Nam, Nguyễn Hiến Lê…

 

Tuy vậy, theo chúng tôi, các công trình của Phan Khoang như Việt sử xứ Đàng Trong (1558-1777) - Cuộc Nam tiến của dân tộc Việt Nam, ngay từ khi mới ra mắt bạn đọc đã sớm được ghi nhận. Vấn đề là ở chỗ, tác phẩm này không chỉ là sự phục hiện hệ thống và chi tiết nhất về lịch sử hình thành Vương triều Nguyễn nói riêng và lịch sử Đại Việt thời Lê - Trịnh nói chung, mà còn được dưa trên căn bản hệ thống tư liệu rất đồ sộ, quý hiếm. Chúng ta biết rằng, viết về lịch sử xứ Đàng Trong, không chỉ đụng đến lịch sử cuộc Nam tiến hào hùng, đẫm mồ hôi nước mắt của những người con dân Việt can đảm và khai phóng, mà còn đề cập đến lịch sử của vương quốc Chăm Pa, vấn đề Chân Lạp… những thách đố với giới sử học lúc đó và cả ngày hôm nay.

 

Chúng ta biết rằng, lịch sử cuộc Nam tiến của dân tộc Việt Nam (1558 -1777) bắt nguồn từ sự xuất hiện cục diện chính trị Trịnh - Nguyễn phân tranh ở hai bờ sông Gianh. Thử thách lớn đầu tiên của các chúa Nguyễn, “công việc các chúa Nguyễn làm ở Nam Hà” không chỉ là việc tạo dựng lực lượng để “Bắc cự” (chữ dùng hay lột tả 200 năm nội chiến Trịnh - Nguyễn) mà còn lần lượt giải quyết vấn đề Vương quốc Chămpa (tác giả gọi là Chiêm Thành) cũng như vấn đề Thủy Chân Lạp. Tác giả có những nhận định sắc nét: “Như đã thấy, khi cuộc chiếm cứ hết đất Chiêm Thành gần như hoàn tất, với những hoạt động ngoại giao, quân sự, các chúa Nguyễn lần lượt xâm lấn Thủy Chân Lạp để đem vào bản đồ miền Nam rộng rãi, phì nhiêu. Ngoại giao để can thiệp nội tình Hoàng gia Chân Lạp mà nhất là Tiêm La... Còn quân sự chỉ khi cần mới dùng đến”.

 

... Đúng như cái tên sách rất gợi cảm, Việt sử: Xứ Đàng Trong (1558-1777) - Cuộc Nam tiến của dân tộc Việt Nam không chỉ là một cuốn lịch sử của một phần cơ thể dân tộc, quốc gia Việt Nam mà còn là một trong những cuốn sách đầy đặn bậc nhất ở thập kỷ 60 về những vấn đề cơ bản của công cuộc khai phá vùng đất Nam Bộ ngót 300 năm. Đặc biệt, cây bút sử học Phan Khoang có được những nhận định về bản chất của các sự kiện lịch sử (vốn rất phức tạp và chồng chéo) được đưa ra trong quá trình “phục hiện lịch sử Đàng Trong”, sau gần 50 năm, vẫn có sức tham khảo, gợi mở với nhận thức lịch sử ngày nay.

 

Xin có đôi lời về phong cách viết sử của Phan Khoang: một ngòi bút lịch lãm mà giản dị, uyên thâm mà rất bình dân kể cả khi phải đề cập đến những kiến thức lịch sử phức tạp… Nhờ đó, cuốn lịch sử hơn 200 năm mà ông gọi là Việt sử: Xứ Đàng Trong có được một cấu trúc tưởng đơn giản mà chặt chẽ, ngồn ngộn sự kiện mà vẫn không che lấp gương mặt những nhận vật lịch sử, từ tính cách của các chúa Nguyễn đến hình ảnh người bình dân (tác giả gọi là “sinh hoạt của nhân dân”), ngòi bút sử học chính thống được pha trộn khéo léo với văn phong sắc bén của nhà báo, có khi còn mang chút hơi hướng của “tiểu thuyết lịch sử”. 

 

Công trình nghiên cứu tầm cỡ, với dày đặc tên nhân vật, địa danh đều chú kèm chữ Hán rất cẩn trọng này được Nhà xuất bản Khai Trí xuất bản lần đầu tiên năm 1969. Không đầy một năm sau, Phan Khoang mắc bệnh nặng phải ra nước ngoài chữa bệnh. Năm 1971, ông trở lại Sài Gòn rồi mất. Trong bối cảnh đặc biệt của thời cuộc, Việt sử xứ Đàng Trong (1558-1777) (cuộc Nam tiến của dân tộc Việt Nam) đã phản ánh nhận thức của giới sử học miền Nam trước năm 1975 về lịch sử xứ Đàng Trong và những nỗ lực của họ trong phục hiện quá trình xác lập chủ quyền bờ cõi, hoàn chỉnh không gian quốc gia Việt Nam. Có gì đó ẩn hiện phía sau những trang sử ấy là nỗi niềm của một nhà sử học miền Nam, trong bối cảnh đất nước chia cắt và chiến tranh. Mỗi chữ, mỗi dòng đều đáng quý. 

 

- trích Lời giới thiệu của GS-TS Đỗ Quang Hưng
 
 
 
Cảm nhận
 
“… Những người Việt viết sử Việt bây giờ có thể đếm trên đầu ngón tay. Và cứ thực tình mà nói thì quả chúng ta chưa có sử gia đủ kích thước như đòi hỏi của bộ môn, tuy rằng dưới ảnh hưởng của văn minh Trung Hoa, người Việt đã có sách sử gần 8 thế kỷ, và bây giờ đã làm quen với khoa học Tây phương gần 100 năm rồi. Không nhắc tới những điều kiện nghèo nàn về tài liệu, về khả năng sáng tác gây bởi chiến tranh, xáo trộn chính trị… chúng ta cũng phải thấy sự chuyển hướng văn tự của ta là một duyên cớ cắt đứt quá khứ khiến cho tủ sách Việt sử ngày nay thật phải gây ngượng ngùng. Người mới không đủ kiên nhẫn và điều kiện đi vào các tài liệu xưa. Người cũ loay hoay trong mớ giấy bản thật dồi dào sự kiện, nhưng cũng thật chứa nhiều độc tố bảo thủ của một thời đại co rút trong kinh, sử… lại vì sự trì trệ của khung cảnh xã hội, những khuôn mặt sử gia “mới” không thủ đắc thấu đáo những phương pháp của sử học tân tiến với nhân sinh quan vững chắc của con người hiện đại trong khi phải đứng khựng trước đống tài liệu cũ để bằng lòng với những lược dịch, trích văn… Nên dù có vơ vào thật nhiều để tập hợp thành những compilation dày cộm, những sử gia Pháp – bản xứ này cũng phải nhường bước trước uy tín của những ông đồ Nho có Tây học. Nhưng các sử gia của thành phần này còn sống đến nay cũng phải gắng gượng mang một chút thay đổi để làm khởi sắc bộ môn cũng như thành phần của mình. Một Phan Khoang của Việt sử xứ Đàng Trong cho ta thấy rõ điều đó…”
- Tạ Chí Đại Trường
Nguồn: Tập san Sử Ðịa, số 21, Sài Gòn, 1-3/1971, tr. 217-219

 

 

Mục lục
NGUYÊN TẮC BIÊN TẬP
LỜI GIỚI THIỆU
TIỂU DẪN
PHÀM LỆ 
Thời điểm
Địa danh
Cách xưng hô các chúa Nguyễn
Sử liệu
SÁCH, TẠP CHÍ THAM KHẢO

CHƯƠNG NHẤT: THUẬN, QUẢNG TRƯỚC KHI NGUYỄN HOÀNG TRẤN THỦ
I. THỜI BẮC THUỘC
II. THỜI ĐẠI VIỆT ĐỘC LẬP

CHƯƠNG HAI: CÁC CHÚA NGUYỄN

CHƯƠNG BA: CÔNG VIỆC CÁC CHÚA NGUYỄN LÀM Ở NAM HÀ
I. BẮC CỰ (Chiến tranh với họ Trịnh)
II. NAM TIẾN
III. TỔ CHỨC CHÍNH QUYỀN, CÁC CHẾ ĐỘ

CHƯƠNG TƯ: SINH HOẠT CỦA NHÂN DÂN

I. KINH TẾ, CANH NÔNG, THƯƠNG MẠI, TIỂU CÔNG NGHỆ
II. XÃ HỘI, PHONG TỤC
III. VĂN HÓA

PHỤ: NGUYỄN PHƯỚC ÁNH KINH DINH Ở GIA ĐỊNH (1777-1801)', '//cdn.hstatic.net/products/200000979221/a6d8075eb1b98d85757_master__1__524b1856116b41a2a6154514b19c964a_master_32933d1e2cc4430f8a1540bb97fa396d_medium.jpg', 'Việt sử: Xứ Đàng Trong (1558-1777) - Bìa mềm', 5, 239200, 'Còn hàng ', '2025-01-01', 'Phan Khoang', NULL, 'NXB Đà Nẵng', NULL, 544, 'Bìa mềm', 810, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(3, '1. Người cân linh hồn

2. Sen thơm nắng hạ quê mình - Bìa mềm

1. Người cân linh hồn

Anh cho rằng nếu có thể hợp nhất từng nguyên tử của hai linh hồn vốn đã gắn kết sâu xa thì sẽ xuất hiện một trạng thái ưu việt hơn. Dưới bề ngoài châm biếm, James là người đa cảm. Anh hết lòng tin tưởng vào tình bạn, và tình yêu. Lần thí nghiệm duy nhất còn lại mà anh đã nói sẽ phụ thuộc vào cơ may cho anh gặp được hai con người, ngay lúc họ lâm chung, mà trong cuộc đời họ vốn đã có sự gắn kết hoàn hảo: anh sẽ cố hợp nhất họ một lần nữa khi họ chết.
---
Tôi tắt đèn và không nén được tiếng kêu thảng thốt. Một khối cầu ánh sáng đang rực lên trên bệ lò sưởi với ánh hào quang phi thường. Không thể so sánh nó với bất cứ thứ gì ngoài vầng trăng rằm trên bầu trời đêm hè trong vắt, ở Hy Lạp hay phương Đông. Đó là một viên ngọc sáng ngời và trong lòng sâu là những luồng chuyển động còn rạng rỡ hơn, một thứ kim cương lỏng bốc cháy quay cuồng như một tinh vân lấp lánh.

 

Tự thuật của tác giả
 
Tôi đã viết khá nhiều sách, một số là sách tiểu sử, một số là tiểu thuyết. Lạ thay, ở Pháp tôi lại có tiếng là tiểu thuyết gia trong khi ở Anh và Mỹ thì sáng tác của tôi lại ít thành công, còn sách tiểu sử lại được đón nhận tốt. Ngoại lệ duy nhất là một truyện đã xuất bản từ năm 1931 – NGƯỜI CÂN LINH HỒN. Ý tưởng của câu chuyện này, hoàn toàn hư cấu, đã nảy sinh trong Đệ nhất Thế chiến. Nhiều bằng hữu và người thân của tôi đã thiệt mạng vì chiến tranh nên việc tôi hay nghĩ đến cái chết có lẽ là điều tự nhiên. Giai đoạn ấy tôi có đọc trên một nhật báo có hai dòng tin tức về một bác sĩ điên nào đó đã cân tử thi của những người vừa lìa đời, nhưng phải rất lâu (bảy hay tám năm sau) ý tưởng truyện này mới hình thành. Rồi một hôm, ở London, tôi gặp một bác sĩ người Anh đúng ngay mẫu nhân vật mà tôi cần đến, và nhờ động lực này mà truyện được viết xong trong vòng hai tuần. Nhiều độc giả cứ tin là chuyện có thật. Ngay cả bây giờ, sau hơn 30 năm, tôi thỉnh thoảng vẫn nhận được một bức thư hay điện tín từ một nước xa xôi, hỏi rằng: “NGƯỜI CÂN LINH HỒN có thật không?” Khi viết, tôi đã dốc lòng viết sao cho câu chuyện đáng tin và thậm chí còn nhờ một bác sĩ Pháp danh tiếng thời đó, Jean Perrin, nghĩ ra cho tôi một kiểu thiết bị khoa học, một yêu cầu mà ông ấy đã thực hiện vui vẻ và chu đáo.

(trích tự thuật của André Maurois cho bản dịch tiếng Anh “The Weigher Of Souls” – Macmillan 1963)

 

2. Sen thơm nắng hạ quê mình - Bìa mềm

QUẢ TRỨNG

(Thay lời tựa)

        Tôi rời Quảng Ngãi, nơi tôi sinh ra, sau khi học xong lớp Nhì (lớp Bốn bây giờ) tại trường huyện Bình Sơn, một trường tiểu học lớn, đẹp, bề thế mà cha tôi là hiệu trưởng. Tôi mang theo nhiều kỷ niệm của thời mười tuổi, từ ghe thuyền neo bến trên sông Trà Bồng trước mặt nhà, những hồi hộp đầu tiên về tình yêu đọc trong tủ sách tiểu thuyết của cha tôi, cho đến khí thế hào hùng của đội nhi đồng văn hóa đã cùng tôi đi khắp xóm làng hát bể phổi để thúc giục thanh niên “xếp bút nghiên” xông vào Nam khi quân Pháp đổ bộ, mở đầu chiến tranh sau ngày độc lập.

        Tôi rời đứa bé khi nó bắt đầu đến tuổi con trai, biết mơ mộng. Nhưng tôi bị hạ chức thay vì được thăng chức như cha tôi. Từ trường huyện, cha tôi được bổ nhiệm làm hiệu trưởng trường tỉnh Quảng Trị, chức vị trí thức cao nhất tỉnh, vì suốt cả miền Trung lúc đó - trừ Vinh - không có trung học, muốn học thêm phải khăn gói vô Huế. Nhưng tình hình lúc đó đã khó khăn, chiến tranh đe dọa, kinh tế héo hon, cha tôi không thuê nổi nhà trên tỉnh để ở với gia đình, đành chuyển chúng tôi về làng Bồ Bản, quê của mẹ tôi, nơi ông ngoại tôi cho mượn một căn nhà tranh vách đất để tá túc. Tôi bị hạ chức làm cậu học trò nhà quê, học trường làng, con gái không có được một đứa hoa lá cành trong lớp, con trai vừa lo kiếm cỏ cho bò vừa lo kiếm chữ. Trước, tôi đi học trên xe đạp của cha tôi, học trò dọc đường cái ngã mũ chào ông hiệu trưởng, tưởng như chào cả mình. Bây giờ, tôi lủi thủi chân đất, dọc theo bờ ruộng, một bờ, một bờ, lại một bờ, để đến trường, leo teo mái tranh năm lớp, không thấy đâu là cô giáo xinh đẹp đã dạy mình đọc thơ.

        Nhưng rất nhanh, tôi yêu làng Bồ Bản, quê ngoại của tôi. Một phần vì bất cứ cái gì liên quan đến mẹ tôi, tôi đều yêu. Một phần vì làng ngoại của tôi rất đẹp. Ở đâu có sông, ở đấy có cảnh, có tình. Mà khúc sông Thạch Hãn chảy qua làng tôi thì nước trong, bờ phẳng, màu xanh uốn lượn giữa trời đất mênh mông. Mơ mộng, tôi thường nhìn qua bên kia sông mà tưởng tượng vó ngựa của chúa Nguyễn Hoàng khi mới vào Ái Tử. Từ đây, chúa mở nước vào Nam, tôi dẫm lên vết chân của những người mở nước, dựng làng. Con đường đất lớn nhất nằm giữa làng, cạnh nhà tôi, được hai hàng tre cao đứng chầu hai bên, tỏa bóng râm xuống bờ vai, ríu rít tiếng chim từ sáng sớm, đong đưa ru gió trưa hè. Cách đó không xa là ruộng, hết màu xanh nỏn của mạ là vàng ối của lúa trĩu cành, thơm như tóc của mẹ tôi. Tôi bắt đầu kết bạn với lũ chăn trâu, học cưỡi trâu lội qua sông, cắt cỏ từ xa khi hạn hán, gọi con nghé sẩy đàn về chuồng, tưởng mình cũng có thể sống như vậy, không đi học cũng vui.

        Nhưng tôi ở với làng không lâu. Học lớp Nhất chưa được nửa năm thì chiến trận lan đến gần kề. Buổi học cuối cùng của tôi diễn ra ngắn gọn. Thầy giáo chỉ nói một câu, giọng bình thường như chẳng có gì xúc động: “Trường đóng cửa bắt đầu từ hôm nay vì có lệnh tản cư”. Học trò cũng chẳng đứa nào ngạc nhiên hỏi han gì, chỉ xếp tập vở. Mà có gì để ngạc nhiên: tin lính Tây bao vây càn quét đã dội về làng từ cả tuần rồi, ngoài đường, dọc theo bờ nương, du kích đã lom khom đặt đường dây, lũ chăn trâu cho biết là dây mìn. Chúng nó chả sợ gì, chỉ thích. Mà đúng vậy, vì thầy giáo nói thêm một câu trước khi đóng cửa lớp: “Đừng đi qua phía bên kia cầu vì cầu đã đặt mìn”.

        Tôi cũng vậy, ra về chẳng xúc động gì, chỉ lo cho mẹ tôi, lương tiền cạn, nuôi chúng tôi bằng cái gì đây. Từ cả năm rồi, lương cha tôi khi có khi không, có cũng như không vì chưa tiêu đã hết. Cả mấy năm trước đó, trong thời Nhật chiếm đóng, bát cơm trong nhà tôi đã nhiều khoai sắn hơn cơm. Tôi nghĩ cuộc đời học trò của tôi ngang đây là chấm dứt, đứa con cả trong gia đình bỏ học giúp cha mẹ là chuyện bình thường, xung quanh tôi không hiếm.

        Nhưng tôi không thất học, lại còn khám phá ra một chân lý mới: có thể có nhà trường mà không cần thầy giáo. Nhà trường mới của tôi là tủ sách của cha tôi. Vừa giúp mẹ tôi làm những việc lặt vặt để kiếm thêm chút tiền, tôi vừa ngốn hết sách, từ sách giáo khoa cho đến văn học, tiểu thuyết, từ cổ học Chiến Quốc, Xuân Thu đến Phạm Quỳnh Pháp du hành trình nhật ký, mê say có khi quên cả nồi cơm thiếu lửa. Tôi đính hôn với chữ nghĩa văn chương từ ngày ấy, ăn đời ở kiếp với nhau cho đến bây giờ.

        Nhưng tất cả văn chương kim cổ trong tủ sách của cha tôi vẫn không làm tôi hiểu được một lá thư viết như ru. Vài ngày sau khi trường đóng cửa, bỗng có người trao cho tôi một bức thư tay của một anh bạn cùng lớp, lớn hơn tôi ba bốn tuổi. Tôi nhỏ nhất lớp, ngồi bàn đầu, anh lớn nhất lớp, ngồi bàn cuối, chưa hề tiếp xúc chuyện trò làm thân. Chắc anh đã bỏ học nhiều năm, bây giờ đi học lại và học giỏi, làm luận rất hay, bài văn nào cũng được thầy cho đọc trước lớp. Mỗi lần đọc văn như thế, tôi nhìn anh với kính phục. Hình như anh đáp lại ánh mắt của tôi với cái nhìn trìu mến. Anh đi ngang qua tôi, đặt tay vào vai, bấm nhẹ. Trong gia tài văn chương của tôi có những bài luận của anh. Nhưng giữa anh với tôi, khoảng cách xa quá, không phải chỉ vì tuổi tác mà còn vì nhiều cái khác, mơ hồ: tôi trắng trẻo, anh sẫm màu lao động, tôi tuy thiếu cơm nhưng hơi hướng vẫn tiểu tư sản, anh bộ tịch nông dân tuy chưa hẳn là bần cố. Tôi đọc thư anh, từ trang đầu đã nghe giọng văn của anh trong lớp, câu văn du dương không thua gì tiểu thuyết, anh tả cảnh hoàng hôn dơi bay, trăng khuya mờ nhạt, con chim cu thiết tha gọi bạn giữa trưa... toàn những cảnh bâng khuâng bảng lảng gợi nhung nhớ thương cảm vu vơ. Bỗng câu cuối kết luận làm tôi giật mình: “Nhớ bạn lắm bạn ơi, giá lúc này được cầm tay bạn cho đỡ nhớ”.

        Cả đời tôi cứ tự hỏi: ấy là viết văn để viết văn, viết văn như một nhu cầu, viết văn cho nữ thần nghệ thuật, hay đó là bức thư tình máu thịt với một người có thịt có xương?

        Câu hỏi càng ngày càng hợp với thời đại, nhưng tôi cứ để bỏ ngõ, việc gì mà phải trắng đen phân minh để mất đi cái hương vị của một thứ tình đầu? Nhưng đó cũng chưa phải là chuyện để lại dấu ấn sâu đậm nhất trong tôi từ thuở học trò nhà quê cho đến bây giờ. Chuyện khác:

        Vài tuần trước đó, một buổi trưa nắng chang chang, tôi đi học về trễ. Từ trường về nhà, tôi phải đi qua một chợ làng, có thể gọi là phố chợ, tuy phố chỉ thưa thớt vài căn nhà ngói và một dãy quầy hàng bán đủ thứ tạp hóa. Chừng ấy thôi, nhưng sao các chị ngồi sau quầy có vẻ “tư sản” thế, vòng vàng, nhẫn lóng lánh ngón tay, áo thêu, môi đỏ, khiến mình càng cảm thấy bị tụt hậu giai cấp. Khi tôi đi qua thì chợ đã tàn, quầy hàng im vắng, chỉ có mặt trời với bóng tôi. Bỗng tôi nghe tiếng ai gọi tên tôi ở đằng sau. Tôi ngoảnh lui: Trời ơi, chị Xít! Chị là con bác tôi, chưa hề rời khỏi làng Thế Chí, quê nội của tôi tận Huế Thừa Thiên, sao bây giờ chị lưu lạc nơi đây? Bác tôi sinh ra một bầy con, chị là con thứ sáu, bác tôi chơi ngẳng, đặt tên Tây là Six, khai sinh tiếng Việt là Xít luôn, nghe không êm tai, chị bực lắm. Bác tôi làm chức sắc trong làng, bị Việt Minh giết. Anh con trai thứ hai của bác, tất nhiên là anh Đơ, theo Việt Minh, nhập ngũ từ những ngày đầu, bị Tây bắn, bây giờ là liệt sĩ. Bác tôi mất, mặt trận súng nổ, con cái mồ côi tán loạn tứ phương, ai đưa chị Xít đến phố chợ xa lắc này?

        Từ đàng sau chị chạy đến, tay cầm một vật gì trắng trắng. Chị đưa cho tôi: Một quả trứng! Một quả trứng luộc! Chưa bao giờ trong đời tôi được ăn nguyên một quả trứng. Chị bóc một nửa vỏ, nói: “Ăn đi!” Tôi cắn. Giữa trưa nắng, cả người tôi như ngây dại trong khoái lạc chưa từng có.

        Cho đến bây giờ, không một lần nào ăn trứng mà tôi không nghĩ đến chị Xít. Buổi trưa ấy, phố chợ ấy, cái hạnh phúc vô biên được cắn vào quả trứng đầu tiên ấy sẽ theo tôi cho đến tận mồ.

{

        Là bởi vì quả trứng của tôi không phải chỉ là kỷ niệm. Bởi vì nó chính là tôi. Tôi từ quả trứng nhà quê ấy mà nở thành tôi ngày nay, từ cậu học trò nghèo hèn mũi ngửi phân bò mà tôi chưa bao giờ từ giã. Tôi là thế ấy, đã ở trong hoàn cảnh thế ấy, ngất ngây thế ấy. Tôi đã lớn lên, tôi đã trưởng thành, tôi đã thành tôi ngày nay là từ cái hạnh phúc nghèo nàn, tầm thường của quả trứng phố chợ ấy mà ra. Cho nên tôi chưa bao giờ thấy mình gần gũi giới giàu sang. Cho nên tôi thấy mình đã từ trong trứng xa lạ với quyền quý, danh vọng. Cho nên tôi yêu, như đã yêu từ trong trứng, mọi cái tầm thường. Cho nên tôi thấm đạo. Hạnh phúc, đâu phải tìm ở đâu xa. Nó ở ngay nơi mọi cái tầm thường xung quanh tôi. Và nếu mọi cái tầm thường làm nên cái hằng ngày của ta, thì ngày nào chẳng là hạnh phúc? Tôi đã thấm cái chất sống ấy từ những ngày hương đồng gió nội với sách vở của cha tôi chăng? Từ ấy, cái màu trắng, cái màu vàng, sợi tơ lông óng ả đầu tiên đã kết tụ trong quả trứng ấy chăng?

        Một đứa bé nhà quê đã từng biết mót khoai, cắt rạ, không bao giờ dẫm chân trên đất lạ mà không thấy chân mình tương tư mùi đất ruộng ấm lạnh một thời. Tôi tương tư làng tôi. Tôi tương tư nước tôi. Càng già, càng trở về với quả trứng. Càng thấy mình mắc nợ với đứa bé ngày xưa, với gốc gác của nó. Một món nợ không trả được vì nó đã cho mình tất cả, từ trái tim đến máu thịt. Nó cho cả hơi thở, vì đôi lúc một làn gió vô tình thoảng vào mũi mùi gì như mùi lúa nảy đòng đòng. Xa làm sao được quê hương?

        Xa xôi, lữ thứ, cuối đời nghĩ lại quả trứng ngày xưa, cái hạnh phúc vô biên được cắn vào quả trứng đầu tiên trong đời nghèo khó, mơ màng tưởng như cắn cả buổi trưa, cắn cả phố chợ, cắn cả nguồn cội, cắn cả quê hương. Tạ ơn quả trứng, tạ ơn cái đầu tiên, gìn vàng giữ ngọc, suốt đời chỉ có chút chữ nghĩa này.

Tái bút

(Thay lời tựa)



        Xin lẫy Kiều để tái bút:

                    Lời quê chép nhặt dông dài

                    Mua vui cũng được...

        Đời sống bận rộn, đọc nhấm nhí mỗi lần vài trang, chắc cũng được một tuần thư giãn.

                    Mua vui cũng được bảy ngày thong dong.

        Một chút thơ. Một chút thiền. Một chút đạo vị. Gọi là để sống vui. Mà cười nhẹ với cuộc đời, với tất cả.

        Bạn đọc thân mến, xin bắt đầu với thứ Hai...', '//product.hstatic.net/200000979221/product/z6363351581627_1faffe983a09829e7677e170074618b3_daa11cd8f80d4f4eb28a8c9357076a72_medium.jpg', 'Combo Hồn Pháp & Quê Việt - 2 cuốn, giá sốc chỉ 90k!', 6, 90000, 'Còn hàng', NULL, 'André Maurois', 'Đăng Thư', 'Khai Tâm', NULL, 368, 'Bìa mềm', 400, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(33, 'Thám tử vĩ đại Hercule Poirot — ngôi sao huyền thoại của Án mạng trên chuyến tàu tốc hành Phương Đông và Án mạng trên sông Nile của Agatha Christie — tái xuất để giải quyết một bí ẩn vô cùng hấp dẫn trong vụ giết người nhiều lớp, sắp đặt âm mưu tuyệt đỉnh.


Hercule Poirot đi xe khách hạng sang từ London đến điền trang ở khu nhà giàu vùng Kingfisher Hill. Richard Devonport mời vị thám tử nổi tiếng đến đó tìm cách chứng minh vị hôn thê Helen vô tội trong vụ người anh trai Frank bị sát hại. Poirot chỉ có vài ngày điều tra để cứu Helen thoát giá treo cổ. Nhưng kèm theo một điều kiện kỳ lạ: ông phải giấu lý do ông đến đó với những người còn lại trong gia đình Devonport.


Chiếc xe khách buộc phải dừng lại cho một người phụ nữ đau khổ đòi xuống xe, khăng khăng rằng nếu vẫn ngồi trên ghế cô sẽ bị giết. Mặc dù sau đó, hành trình còn lại không hề có ai bị thương, Poirot vẫn thấy tò mò. Và rồi nỗi lo lắng của ông đã thành sự thật khi phát hiện một thi thể đính kèm dòng nhắn nhủ rùng rợn...


Liệu vụ giết người này và sự cố kỳ lạ trên xe khách có phải là manh mối để tìm ra hung thủ giết Frank Devonport không? Và nếu Helen vô tội, liệu Poirot có kịp tìm ra thủ phạm cứu cô thoát khỏi giá treo cổ không?', '//cdn.hstatic.net/products/200000979221/nxbtre_full_10212026_042132_1dcda7610c2b400a8363f2885fd12ea1_medium.jpg', 'Án Mạng Ở Điền Trang Kingfisher Hill - Agatha Christie', 6,104000, 'Còn hàng', '2026-01-01', 'Agatha Christie', 'Lan Huế', 'NXB Trẻ', 'NXB Trẻ', 316, 'Bìa mềm', 450, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(35, 'Ra mắt công chúng lần đầu năm 1847, tiểu thuyết Jane Eyre không chỉ là một câu chuyện hư cấu, mà là kết tinh của cả một đời nếm trải mất mát, nghèo khó, cô lập và khát vọng được công nhận. Độc giả bấy giờ chấn động khi nghe một giọng kể nữ xưng “tôi” mạnh mẽ và thẳng thắn đến vậy. Jane không xinh đẹp, không giàu có, không được che chở bởi gia thế, mà là một cô gái mồ côi phải tự mình bước qua từng thử thách. Nhưng điều khiến người đọc nhớ mãi không phải là hoàn cảnh của Jane, mà là phẩm giá của cô. 

 

Charlotte Brontë không viết về một tiểu thư đài các. Bà lựa chọn một nữ nhân vật bình thường về ngoại hình, thấp kém về địa vị xã hội nhưng có tâm hồn tự do và cao quý. Tư tưởng định hình nên cá tính của Jane chính là sự bình đẳng về linh hồn - niềm tin rằng giá trị con người không phụ thuộc vào tiền bạc hay dòng dõi.

 

Gần hai thế kỷ trôi qua, sức hút của Jane Eyre chưa bao giờ nguội lạnh. Không nằm ở sự hoành tráng, tác phẩm chinh phục hàng triệu độc giả bởi sự chân thực. Bất kỳ ai trong chúng ta, khi thấy mình nhỏ bé hay bị gạt ra lề xã hội, đều có thể tìm thấy sức mạnh từ Jane - một người vừa nhún nhường bền bỉ, dịu dàng mà cũng mạnh mẽ chống lại những xiềng xích định kiến.


 
Giới thiệu tác giả:

 

Charlotte Brontë (1816 - 1855) là nữ văn sĩ người Anh, chị cả trong gia đình Brontë lừng lẫy với ba chị em đều là những tài năng văn chương xuất chúng. Sinh trưởng tại vùng Yorkshire hẻo lánh, bà đã biến cuộc đời đầy thăng trầm và những trải nghiệm khắc nghiệt của bản thân thành chất liệu cho các tác phẩm bất hủ. Với bút danh Currer Bell, bà đã thách thức mọi định kiến giới thời bấy giờ. Charlotte Brontë không chỉ là người kể chuyện tài ba mà còn là biểu tượng cho tinh thần độc lập, tự chủ của phụ nữ trong nền văn học thế giới.', '//cdn.hstatic.net/products/200000979221/b_a_1__3__fbfbb5a76ed1413bb40a40d5e0f354bd_medium.jpg', 'Jane Eyre - Charlotte Brontë', 6, 176000, 'Còn hàng', '2026-01-01', 'Charlotte Brontë', 'Thanh Loan', 'NXB Văn Học', 'Đông A', 624, 'Bìa mềm', 900, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(4, '1. Phương pháp sử học: Những nguyên tắc căn bản

2. Nguyễn Văn Tường - Bộ 2 tập

Phương pháp sử học: Những nguyên tắc căn bản

Các danh từ lịch sử, sử ký, sử học thường bị hiểu lầm và thường được sử đụng lẫn lộn. Chúng ta cần phân biệt rõ rệt:


- Lịch sử, là quá khứ và tất cả những gì đã xảy ra trong quá khứ. Người Đức dùng danh từ geschichte để chỉ định cả lịch sử và sử học; danh từ này từ động từ geschehen mà ra (geschehen có nghĩa là xảy ra và geschichte là cái gì đã xảy ra). Nó bao gồm các biến cố và các hành vi của con người được coi là đáng ghi nhớ.
  
- Sử ký, là sự ghi chép lại quá khứ, nghĩa là tất cả những gì con người đã nói hay đã viết về quá khứ, hoặc như Jacob Burckhardt đã viết, “cái gì mà một thời đại cho là đáng ghi nhớ trong một thời đại khác”.

- Sử học, là ngành học chuyên về sự ghi chép quá khứ. Về điểm này, các danh từ Pháp “histoire” và Anh “history” là từ danh từ cổ Hy Lạp ιστορία mà ra (ιστορία: sử học). Sử học là phương pháp và ngành học cho phép ta luyện nên và lưu truyền lại cho các thế hệ tới sau ký ức của các thời đại đã trôi qua. Sản phẩm của ngành học này là tất cả các văn phẩm chuyên về sự hiểu biết quá khứ.

Qua các định nghĩa sơ lược ở trên, chúng ta thấy rằng sử vừa là quá khứ, và cũng vừa là ký ức của quá khứ. Một dân tộc không có lịch sử, hay không biết gì về lịch sử của mình, thật không khác gì một người không có ký ức, không nhớ được gì, bắt buộc phải lập lại những phát minh đã được thực hiện trong quá khứ, phải giải quyết những vấn đề đã được giải quyết và cũng lại vấp phải những lầm lẫn đã vấp phải. Một mặt, chúng ta cảm thấy một dân tộc không có lịch sử nếu đã không đạt đến một trình độ văn minh tương đối, mặt khác chúng ta cũng không thể quan niệm một nền văn minh không có lịch sử. Cho nên mọi nền đại văn minh trong lịch sử của nhân loại đều thấy cần phải ghi giữ lại ký ức của quá khứ.

 

Mục lục
I. LƯỢC SỬ NGÀNH SỬ HỌC
	1. Một vài định nghĩa.
	2. Lược sử sử học Trung Hoa và Việt Nam.
	3. Lược sử sử học Tây phương.
II. TINH THẦN SỬ HỌC NGÀY NAY.
	1. Một ngành sử học mở rộng và đào sâu.
	2. Sự nghiên cứu một thời đại lịch sử nào cũng là một sự nghiên cứu hiện sử.
	3. Tương quan giữa sử học và các khoa học nhân văn khác.
III. MỤC ĐÍCH CỦA SỰ NGHIÊN CỨU SỬ.
IV. ĐỊNH NGHĨA MỘT SỰ KIỆN LỊCH SỬ.
V. VAI TRÒ CỦA SỬ GIA.
VI. VAI TRÒ CỦA SỬ LIỆU.
	1. Sử liệu là bằng chứng của quá khứ.
	2. Việc tìm và chọn tài liệu.
	3. Các khía cạnh kỹ thuật của vấn đề tài liệu.
	4. Việc khai thác tài liệu.
	5. Vai trò của thư tịch trong việc nghiên cứu sử.
	6. Các tài liệu Hán Việt để lại bởi triều Nguyễn.
VII. THỜI GIAN VÀ KHÔNG GIAN TRONG LỊCH SỬ.
	1. Thời gian trong lịch sử.
	2. Không gian trong lịch sử.
VIII. MỘT LÃNH VỰC ĐẶC BIỆT CỦA SỰ NGHIÊN CỨU SỬ KINH TẾ VÀ XÃ HỘI.
IX. GIÁ TRỊ CỦA SỰ THẬT TÌM RA BỞI SỬ HỌC.
X. ĐỊA VỊ CỦA SỬ TRONG VĂN HÓA.
XI. PHỤ LỤC: ĐỂ LÀM QUEN VỚI PHƯƠNG PHÁP PHÊ KHẢO TÀI LIỆU.
Các bài tập bình luận sử liệu.
Thư mục.
 

Tác giả
Giáo sư Nguyễn Thế Anh sinh năm 1936, từng là Viện trưởng Viện Đại học Huế (1966-1969), Trưởng ban Ban Sử học, Đại học Văn khoa Sài Gòn (1969-1975).

Rời khỏi Việt Nam năm 1975, sau một thời gian ngắn cộng tác với Viện Nghiên cứu Đông Nam Á (Singapore) và làm Giáo sư thỉnh giảng tại Đại học Harvard (Hoa Kỳ), ông làm việc tại Trung tâm Nghiên cứu Khoa học Quốc gia Pháp tại Paris với chức danh Giám đốc Nghiên cứu.

Năm 1991, ông được đề cử làm Giáo sư Trường Nghiên cứu Cao học (École Pratique des Hautes Études - EPHE, Đại học Sorbonne, Paris), cùng đứng đầu Trung tâm Lịch sử và Văn minh khu vực bán đảo Đông Dương tại đây.

Ông hồi hưu năm 2005 với danh hiệu Giáo sư danh dự (professeur émérite). Ông có chân trong ban biên tập các tạp chí học thuật như Bulletin de la Société des Etudes Indochinoises, Bulletin de l Ecole Française d Extrême-Orient, Journal Asiatique, Journal of International and Area Studies, Moussons.
 
Nguyễn Văn Tường: Cuộc chiến chống đô hộ Pháp của nhà Nguyễn - Bộ 2 tập

Tác giả dành toàn thời gian từ tuổi 72 đến 84 để nghiên cứu về nhân vật Nguyễn Văn Tường, thu thập tài liệu ở Thư viện Quốc hội Hoa Kỳ, 5 văn khố ở Pháp, và từ các Trung tâm Lưu trữ cùng hội nghị, hội thảo ở Việt Nam. Thiên khảo luận này trình bày sách lược "Hòa để thủ, thủ để mưu chiến" mà Triều đình Tự Đức và kế tiếp đã ứng dụng, theo đề nghị của Ô. Nguyễn Văn Tường, để chống lại cuộc đô hộ của Pháp, từ sau khi Nam Kỳ mất vào tay Pháp, qua các Hiệp ước 15-3-1874, 31-8-1874, 25-8-1883, và 6-6-1884, cho đến khi Ô. Nguyễn Văn Tường bị đưa đi đày ở Tahiti, Úc châu. 

Tác giả cũng xét lại xem quả vua quan nhà Nguyễn và Ô. Nguyễn Văn Tường có "tham lam", "tàn nhẫn", và "gian trá" như sử sách phổ thông thường nói không? Và nhân dịp đó, hầu hết các nghi vấn, kỳ án liên quan đến vua quan nhà Nguyễn đã được làm sáng tỏ, như: Sẽ không có triều đại nhà Nguyễn nếu không có viện trợ của Bá Đa Lộc? Gia Long rước voi [Tây] về dày mả tổ? Cõng rắn [Xiêm] về cắn gà nhà? Minh Mạng hiếp vợ Hoàng tử Cảnh cho mang thai rồi giết cùng với hai con để chúng khỏi tranh ngôi? Lê Văn Duyệt theo các thừa sai Pháp chống lại Minh Mạng? Tự Đức thông đồng với Trương Đăng Quế giả di chúc của Thiệu Trị để giành ngôi của anh trưởng Hồng Bảo? Rồi giết anh, giết cháu để khỏi bị tranh ngôi? Nguyễn Văn Tường thông gian với vợ Tự Đức, giết vua Kiến Phúc? Ăn hối lộ của người Tàu? Giết hại Trần Tiễn Thành, Dục Đức, và 50 hoàng thân, công tử? "Đầu thú" Pháp? Hàm Nghi bị ép đi kháng chiến, xin về nhưng bị Tôn Thất Thuyết đòi để cái đầu lại? Và nhiều câu chuyện kỳ ảo khác nữa. 

Cuốn sách này chứa đựng những sử liệu gốc và đầu tay do chính tác giả tìm tòi, đối chiếu, phối kiểm, phân tích và tổng hợp, với mục đích soi sáng đường lối thiết thực chống đô hộ Pháp và lòng hy sinh vô bờ bến của vua quan nhà Nguyễn để cứu nước qua đường lối đó. Sách còn có chủ ý nêu lên những vấn đề lịch sử, và cung cấp sử liệu căn bản xác thực cho các Luận án Nghiên cứu Sử học, hay chuyên khảo về các nhân vật lịch sử cùng thời với ông Nguyễn Văn Tường.
---------
Tác giả nói rõ: Ông là hậu duệ đời thứ 3 của đại thần Nguyễn Văn Tường và ông có trách nhiệm, như một người chắt và như một người Việt Nam, nghiên cứu lại lịch sử dưới một luồng ánh sáng khác, đích thực hơn, để xét lại vai trò lịch sử của một nhân vật hàng đầu đã bị các nhà viết sử thời thuộc địa và các lực lượng đồng lõa với kẻ xâm lăng mạt sát thậm tệ, dựng lên một cái bia miệng độc hại về nhân vật đó cho các thế hệ học và viết sử đời sau tiếp diễn. Vô tình, chúng ta đồng lõa kết án một đại thần mà các lực lượng xâm lăng xem như kẻ thù số một phải trừ khử. Họ giết Nguyễn Văn Tường hai lần: một lần khi đày ông qua Tahiti, một lần khi đầu độc ông trong ký ức dân tộc. Làm công việc minh oan cho ông, tác giả Nguyễn Quốc Trị không phải chỉ minh oan cho một người mà còn cho cả một triều đại.

Vấn đề đặt ra cho giới sử học là: chủ đích như vậy có khiến công việc nghiên cứu mang màu sắc chủ quan hay không? Không người cầm bút nào trong lĩnh vực khoa học xã hội nói chung dám quả quyết rằng tôi đây trăm phần trăm khách quan. Nhưng tôi đây, như một người nghiên cứu đích thực, luôn luôn nhắm đến khách quan một cách tối đa, bởi vì lý tưởng của người cầm bút là hướng đến sự thật. Vậy thì quyển sách này hướng đến sự thật như thế nào?

[…]

Chi li, thấu đáo, lịch sử mất nước kể trong quyển sách này không phải chỉ là mất về binh bị, mất về chính trị, mà còn mất cả về văn hóa cho các thế hệ tiếp theo, nghĩa là mất cả cái phương hướng để ta nhìn cho rõ ta và hiểu ta đúng đắn. Trên lĩnh vực sử học, cho đến gần đây, ta chỉ bú mớm một nguồn sữa không phải là sữa mẹ, cũng không phải là sữa khoa học, mà cứ tưởng ta được nuôi trong chân lý. Quyển sách này đem lại một cái giật mình vô cùng cần thiết về sự trung thực. Đây là một tác phẩm sử học không thể thiếu cho bất cứ ai nghiên cứu và dạy học về giai đoạn lịch sử đau thương này.

- Cao Huy Thuần, Nguyên Giáo sư émérite Đại học Picardie (Pháp)

---------
U trung thùy bạch thiên thu hậu,

Xã tắc quân dân thục trọng khinh.

Nguyễn Văn Tường

 

 

Mục lục
 
QUYỂN 1:
LỜI TỰA
MỘT SỐ Ý KIẾN CỦA ĐỘC GIẢ
CÙNG MỘT TÁC GIẢ
LỜI TỰA CỦA ẤN BẢN THỨ NHÌ
ĐỨNG MŨI CHỊU SÀO
LỜI NÓI ĐẦU
LỜI CÁM ƠN
DẪN NHẬP


CHƯƠNG 1: NGUYỄN VĂN TƯỜNG VÀ SÁCH LƯỢC CHỐNG ĐÔ HỘ PHÁP
I. PHÒ VUA TỰ ĐỨC VỚI SÁCH LƯỢC “HÒA ĐỂ THỦ, THỦ ĐỂ MƯU CHIẾN”
A. ĐỀ NGHỊ TẠM BỎ NAM KỲ ĐỂ HÒA HOÃN VÀ TỰ CƯỜNG
B. ÁP DỤNG SÁCH LƯỢC “HÒA ĐỂ THỦ” KHI PHÁP XÂM CHIẾM BẮC KỲ LẦN ĐẦU
C. GÌN GIỮ CHỦ QUYỀN ĐỂ MƯU CHIẾN VỚI CÁC HIỆP ƯỚC 1874
D. “THỦ ĐỂ MƯU CHIẾN” VÀ CÔNG CUỘC TỰ CƯỜNG


II. ÁP DỤNG CHÍNH SÁCH “HÒA ĐỂ THỦ...” DƯỚI CÁC TRIỀU VUA KẾ VỊ
A. THỦ VỚI HỆ THỐNG SƠN PHÒNG VÀ MÂU THUẪN TRUNG PHÁP
B. TÌM MỘT THẾ HÒA MỚI VỚI HIỆP ƯỚC PATENÔTRE, 6-6-1884
C. XÚC TIẾN PHONG TRÀO CẦN VƯƠNG
D. HẬU THUẪN CUỐI CÙNG: HỆ THỐNG SƠN PHÒNG VÀ PHONG TRÀO CẦN VƯƠNG


VÀI LỜI KẾT LUẬN HIẾM HOI VỀ HÀNH TRẠNG CỦA NGUYỄN VĂN TƯỜNG


CHƯƠNG 2: SỬ THUỘC ĐỊA BÔI NHỌ VUA QUAN NHÀ NGUYỄN VÀ NGUYỄN VĂN TƯỜNG
I. SỬ THUỘC ĐỊA BÔI NHỌ GIA LONG VÀ MINH MẠNG
A. GIA LONG CHỊU ƠN PHÁP?
B. MINH MẠNG QUÊN ƠN PHÁP?
C. MINH MẠNG GIẾT CHÁU DÒNG TRƯỞNG VÌ SỢ CHÚNG TRANH NGÔI?


II. NGUYỄN VĂN TƯỜNG TƯ THÔNG VỚI HỌC PHI, GIẾT KIẾN PHÚC?
A. CÁI CHẾT BÌNH THƯỜNG VÌ BỆNH CỦA VUA KIẾN PHÚC
B. BỘ MÁY TUYÊN TRUYỀN PHÁP VÀ CÁI CHẾT CỦA VUA KIẾN PHÚC
C. NGUYỄN HỮU ÐỘ VÀ VIỆC VUA KIẾN PHÚC CHẾT
D. SILVESTRE VÀ SỞ MẬT THÁM PHÁP PHỔ BIẾN TIN ĐỒN
E. MỰC ĐỘ KHẢ TÍN NỘI TẠI CỦA NGUỒN TIN VUA KIẾN PHÚC BỊ ĐẦU ĐỘC


CHƯƠNG 3: NGUYỄN VĂN TƯỜNG VÀ VUA QUAN NHÀ NGUYỄN THAM LAM?
I. NGUYỄN VĂN TƯỜNG THAM NHŨNG VÀ HÀ LẠM?
A. GIAI ĐOẠN SƠ KHỞI CỦA CUỘC ĐỜI HOẠN LỘ CỦA HỌ NGUYỄN
B. NGUYỄN VĂN TƯỜNG MƯU TIẾM NGÔI VUA?


II. NGỤY TẠO, BỎ SÓT VÀ BÓP MÉO TÀI LIỆU ĐỂ BÔI NHỌ
A. SỬ DỤNG VĂN KIỆN GIẢ MẠO
B. BỎ QUA NHỮNG TIN CÓ LỢI CHO NHÂN VẬT CHỐNG PHÁP
C. SỰ XUYÊN TẠC TIN TỨC


III. NGUYỄN VĂN TƯỜNG VÀ NỀN HÀNH CHÁNH KHỔNG MẠNH
A. SỰ CHẾ TÀI CÁC HÀNH VI THAM NHŨNG DƯỚI TRIỀU NGUYỄN
B. THIỆU TRỊ VÀ TỰ ÐỨC ĐỀU LÀ BẠO CHÚA, DIỆT ĐẠO?
C. SỰ BÔI NHỌ CÁC QUAN CÙNG THỜI VỚI NGUYỄN VĂN TƯỜNG


SÁCH DẪN
---
QUYỂN 2:
CHƯƠNG 4: VUA QUAN NHÀ NGUYỄN VÀ NGUYỄN VĂN TƯỜNG TÀN NHẪN?
I. NGUYỄN VĂN TƯỜNG DIỆT ĐẠO VÀ GIẾT VĂN THÂN?


II. NGUYỄN VĂN TƯỜNG GIẾT HẠI VUA, QUAN, HOÀNG THÂN, CÔNG TỬ?
A. SỰ BUỘC TỘI CỦA CÁC VIÊN CHỨC PHÁP
B. NGUYỄN VĂN TƯỜNG GIẾT HẠI BA VUA?


III. SỰ TÀN NHẪN CỦA CÁC “BẠO CHÚA” NHÀ NGUYỄN?
A. NGUYỄN ÁNH GIẾT ĐỖ THANH NHÂN MỘT CÁCH RẤT TÀN NHẪN?
B. CÁC VUA NHÀ NGUYỄN TÀN NHẪN DIỆT ĐẠO GIA TÔ?


IV. SỰ CẦN THIẾT CỦA MỘT CUỐN SỬ “QUỐC GIA”
A. SỬ THỜI PHÁP THUỘC ĐỂ LẠI ẢNH HƯỞNG SÂU ĐẬM VÀO DƯ LUẬN
B. NGUYỄN VĂN TƯỜNG ĐƯ��C DÂN ĐƯƠNG THỜI NGƯỠNG VỌNG


CHƯƠNG 5: AI GIAN TRÁ: NGƯỜI PHÁP HAY NGUYỄN VĂN TƯỜNG VÀ VUA QUAN TRIỀU NGUYỄN?
I. SỰ BÔI NHỌ NGUYỄN VĂN TƯỜNG LÀ NGƯỜI GIAN TRÁ
A. VIẾT LÁCH XUYÊN TẠC RẰNG Ô. TƯỜNG LÀ NGƯỜI GIAN MANH
B. BÔI NHỌ BẰNG THƠ, VÈ
C. BÔI NHỌ BẰNG CHUYỆN TIẾU LÂM
D. PHAO DỰNG SỰ BẤT HÒA GIỮA CÁC ÔNG TƯỜNG, THUYẾT VÀ ÐỘ


II. SỰ GIAN LẬN CỦA PHÁP TRONG HAI LẦN ĐÁNH CHIẾM BẮC KỲ
A. NGUYỄN VĂN TƯỜNG HAY PHÁP GIAN TRÁ TRONG VỤ GARNIER?
B. VỤ CHIẾM BẮC KỲ LẦN THỨ HAI: HENRI RIVIÈRE


III. NHỮNG XẢO TRÁ TRONG HIỆP ƯỚC ĐẦU TIÊN, 1862
A. CUỘC KHÁNG CHIẾN CAN TRƯỜNG NHƯNG BẾ TẮC CỦA QUÂN ĐỘI VIỆT
B. HIỆP ƯỚC NHÂM TUẤT 5-6-1862


BẠT
TIỂU SỬ NGUYỄN VĂN TƯỜNG [1824-1886]
TÀI LIỆU THAM KHẢO
NGUỒN GỐC CÁC HÌNH ẢNH
DANH SÁCH PHỤ LỤC
PHỤ LỤC
SÁCH DẪN', '//product.hstatic.net/200000979221/product/z6363351503105_3d00a8d792a9585cb20b67185c498a7d_a0dcbfea6f5c44bf9da1926e67860bca_medium.jpg', 'Combo Phương pháp và Sự thật lịch sử - 2 cuốn, giảm sốc chỉ 540k!', 13, 540000, 'Còn hàng', NULL, 'Nguyễn Quốc Trị', 'Nguyễn Thế An', 'Khai Tâm', NULL, 2140, 'Bìa mềm', 3600, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(11, 'Khi ta giận, khi một ai đó làm cho ta giận, ta phải trở về với thân tâm và chăm sóc cơn giận của mình. Không nên nói gì hết. Không nên làm gì hết. Khi đang giận mà nói năng hay hành động thì chỉ gây thêm đổ vỡ mà thôi...Như thế là không khôn ngoan. Phải trở về dập tắt lửa trước đã...

Giận là một cuốn sách hay của Thiền sư Thích Nhất Hạnh, nó mở ra cho ta những khả năng kỳ diệu, nhưng lại rất dễ thực hành để ta tự mình từng bước...thoát khỏi cơn giận và sống đẹp với xã hội quanh mình.

Giận được xuất bản tại Hoa Kỳ ngày 10.9.2001, trước biến cố 11.9.2001 có một ngày. Vì thế Giận đã trở thành quyển sách bán chạy nhất Hoa Kỳ - 50.000 bản mỗi tuần - trong vòng 9 tháng...

Tại Hàn Quốc, quyển sách này đã bán được 1 triệu bản trong vòng 11 tháng. Rất nhiều độc giả nhờ đọc sách này mà đã điều phục được tâm mình, sử dụng ái ngữ lắng nghe để hoà giải với người thân, đem lại hạnh phúc trong gia đình và trong cộng đồng của họ.', '//product.hstatic.net/200000979221/product/gian---thich---nhat---hanh---tai---ban---2022_423dfbac5ec74bd189fb9480e1c68f36_medium.png', 'Giận (Tái bản 2023)', 2, 114750, 'Còn hàng ', '2023-01-04', 'Thích Nhất Hạnh', NULL, 'NXB Thế giới', 'Phương Nam', 252, 'Bìa mềm', 380, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(38, 'Stephen Hawking: Một trí tuệ không giới hạn – Một quyển sách phù hợp cho những độc giả yêu thích bộ môn khoa học vũ trụ, hay vẫn luôn dõi theo những tấm gương vượt khó. Cố Giáo sư Stephen Hawking là một tên tuổi đã gắn liền với cả hai điều này. Tuy ông đã ra đi, nhưng các biên tập viên cũng như tác giả của BBC Focus đã sớm hoàn thành việc biên soạn quyển sách này, nói về những khó khăn, trắc trở của ông trong sự nghiệp vật lý; những vật lộn tính toán với thời gian, Lỗ đen và vũ trụ; những thất bại, và cách ông học hỏi từ thất bại; những trăn trở của ông về tương lai loài người trước các nguy cơ. Nói ngắn gọn, nó chứa đựng những nội dung tâm tư cuối cùng mà ông muốn chia sẻ cho ngành Vật lý, cũng như với cả xã hội.

Ngoài ra, sách còn nói về sự đấu tranh không ngừng nghỉ của ông để thoát khỏi sự kiềm hãm của bệnh tật, nhằm sống một cuộc đời no đủ hơn phần lớn những con người lành lặn như chúng ta, cũng như trước những toan tính cắt giảm ngành Y tế của các nhà lập pháp có thể sẽ tước đi quyền lợi từ những người cần được nhận hỗ trợ y tế như ông. Bên cạnh đó, trong sách còn chứa cách nhìn nhận của những tên tuổi trong ngành vật lý đương thời về con người, sự nghiệp và những đóng góp của ông cho ngành, đất nước và toàn thể xã hội.', '//product.hstatic.net/200000979221/product/mot-tri-tue-khong-gioi-han_632cf97dd0774791a25fb1211f71ebf9_medium.png', 'STEPHEN HAWKING: MỘT TRÍ TUỆ KHÔNG GIỚI HẠN', 24, 151200, 'Còn hàng', '2026-01-01', 'BBC', 'Nguyễn Hữu Nhã', 'NXB Tri Thức', 'Alphabooks', 110, 'Bìa mềm', 260, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(14, 'Tiệm cà phê cảm xúc là tập tản văn đưa người đọc bước vào một không gian giàu tính ẩn dụ, nơi mỗi phần sách được ví như một “món” trong tiệm cà phê: trà cho trải nghiệm sống, bánh ngọt cho chữa lành, sô cô la cho tình yêu và cà phê cho ký ức. Từ cấu trúc đó, cuốn sách mở ra nhiều lát cắt quen thuộc của đời sống như trưởng thành, lựa chọn, tổn thương, cô đơn, yêu thương, mất mát và hành trình học cách thấu hiểu chính mình. 

 

Điểm nổi bật của cuốn sách nằm ở giọng văn thủ thỉ, gần gũi, giàu chất trò chuyện. Tác giả không đặt mình ở vị trí khuyên dạy mà viết như một người bạn đồng hành, cùng người đọc nhìn lại những va vấp, những cảm xúc khó gọi tên và những khoảng lặng rất đời thường. Nhờ vậy, cuốn sách tạo được cảm giác nhẹ nhàng nhưng vẫn có độ lắng, phù hợp để đọc chậm, đọc ngẫm và đọc như một cách tự đối thoại với bản thân.

 

Giá trị của cuốn sách trước hết nằm ở khả năng gọi tên và xoa dịu những cảm xúc mà nhiều người trẻ thường trải qua nhưng không dễ bộc lộ. Tác phẩm gợi ra một cách nhìn mềm mại hơn với nỗi buồn, khổ đau và những đổ vỡ, để người đọc không chỉ thấy mình được thấu hiểu mà còn có thể học cách chấp nhận, bao dung và bước tiếp. Bên cạnh đó, sách cũng nhấn mạnh ý nghĩa của việc giữ lại sự chân thành, sự tử tế và kết nối cảm xúc trong một đời sống ngày càng nhiều áp lực.

 

 

ĐỐI TƯỢNG CỦA CUỐN SÁCH:

 

Độc giả trẻ đang trải qua giai đoạn chênh vênh, nhiều suy tư về bản thân, tình yêu và tương lai 
Sinh viên, người mới đi làm hoặc những ai đang đứng trước các lựa chọn quan trọng trong cuộc sống 
Độc giả yêu thích tản văn, sách cảm xúc, sách chữa lành và chiêm nghiệm đời sống 
 
 
 
THÔNG TIN TÁC GIẢ 

 

Lucy San

 

Tên thật: Nguyễn Thị Luyên

Sinh ngày: 11/02/1998

Quê quán: Hải Phòng 

Cung hoàng đạo: Bảo Bình

Ngôn ngữ yêu thích: Tiếng Trung

Học vấn: Đang theo học chương trình Thạc sĩ ngành Thương mại và Kinh doanh Quốc tế tại Đại học Khoa học và Đời sống tại Séc (Czech University of Life Sciences Prague)

 

 

 

TRÍCH ĐOẠN

 

- “Trong suốt cuộc đời, dù đã nếm qua bao nhiêu vị trà – đắng, chát, chua, ngọt… hay trải qua biết bao cung bậc cảm xúc – buồn, vui, yêu, ghét… thì tất cả cũng trở thành những trải nghiệm góp phần làm nên con người ta của hôm nay.

Người lớn nào mà chẳng từng là trẻ con. Trước khi có được sự chín chắn, ai cũng phải đi qua những tháng năm nông nổi, đôi khi dám liều mình vì đam mê. Tuổi trẻ là vậy – cứ thử đi, khi ta còn có nhan sắc và sức khỏe. Ở giai đoạn này, ta chưa nhất thiết phải tìm kiếm một sự nghiệp hay một gia đình ổn định. Sẽ có lúc ta thấy bản thân luôn rơi vào trạng thái mông lung, nhưng rồi lại nhận ra mình vẫn ổn ngay cả trong sự bất ổn ấy.

Cảm ơn những tách trà đã lưu giữ một thời thanh xuân tươi đẹp, để khi nhìn lại, ta có thể mỉm cười vì mình đã từng có một khoảng thời gian đáng nhớ đến vậy.”

 

- “Chúng ta không thể kỳ vọng mọi quân cờ trên bàn cờ cuộc đời đều đi đúng nước mình mong muốn. Sẽ luôn có những được và mất, những nụ cười đan xen cùng những giọt nước mắt. Thay vì mải mê kiếm tìm một đáp án “đúng” duy nhất, hãy kiên trì bước đi để nhận ra rằng: Chỉ khi bản thân thực sự cảm thấy an yên từ bên trong, ta mới có đủ sức mạnh để lan tỏa tình thương đến những người mình trân quý. Lựa chọn không nằm ở việc đi con đường nào dễ nhất, mà là chọn con đường dù có gian truân, trái tim ta vẫn biết đó là nơi mình thuộc về."

 

- “Vì những bước chân vội vã ngoài kia sẽ không dừng lại để nghe bạn khóc.
Vì những tổn thương bạn phải gánh chịu là đủ rồi.
Vì ít nhất vẫn còn tôi ở đây, hiểu được bạn đã phải mạnh mẽ thế nào để bước tiếp trên hành trình cuộc sống đầy chông gai này.
Thế nên,
cầu xin bạn,
hãy thương lấy chính mình!”', '//cdn.hstatic.net/products/200000979221/1ba8173346ca69e264c53f6985bf4517_ee0c72156c0a4b7eb3f233f571450cde_medium.jpg', 'Tiệm Cà Phê Cảm Xúc - Lucy San', 6, 111200, 'Còn hàng', '2026-01-01', 'Lucy San', NULL, 'NXB Thế giới', 'Alphabooks', 200, 'Bìa mềm', 300, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(15, 'Nỗi cô đơn lớn nhất của một người trưởng thành không phải là khi một mình nơi xứ người, mà là cảm giác lạc lõng ngay giữa lòng quê hương. Với những người trẻ rời làng lên phố thị, hay những du học sinh mang theo giấc mơ viễn xứ, "về nhà" đôi khi lại là một cuộc va chạm đầy bối rối. Ta thấy quê hương "lạ" đi vì những con đường nhựa, những nhà máy, vì sự điên cuồng kim tiền của thời đại,  và "lạ" vì chính ta đã mang về một tâm thế khác – một tâm thế đôi khi quá hoài niệm với một bản thể cổ xưa của xóm làng.
 
Tập tản văn "Quê nhà, lạ lạ, quen quen" của tác giả Nguyễn Đình Lộc là những ghi chép chân thực của một người con xa xứ sau mỗi lần trở về từ phương Tây. Cuốn sách không tô hồng sự hoài cổ, cũng không phê phán sự hiện đại hóa; nó đơn giản là một tấm gương soi chiếu nỗi lòng của những người trẻ luôn thấy mình lửng lơ giữa hai thế giới: cũ và mới, Đông và Tây, lạ và quen. Xuyên suốt tác phẩm, tác giả dẫn dắt độc giả đi qua những lát cắt đời thường nhất, nơi những giá trị cùng vấn đề của cả truyền thống và hiện đại đan xen, tạo nên những khoảng lặng đầy suy ngẫm về đổi thay, về những trì trệ, về nhân tình, thế thái, và hơn hết là nguồn cội của tất cả chúng ta.

 

Nằm bên ông nội giữa đêm hè, lắng nghe tiếng quạt mo đưa gió nhịp nhàng, ta chợt nhận ra tình thân là thứ ngôn ngữ nguyên bản nhất, chẳng cần đến bất kỳ sự phiên dịch nào. Chính trong khoảnh khắc tĩnh lặng ấy, mọi khoảng cách về không gian và tư duy sau bao năm viễn xứ đều tan biến, nhường chỗ cho sự thấu hiểu bình dị mà sâu sắc. Ký ức về những "bãi phân bò" hay âm thanh náo nhiệt của buổi sớm quê nhà không đơn thuần là chuyện cũ, mà là những điểm tựa vững chãi giữ cho tâm hồn không bị cuốn trôi hay vỡ vụn giữa một thế giới đang vận hành quá nhanh. Những điều nhỏ bé ấy chính là mạch ngầm nuôi dưỡng bản sắc, giúp ta định vị lại chính mình.

 

Cuốn sách còn là lời hồi đáp đầy bao dung cho những xung đột giá trị giữa người đi và người ở lại. Trước những câu hỏi dồn dập về tiền bạc hay thành công, ta học được cách mỉm cười thấu cảm. Hành trình trưởng thành không phải là chối bỏ quá khứ để trở nên hiện đại, mà là học cách nâng niu những gì đã nhào nặn nên bản thể mình ngày hôm nay.

 

Dành cho những độc giả đang khao khát tìm về gốc rễ, "Quê nhà, lạ lạ, quen quen" là lời nhắn nhủ rằng dù thế giới có thay đổi, dù bản thân ta có khác đi, thì quê nhà vẫn luôn là bản nguyên thuần khiết nhất để ta tìm về mỗi khi mỏi gối chùn chân.', '//cdn.hstatic.net/products/200000979221/b1__que_nha_la_la_quen_quan_e16aeee34a9b49b3a0732298676ef1c1_6f76083508f7475a9d6a6d907459514f_medium.png', 'Quê nhà, lạ lạ quen quen - Nguyễn Đình Lộc', 5, 96000, 'Còn hàng', '2026-01-01', 'Nguyễn Đình Lộc', NULL, 'NXB Văn Học', 'Thái Hà', 240, 'Bìa mềm', 300, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(16, 'Nếu một ngày bạn nhận được tin nhắn từ người đã mất… bạn sẽ mở nó, hay xóa đi?

 

Ba năm sau một biến cố kinh hoàng, Vy chọn cách trốn chạy khỏi quá khứ để sống một cuộc đời lặng lẽ tại Đà Lạt. Cô tự xây lên quanh mình một bức tường băng giá: không nhắc lại, không nhìn lại, và tuyệt nhiên không cho phép mình yếu đuối. Vy tin rằng mình đã đi qua nỗi đau, cho đến khi hộp thư điện tử xuất hiện những email lạ. Không tiêu đề, không người gửi, chỉ có những dòng chữ ngắn ngủi nhưng đầy ám ảnh: “Hôm nay tôi nói dối mẹ rằng tôi ổn.”

 

Điểm khác biệt đầy ma mị của “Hộp thư” nằm ở ranh giới mong manh giữa trí tuệ nhân tạo và tâm thức con người. Điều gì sẽ xảy ra khi một chương trình máy tính không chỉ dừng lại ở các dòng lệnh, mà bắt đầu “học” cách để trở thành chính bạn? Nó không chỉ sao chép ngôn ngữ, mà còn khai quật cả những tầng ký ức bạn đã cố tình vùi lấp.

 

Tác giả Hoàng Thái Duy đặt ra một câu hỏi nhức nhối: Phải chăng công nghệ đang trở thành một loại "hộp đen" lưu trữ những phần chân thật nhất của chúng ta? Trong kỷ nguyên số, ký ức không còn nằm yên trong đầu, nó phân rã và tồn tại đâu đó giữa những đám mây điện tử, chờ đợi một ngày được "kích hoạt" để đối diện với chủ nhân của mình.

 

Vy đang lầm tưởng rằng lãng quên đồng nghĩa với sự chữa lành. Nhưng thực tế, nỗi đau không hề mất đi; nó chỉ ẩn nấp trong những tệp tin cũ kỹ của tâm trí, chờ đợi một sơ hở để trỗi dậy. Chữa lành, hóa ra không phải là xóa sạch quá khứ, mà là khoảnh khắc ta đủ dũng cảm để đứng lại trước tấm gương soi chiếu mọi góc khuất của bản thân – nơi ánh sáng xanh từ màn hình không chỉ rọi lên khuôn mặt, mà rọi thẳng vào những vết sẹo chưa lành.

 

Để rồi, trong một đêm khuya thanh vắng, khi tiếng thông báo tin nhắn vang lên phá tan sự tĩnh lặng, một email không người gửi hiện ra nhưng lại biết chính xác điều bạn chưa từng nói với ai. Bạn sẽ chọn tin vào nó như một sự giải thoát, hay run rẩy sợ hãi trước sự thật đang phơi bày?', '//cdn.hstatic.net/products/200000979221/screenshot_1776825096_a654575dce644a3fb3326a0a81b3c52f_grande_0badb76fc9544baebd3a443f677102a9_medium.png', 'Hộp thư - Hoàng Thái Duy', 6, 87200, 'Còn hàng', '2026-01-01', 'Hoàng Thái Duy', NULL, 'NXB Công Thương', 'Thái Hà', 184, 'Bìa mềm', 250, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(17, 'Với nhiều người trẻ, đi không đơn thuần là rời khỏi nơi chốn quen thuộc, mà để mở rộng tầm mắt, chạm vào những nền văn hóa vừa gần gũi vừa mới mẻ. Đài Loan không xa về địa lí, không lạ về căn tính Á Đông nhưng đủ khác biệt trong nhịp sống và lịch sử, là một vùng đất khiến người ta muốn bước đến, sống chậm lại và quan sát.

 

Bước, Đài Loan là kết quả của hành trình ấy. Với tư cách một người ngụ cư, học tập tại Đài Loan suốt bốn năm, Trần Minh Hợp đã ghi chép những gì mình nếm trải, suy ngẫm, bằng một giọng văn điềm đạm, giàu cảm xúc. Bằng cách “Bước và Viết”, tác giả chậm rãi gom nhặt từng khoảnh khắc nhỏ bé của cảnh, của người, của chữ, ghép thành một bức tranh Đài Loan nhìn từ đời sống thường nhật, qua từng bước đi, qua từng rung động rất đời.

 

Bước, Đài Loan là một chuyến đi nhẹ nhàng mà sâu lắng, dành cho những ai yêu xê dịch, yêu văn chương, và muốn hiểu một Đài Loan gần gũi không qua bản đồ, mà qua những ngày đang sống, những con đường đang in dấu chân.

 

“Viết cho Đài Loan, một mảnh đất hiền hòa.

Mảnh đất thương tôi. Mảnh đất tôi thương.”

 

 

Thông tin tác giả

 

Trần Minh Hợp: Sinh năm 1988 tại Bình Thuận. Hiện là giảng viên ngành Quan hệ quốc tế tại TP.HCM.

 

Sách đã in:

Có gã trai đạp xe run lẩy bẩy - NXB Kim Đồng

Cây dâu tình bạn - NXB Kim Đồng

Bó oải hương từ Provence - NXB Kim Đồng

Đường chạy mùa Xuân - NXB Kim Đồng

Cô gái bán ô màu đỏ - NXB Văn hóa - Văn nghệ

Người buồn thuê - NXB Văn hóa - Văn nghệ

Giường tầng - NXB Công an nhân dân

Gương mặt bán dạo - NXB Tổng hợp TP. HCM

…

 

 

Giải thưởng:

 

Giải thưởng Nhà văn trẻ Thành phố Hồ Chí Minh 2011.

Giải Nhì cuộc thi Văn học di dân và di công Đài Loan 2024 và 2025.', '//cdn.hstatic.net/products/200000979221/van-tre-buoc-dai-loan-tran-minh-hop_ef432b20de0a4f1fb92e62f8003e2cd9_medium.jpg', 'Văn Trẻ - Bước, Đài Loan - Trần Minh Hợp', 3, 55250, 'Còn hàng', '2026-01-01', 'Trần Minh Hợp', NULL, 'NXB Kim Đồng', 'NXB Kim Đồng', 168, 'Bìa mềm', 220, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(18, 'Tác phẩm kinh điển “Hoàng tử bé” ra mắt ấn bản minh họa màu đầu tiên do họa sĩ trẻ Việt Nam thực hiện.

Sách in màu toàn bộ, có bìa cứng kèm bìa áo, mỗi cuốn tặng kèm 01 bookmark “Hoàng tử bé” xinh xắn.

Nhà văn Antoine de Saint-Exupéry (1900-1944) : Ông sinh tại Lyon, Pháp. Chiến tranh Thế giới lần thứ nhất ông theo mẹ sang Thụy Sĩ. Năm 1917, trở về Pháp, học trung học tại Paris, sau đó ông vào trường Mỹ thuật. Trong chiến tranh Thế giới lần thứ hai, ông tham gia không quân. Ngày 31.7.1944, máy bay của ông mất tích trên bầu trời Địa Trung Hải.

Dịch giả, nhà văn Nguyễn Thành Long (1925 - 1991) là cây bút chuyên về truyện ngắn và ký. Ngoài sáng tác, ông còn dịch “Hoàng tử bé”, “Quê xứ con người” của Saint Exupéry.

Họa sĩ Nguyễn Thành Vũ: Chàng hoạ sĩ tự do sinh năm 1993, yêu trẻ con và mơ ước vẽ được thật nhiều sách tranh thiếu nhi Việt Nam. Mong muốn của Vũ là nét vẽ và câu chuyện của mình sẽ đến được với nhiều em nhỏ ở vùng sâu vùng xa, nơi các em không có nhiều điều kiện để đọc sách.

“... Cậu hoàng tử chợp mắt ngủ, tôi bế em lên vòng tay tôi và lại lên đường. Lòng tôi xúc động. Tôi có cảm giác như trên Mặt Đất này không có gì mong manh hơn. Nhờ ánh sáng trăng, tôi nhìn thấy vầng trán nhợt nhạt ấy, đôi mắt nhắm nghiền các lẵng tóc run rẩy trước gió, và tôi nghĩ thầm: "Cái mà ta nhìn thấy đây chỉ là cái vỏ. Cái quan trọng nhất thì không nhìn thấy được..."', '//cdn.hstatic.net/products/200000979221/-5b46a794d64c4996a6695f6e9e8d3213-4971eb5e-0c97-4088-8bb7-16f2151a22d6_7f9108fee1e24581ac0f881286af9da0_medium.jpg', 'HOÀNG TỬ BÉ - Antoine de Saint-Exupéry', 6, 136000, 'Còn hàng', '2026-01-01', 'Antoine de Saint-Exupéry', 'Nguyễn Thành Long', 'NXB Kim Đồng', 'NXB Kim Đồng', 340, 'Bìa mềm', 160, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(40, 'Sách sắp phát hành

 

Samantha Harvey đưa ta theo chân sáu phi hành gia sống trên trạm vũ trụ bay quanh Quỹ đạo. Cùng với họ, ta khám phá những trải nghiệm hết sức lạ lùng: lơ lửng trong môi trường không trọng lực, ăn triền miên những thực phẩm khô, đi bộ ngoài vũ trụ, chứng kiến bình minh và hoàng hôn cử nối tiếp nhau vụt qua trước mắt, lặng nhìn đất mẹ hùng vĩ mênh mông từ một độ cao khôn tả. 

Thế nhưng, giữa cuộc sống tột cùng lạ lùng và phi thường ấy, ta lại tìm thấy những cảm xúc và suy tư quen thuộc: nỗi đau xót chia lìa, những chia rẽ ý thức hệ, nỗi cô đơn tột cùng, khao khát được sẻ chia, hay tình yêu tha thiết với hành tinh này. Cuộc sống mà Quỹ đạo khắc họa vừa hết sức xa xôi choáng ngợp, vừa vô cùng gần gũi xúc động; nó chứa đựng cả cái trác tuyệt lẫn cái nhỏ nhặt mong manh của đời người.

 

Không đứng trọn trong một thể loại nào, Quỹ đạo kết nối văn học, khoa học và triết học trong cùng một chuyển động. Tất cả được dệt nên bằng một thứ văn xuôi đậm chất thơ, tạo nên một tác phẩm văn chương lặng lẽ lấp lánh.', '//cdn.hstatic.net/products/200000979221/8935235248045_c270d1586d6f4b7c9583e34cc20ac007_medium.jpg', 'Quỹ Đạo - Samantha Harvey', 6, 116000, 'Còn hàng', '2026-01-01', 'Samantha Harvey', 'Khánh Nguyên', 'NXB Văn Học', 'Nhã Nam', 224, 'Bìa mềm', 300, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(44, '“Khi loài vật lên ngôi” của Karel Čapek là một tác phẩm văn chương mang đầy tính tiên tri pha lẫn hài hước, châm biếm và phản biện xã hội cực kỳ sâu sắc; từ khoa học, nghệ thuật, giáo dục, kinh doanh, chính trị, chủ nghĩa phát xít, chủ nghĩa nô lệ, chủ nghĩa quân phiệt, pháp luật, tôn giáo, triết học, sự phân biệt chủng tộc, quyền lực báo chí, và mọi đặc điểm của bản chất con người mà ta có thể nghĩ đến, không gì thuộc về con người mà xa lạ với Karel Čapek!

Khi Karl Marx giải thích sự biến đổi xã hội, giải thích về sự phân chia gia cấp và để xây dựng một lý thuyết về lịch sử phát triển xã hội ông đã đưa ra 3 câu hỏi: - Tại sao xã hội lại biến đổi? - Xã hội biến đổi như thế nào? - Tương lai xã hội sẽ ra sao? Karel Čapek đã trả lời một cách sắc bén và đầy đủ những câu hỏi ấy.Không những thế ông còn viết lại được cả lịch sử tiến trình của văn minh và đưa ra được cả một dự báo mang tính tiên tri cho cả nhân loại. Như Milan Kundera từng nói “Khi loài vật lên ngôi sẽ không bao giờ rơi vào quên lãng… Čapek có lẽ là nhà văn châu Âu đầu tiên có những tác phẩm hình dung trước được viễn cảnh khủng khiếp của thế giới toàn trị.”

“Khi loài vật lên ngôi” còn là cảm hứng cho vô số tác phẩm lừng danh được xuất bản sau này, có thể liệt kê ra như: 1984 hay Animal farm của George Orwell; hay The Sirens of Titan, Harrison Bergeron của Kurt Vonnegut… và ngay cả ý tưởng Sinh sản đơn tính của khủng long trong Jurassic Park…

Ngoài ra, “Khi loài vật lên ngôi” là trường hợp tiên phong và độc đáo nhất trong tiểu thuyết về cả FORM và STYLE. Čapek đã đi trước thời đại trong việc sử dụng yếu tố thị giác để tạo thêm những tầng lớp ý nghĩa khác cho văn bản. Čapek là họa sĩ trước khi thành nhà văn kiêm nhà báo, và kỹ thuật đồ họa báo chí được Čapek khai thác triệt để trong “Khi loài vật lên ngôi” để tạo thành một hình thức anti-novel đi trước thời đại. Bản dịch Tiếng Việt đã được Tao Đàn trình bày theo đúng tinh thần trình diễn thị giác, tạo bất ngờ rất lớn cho người đọc. ', '//cdn.hstatic.net/products/200000979221/fdgfxg_415312c2a31447e6b2ffa6484ff4e385_medium.jpg', 'Khi loài vật lên ngôi', 22, 153000, 'Còn hàng', '2025-01-01', 'Karel Capek', 'Đăng Thư', 'NXB Hội Nhà Văn', 'Tao Đàn', 360, 'Bìa mềm', 540, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(24, '1. Hồ Thích Thiền học Án

2. Thiền đạo tu tập

Hồ Thích Thiền học Án

 1. Học thuật của Bác sĩ Hồ Thích thông quán Trung Tây. Sách Thần Hội Hòa Thượng Di Tập của ông khiến cả thế giới chú ý đến tư tưởng Thiền học Trung Quốc, lại càng khiến các học giả Nhật Bản đạt đến cao trào đối với nghiên cứu về vấn đề này. 

2. Học thuật giới Nhật Bản trọng thị học vấn của Bác sĩ Hồ Thích cũng như quan tâm đến phương pháp và thái độ nghiên cứu của ông. Thuở sinh tiền Bác sĩ Hồ Thích có ba người bạn văn hóa là ba giáo sư Nhật Bản lừng danh: Một vị đã khứ thế là Suzuki Daisetz Tiên sinh đã từng cùng Bác sĩ Hồ Thích triển khai luận chiến liên hệ đến sơ kỳ Thiền Tông sử Trung Quốc. Còn hai vị tiên sinh kia là Iriya Yoshitaka và Yanagida Seizan, đều đã từng cùng Bác sĩ Hồ Thích trao đổi thư tín đối luận về Thiền học.

3. Yanagida Seizan Tiên sinh là đương đại quyền uy của Phật Học Nhật Bản. Ông thức tỉnh người đời, nhấn mạnh sự thành tựu về nghiên cứu sơ kỳ Thiền Tông sử của Bác sĩ Hồ Thích cũng như nhận thức rằng Bác sĩ Hồ Thích vào cuối đời vùi đầu vào việc nghiên cứu Thiền sử, cho nên chưa hoàn thành chuẩn bị chấp bút quyển hạ của sách Trung Quốc Triết học Sử Đại cương. Nãi Dương nhớ lại cách nhìn này, cho nên xin phép đem các luận trước Thiền học của Bác sĩ Hồ Thích, xếp đặt có hệ thống cũng như chỉnh lý, thu thành một thiên, lấy tựa đề là Hồ Thích Thiền học Án. Hồ Thích Kỷ niệm Quán của Trung ương Nghiên cứu Viện nghe được tin này, vui lòng trợ giúp.

4. Thiết kế sách Hồ Thích Thiền học Án chỉ nhằm tiện lợi nghiên cứu đủ để đại biểu vị tri thức nhân đa dạng này của Trung Quốc cận đại học vấn. Bác sĩ Hồ Thích từng nói: “Muốn thu hoạch gì, thì phải vun trồng thế nào”. Nãi Dương vừa biên tập vừa học hỏi, cũng như công tác của người làm vườn, mong các hiền giả trong cũng như ngoài nước không hẹp lượng chỉ giáo!

5. Yanagida Seizan Tiên Sinh chủ biên sách này, đặc biệt tuyển chọn thiên “Bác sĩ Hồ Thích và nghiên cứu sơ kỳ Thiền Tông Sử Trung Quốc” làm giải đề thông quán. Iriya Yoshitaka Tiên sinh nhiệt tâm duyệt lại, còn viết thêm một thiên “Nhớ Hồ Thích Tiên sinh”, khiến người ta cảm động. Ngoài ra, còn nhờ Mao Tử Thủy Tiên sinh đai biểu trước tác quyền của Bác sĩ Hồ Thích, đồng ý dẫn dụng di trước của Bác sĩ. Đài Loan Chính Trung Thư Cục từ khởi nguyên hợp tác với Nhật Bản Trung Văn Xuất Bản Xã trong việc san hành. Chỉ việc này thôi cũng xin hết sức thâm tạ!

Nguyện đem sách này kính dâng hương linh Bác sĩ Hồ Thích trên trời! 

Lý Nãi Dương cẩn chí.
3/1/1975 tại Kinh Đô

 

Mục lục
HỒ THÍCH THIỀN HỌC ÁN 
I. Bồ-đề-đạt-ma khảo (Một chương của Trung Quốc Trung cổ Triết học Sử) 
ĐÀN KINH KHẢO 
II. Đàn Kinh Khảo (1) (Bạt Tào Khê Đại sư Biệt truyện) 
III. Đàn Kinh khảo (2) (Ghi về Lục Tổ Đàn Kinh bản Bắc Tống) 
THIỀN TÔNG THẾ HỆ THỜI ĐẠI BẠCH CƯ DỊ 
IV. Thiền tông Thế hệ Thời đại Bạch Cư Dị 
V. Hà Trạch Đại sư Thần Hội truyện 
LĂNG-GIÀ SƯ TƯ KÝ TỰ 
VI. Lăng-già Sư tư ký Tự	
VII. Lăng-già tông khảo 
PHỤ LỤC 
I. Từ các bản dịch nghiên cứu Thiền pháp Phật giáo 
II. Thiền học Cổ sử khảo 
III. Luận về Cương lĩnh của Thiền tông Sử	
IV. Hải ngoại Độc thư Tạp ký 
 

Thiền đạo tu tập

Những người Tây phương nhiệt thành nghiên cứu Thiền thường thấy rằng, sau khi cái quyến rũ ban đầu đã mòn mỏi, những bước tiếp tục cần thiết để theo đuổi nó một cách đứng đắn trở thành chán nản và vô hiệu quả. Cái kinh nghiệm Ngộ thì tuyệt diệu thật, nhưng vấn đề chủ yếu là, làm thế nào để thể nhập vào kinh nghiệm ấy? Vấn đề nắm bắt “nàng phù thủy Thiền” khiêu khích này đối với đa số những người hâm mộ Thiền ở Tây phương vẫn chưa được giải quyết.


Ấy là bởi vì việc nghiên cứu Thiền ở Tây phương vẫn còn trong giai đoạn vỡ lòng, và các người học vẫn còn lẩn quẩn trong cái vùng mơ hồ giữa việc “quan tâm đến” và “hiểu” Thiền. Đa số họ chưa đạt đến mức chín chắn trong việc nghiên cứu để họ có thể thực sự tu tập Thiền, chứng đắc Thiền, và biến Thiền thành cái sở hữu thâm sâu nhất của họ.
 
Bởi vì Thiền, tự bản tính và ở các mức độ cao, không phải là một triết học, mà là một kinh nghiệm trực tiếp mà người ta phải thâm nhập bằng cả con người mình, mục tiêu đầu tiên phải là nhằm để đạt đến và thể hiện kinh nghiệm Thiền. Để thể hiện cái kinh nghiệm tối thượng này, hay là Ngộ, ta cần phải hoặc là thâm tín một Thiền sư đã đắc pháp, hoặc là tiếp tục phấn đấu một mình bằng cách nghiên cứu và tu tập thực sự.

Với hy vọng tăng tiến một kiến thức về Thiền và giúp cho những người vẫn hằng tìm kiếm chỉ nam thực tập được dễ dàng hơn, tôi tuyển chọn, dịch, và trình bày ở đây một số tự truyện và pháp ngữ ngăn ngắn của các Thiền sư vĩ đại, từ các tài liệu cổ xưa lẫn cận đại, mà mặc dù rất phổ thông bên Đông phương, bên Tây phương lại không được biết đến lắm. Từ nội dung của những tài liệu này, ta có thể có được một hình ảnh về đời sống và hành trạng của các Thiền sư, nhờ thế hiểu rõ hơn Thiền đã được thực sự tu tập như thế nào. Vì không ai đủ tư cách hơn những Thiền sư đã đắc pháp này để đối trị với vấn đề tu tập Thiền. Do đó, theo gương và chỉ thị của họ là con đường đúng và an toàn nhất để tu tập Thiền. Chính vì lý do này mà tôi giới thiệu các pháp ngữ của bốn Thiền sư Trung Hoa lẫy lừng là Hư Vân, Tông Cảo, Bác Sơn và Hám Sơn.

Ngoài những đề nghị và phê bình của riêng tôi về việc tu tập Thiền, mà độc giả có thể thấy ở phần đầu Chương II, tôi cũng đưa ra một cái nhìn khái quát về các phương diện cốt yếu của Thiền ngay ở phần đầu sách. Hy vọng rằng sau khi đọc chương đầu, độc giả có thể có được một khái quát sâu xa hơn về Thiền, nhờ thế có thể theo đuổi việc nghiên cứu của mình dễ dàng hơn trước nhiều. Tuy nhiên, người mới đến với Phật giáo có thể gặp phải đôi khó khăn. Mặc dù tổng quát thì sách này có tính cách nhập môn, nhưng có lẽ về một số vấn đề và trên các phương diện nào đó của việc nghiên cứu Thiền, nó chuyên biệt hơn một số sách khác hiện có bằng Anh ngữ.

Chương III, “Bốn nan đề của Thiền”, vốn là một tiểu luận về “bản chất của Thiền” đăng trong tờ Philosophy East and West, số tháng giêng 1957, do Đại học Hawaii xuất bản. Với vài thay đổi nhỏ, bài đó bây giờ được cho vào sách này. Tôi tin rằng bốn vấn đề bàn luận trong đó rất là quan trọng cho việc nghiên cứu Thiền.

Chương IV, “Phật và Thiền định”, vốn được viết dưới hình thức một giảng thoại, đọc trong một cuộc hội thảo tại Đại học Columbia, vào 1954, theo lời mời của Tiến sĩ Jean Mahler. Bài đưa ra một số giáo lý căn bản của Phật giáo và vài nguyên tắc cốt yếu làm căn bản cho việc tu tập Thiền định mà có lẽ chưa được giới thiệu đầy đủ cho Tây phương.

Vì nhiều thành ngữ và từ ngữ Thiền quá khó nếu không nói là không tài nào dịch được, mặc dù một số học giả cho là hoàn toàn bất khả diễn dịch, tôi đã phải, trong một vài thí dụ, dùng đến lối dịch thoát. Một số chữ Nhật như “koan” tức là Công án, “Satori” tức là Ngộ, “Zen” tức là Thiền... hiện giờ đã được ổn định và thông dụng bên Tây phương, và chúng cũng được dùng trong sách này, cùng với nguyên ngữ Trung Hoa. Phương pháp La Mã hóa những chữ Hán sử dụng trong sách được dựa theo hệ thống Wade-Giles. Tôi cũng bỏ tất cả các dấu của chữ Hán và Sanskrit trong bản văn vì chúng chỉ tổ làm các độc giả thông thường bối rối và không cần thiết đối với các học giả Hoa ngữ và Sanskrit, vì họ sẽ nhận ra được ngay nguyên ngữ Trung Hoa và chữ Devanagiri.

Tôi xin được thâm tạ ông George Currier, cô Gwendolyn Winsor, bà Dorothy Donath và tiện nội, Hsiang Hsiang, tất cả đã trợ giúp tôi rất nhiều trong việc viết tiếng Anh, chuẩn bị, in và đánh máy bản thảo và đã đưa ra những đề nghị và phê bình rất có giá trị về tác phẩm này. Tôi cũng xin cảm tạ người bạn cũ, ông P. J. Gruber, đã luôn luôn trợ giúp và khuyến khích.

Là một người Trung Hoa tị nạn, tôi cũng xin cảm tạ tất cả các bằng hữu Hoa Kỳ của tôi và cả hai Cơ sở Bollingen và Cơ sở Nghiên cứu Á Đông đã rộng lượng giúp tôi cơ hội tiếp tục công việc và nghiên cứu đạo Phật ở Mỹ quốc đây. Tôi thật mang ơn họ vô cùng.

New York City, tháng 3, 1959
Chang Chen-Chi

 

Mục lục
TỰA CỦA DỊCH GIẢ
LỜI TỰA CỦA TÁC GIẢ

CHƯƠNG I: BẢN CHẤT CỦA THIỀN
PHONG CÁCH THIỀN VÀ NGHỆ THUẬT THIỀN
CỐT TỦY CỦA THIỀN: KHẢO SÁT BA PHƯƠNG DIỆN CHÍNH YẾU CỦA TÂM
BỐN ĐIỂM CỐT YẾU TRONG PHẬT GIÁO THIỀN TÔNG

CHƯƠNG II: THIỀN ĐẠO TU TẬP
KHÁI QUÁT VỀ SỰ TU TẬP THIỀN
TU TẬP THIỀN BẰNG CÁCH QUÁN TÂM TRONG TĨNH LẶNG
TU THIỀN BẰNG CÁCH THAM CÔNG ÁN
PHÁP NGỮ CỦA BỐN THIỀN SƯ
TỰ TRUYỆN CỦA NĂM THIỀN SƯ

CHƯƠNG III: BỐN NAN ĐỀ CỦA THIỀN
THIỀN VÀ PHẬT GIÁO ĐẠI THỪA
“TỨ LIỆU GIẢN” CỦA LÂM TẾ

CHƯƠNG IV: PHẬT VÀ THIỀN ĐỊNH
BA PHƯƠNG DIỆN CỦA PHẬT SO VỚI SÁU PHƯƠNG THỨC TƯ TƯỞNG CỦA CHÚNG SINH', '//product.hstatic.net/200000979221/product/z6363351563088_776878cb2c22093168711b0430af7347_70847833f2c54e92b4ec85a9a3c7af46_medium.jpg', 'Combo Thiền Học và Tu Tập - 2 cuốn, giá sốc chỉ 108k!', 2, 108000, 'Còn hàng', NULL, 'Chang Chen-Chi, Hồ Thích', 'Như Hạnh', 'Khai Tâm', NULL, 617, 'Bìa mềm', 700, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(26, '  Cô gái trẻ Jean Muir đến làm gia sư tại gia đình Coventry giàu có và nhanh chóng được lòng hầu hết tất cả mọi người trong dinh thự, trừ cậu con trai cả và cô chị họ, những người ngay từ đầu đã không tin tưởng cô. Họ linh cảm rằng cô gái trẻ e lệ này hoàn toàn không phải là người mà cô thể hiện ra bên ngoài.

        Bất chấp những nghi hoặc từ các thành viên trong gia đình, nữ diễn viên ấy vẫn xuất sắc hoàn thành vai diễn của mình cho đến phút cuối.

         Hãy cùng khám phá tác phẩm kinh điển thời kì đầu của Louisa May Alcott để vén tấm màn che giấu sự thật đằng sau lớp mặt nạ của nàng Jean Muir.

 

---

 

SAU LỚP MẶT NẠ ban đầu xuất bản dưới bút danh A. M. Barnard trên tờ báo The Flag of Our Union vào năm 1866, và không bao giờ được công khai gắn liền với tên tuổi của Louisa May Alcott trong suốt cuộc đời khi bà còn sống.

Cuốn tiểu thuyết gần như đã bị lãng quên cho đến khi được tái bản vào năm 1975, trở thành một tác phẩm quan trọng trong việc nhìn nhận lại giá trị văn chương và di sản sáng tác của Alcott.

 

---

 

“Jean Muir là một trong những nhân vật được yêu thích nhất trong mạch sáng tác văn học gothic của Alcott. Nàng ta có thể tỏ ra yếu đuối, đáng thương trong khoảnh khắc này, nhưng ngay lập tức trở nên sắc bén, cay nghiệt ở khoảnh khắc kế tiếp.”

 

- LORRAINE TOSIELLO -', '//cdn.hstatic.net/products/200000979221/657509978_1407907328018216_1091188246423011990_n_68e5e98e56064c15b7c02751b537aa87_medium.jpg', 'Sau Lớp Mặt Nạ - Truyện Nàng Jean Muir - Louisa May Alcott', 6, 51000, 'Còn hàng', '2026-01-01', 'Louisa May Alcott', 'Hán Nhật Minh', 'NXB Kim Đồng', 'NXB Kim Đồng', 176, 'Bìa mềm', 260, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(20, 'Hãy cùng gặp nhà Ngẫn, gia đình ngẩn ngơ nhất trong lịch sử ngẩn ngơ của xứ ngẩn ngơ. Họ sống trong một biệt thự đồng quê xập xệ có tên là Dinh Ngẫn. Nơi này đã là cơ ngơi của gia tộc suốt hàng trăm năm, tọa lạc giữa miền quê nước Anh. Tranh treo ngược, giấy dán tường bong, cửa sổ nứt, nhưng chẳng có gì phải xoắn. Với gia đình này, Dinh Ngẫn là nhà.

Và khi nhà sắp rơi vào tay ngân hàng để biến thành trại cải tạo, nhà Ngẫn sao có thể ngồi yên! Là như thế, khởi đầu của đủ trò rối loạn dở khóc dở cười từ gia đình quý tộc ngớ ngẩn đến bực mình (nhưng đôi lúc cũng đáng yêu) này. Bạn đã sẵn sàng để bị cuốn vào chưa?', '//cdn.hstatic.net/products/200000979221/bia-sach-web-38_9c31e15ef2004a728cfa7a652c0545f5_medium.jpg', 'Chuyện nhà Ngẫn - David Walliams', 6, 164000, 'Còn hàng', '2026-01-01', 'David Walliams', 'Trà Dương', 'NXB Hội Nhà Văn', 'Nhã Nam', 388, 'Bìa mềm', 450, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(46, 'Anh Em Nhà Karamazov

Cuỗm được khối tài sản lớn từ người vợ đầu Adelaida Ivanovna xuất thân quý tộc giàu có, đày đọa vợ thứ hai Sofya Ivanovna nhu mì, khiến nàng hóa điên mà chết, thậm chí cưỡng bức cô gái ngây dại ngoài phố sinh ra đứa con hoang quái dị Smerdyakov, Fyodor Karamazov ma mãnh và tàn nhẫn sau khi góa cả hai vợ cũng tống khứ nốt, không nuôi nấng đứa con nào, sống đây đó sa đọa với đám đàn bà mạt hạng. Ở tuổi xế chiều, lão già ấy mới trở về điền địa của mình. Nơi đây, nhà Karamazov đoàn tụ. Nhưng chỉ là để đẩy tấn bi kịch của những tâm hồn bị hành hạ lên tột cùng bi thảm…

Dos đã viết Anh em nhà Karamazov trong các năm 1878-1880, khi ngọn đèn sinh mệnh dần lụi tắt, nhưng kỳ lạ thay, cuốn tiểu thuyết khốc liệt đó được đánh giá là kiệt tác lớn nhất của ông, đặt ông lên đỉnh cao nhất của tài năng, trở thành đại văn hào không thể vượt qua ở mọi thời đại.

“Muốn viết cho hay thì phải đau khổ, đau khổ. – F. Dostoyevsky

Dos đã cho tôi nhiều hơn bất cứ nhà tư tưởng nào của nhân loại. – A. Einstein

"Anh em nhà Karamazov là cuốn tiểu thuyết vĩ đại nhất từng được viết nên.” – Sigmund Freud

“Một con người đơn độc mà viết nổi Anh em nhà Karamazov thì đó là phép mầu.” – Hermann Hesse (Nobel Văn chương 1946)

 
Thông tin tác giả
 
Fyodor Dostoevsky

Tên đầy đủ là Fyodor Mikhailovich Dostoevsky (1821 – 1881) là nhà văn, nhà tư tưởng, triết gia, nhà báo Nga, thành viên Viện Hàn lâm Khoa học Petersburg từ năm 1877. Cùng với Lev Tolstoy, ông được xem là một trong hai nhà văn Nga vĩ đại thế kỷ XIX.

Dostoyevsky viết văn từ năm 20 tuổi, nổi tiếng nhất với chuỗi tiểu thuyết viết trong 15 năm cuối đời “đưa nhân loại trưởng thành lên một bước”: Tội ác và hình phạt, Chàng ngốc, Lũ người quỷ ám, Đầu xanh tuổi trẻ, Anh em nhà Karamazov. Ông được đánh giá đúng tầm vóc chỉ sau khi đã qua đời, được xem là người sáng lập hay dự báo chủ nghĩa hiện sinh thế kỷ 20.

Nhiều bộ óc thiên tài của thế giới như đại văn hào Nga L. Tolstoy, F. Nietszche, S. Freud, hay A. Einstein… đều đọc Dostoyevsky và nghiêng mình trước tài năng của ông. Nhiều tác phẩm của Dostoevsky được dựng phim, kịch, nhạc kịch cả ở Nga lẫn nước ngoài.

Macxim Gorki nhận xét Dostoevsky là “nhà văn thiên tài, biết phân tích những bệnh trạng của xã hội thời ông” và “là một thiên tài không thể phủ nhận được; với sức biểu hiện như vậy, chỉ có Shakespeare mới có thể đặt ngang hàng được”.', '//cdn.hstatic.net/products/200000979221/anh-em-nha-karamazov_2ac2956a42a045c78e180c77d9447322_master_4bca9cff46144d50ba52818177181267_medium.png', 'ANH EM NHÀ KARAMAZOV – Fyodor Dostoyevsky', 6, 39000, 'Còn hàng', '2026-01-01', 'Fyodor Dostoevsky', 'Phạm Mạnh Hùng', 'NXB Hà Nội', 'Nhã Nam', 848, 'Bìa mềm', 1270, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(32, 'The Secret Adversary – Kẻ thù giấu mặt là tác phẩm thứ hai của Agatha Christie (cuốn sách đầu tay của bà là Bí ẩn thảm án ở Styles). Đây cũng là tác phẩm đầu tiên giới thiệu hai thám tử Tommy và Tuppence - những nhân vật sẽ còn xuất hiện trong ba cuốn sách và một tuyển tập truyện ngắn được viết trong suốt sự nghiệp văn chương của bà.


Truyện kể về Tommy Beresford and Tuppence Cowley, hai thanh niên bị rơi vào cảnh túng quẫn sau thế chiến thứ nhất. Không thể kiếm được việc làm, họ quyết định hợp tác, quảng cáo về mình là "những nhà phiêu lưu trẻ tuổi, sẵn sàng làm bất cứ việc gì ". Họ có được việc làm đầu tiên, tuy nhiên đó lại là một phi vụ cực kỳ nguy hiểm. Đôi bạn phải vận dụng mọi khả năng để giữ lấy mạng sống, đồng thời giải cứu nhân vật Jane Finn bí ẩn và phá vỡ một âm mưu có thể gây ra cuộc khủng hoảng lớn trên thế giới.


Xuất bản năm 1922, tiểu thuyết này đã nhiều lần được chuyển thể thành phim điện ảnh và truyền hình, cùng hai phiên bản truyện tranh. Các nhà phê bình đã dành cho Kẻ thù giấu mặt nhiều lời khen ngợi nồng nhiệt, về “sự khéo léo và thông minh đáng kinh ngạc của tác phẩm”.', '//cdn.hstatic.net/products/200000979221/nxbtre_full_06222026_102216_36ae216c98bc4efabbe58e88af601d9a_medium.jpg', 'Kẻ Thù Giấu Mặt - Agatha Christie', 6, 116000, 'Còn hàng', '2026-01-01', 'Agatha Christie', 'Dịch Quán Trung', 'NXB Trẻ', 'NXB Trẻ', 356, 'Bìa mềm', 450, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(29, 'Xa rời đám đông điên loạn – Kiệt tác văn học Anh về tình yêu và số phận

 

 

Xa rời đám đông điên loạn là một trong những tiểu thuyết tiêu biểu của nhà văn Anh Thomas Hardy, ghi dấu ấn sâu đậm trong dòng chảy văn học thế kỷ XIX. Không ồn ào kịch tính, không phô trương cao trào, tác phẩm chinh phục độc giả bằng nhịp kể chậm rãi, giàu suy tư và vẻ đẹp trầm buồn thấm dần qua từng trang sách.

 

Đây không chỉ là câu chuyện tình yêu, mà còn là bản chiêm nghiệm sâu sắc về tự do cá nhân, lựa chọn và cái giá của trưởng thành.

 

 

Bathsheba Everdene – Hình tượng người phụ nữ vừa mạnh mẽ vừa mong manh

 

Trung tâm của tiểu thuyết là Bathsheba Everdene – một cô gái trẻ thừa hưởng trang trại lớn và tự mình điều hành công việc giữa xã hội nông thôn bảo thủ. Bathsheba đại diện cho khát vọng tự do và tinh thần độc lập hiếm hoi của phụ nữ đương thời.

 

Tuy nhiên, chính cá tính kiêu hãnh và những phút bốc đồng đã đẩy cô vào chuỗi biến cố đau đớn. Thomas Hardy không xây dựng nhân vật theo khuôn mẫu lý tưởng, mà khắc họa Bathsheba với đầy đủ ánh sáng và bóng tối: đáng yêu, đáng nể nhưng cũng dễ lạc lối. Sự phức tạp ấy khiến nhân vật trở nên sống động và chân thực.

 

 

Ba người đàn ông – Ba sắc thái của tình yêu

 

Xoay quanh Bathsheba là ba người đàn ông, đại diện cho ba kiểu tình yêu và ba con đường số phận:

- Gabriel Oak – trầm lặng, kiên nhẫn, yêu bằng sự bền bỉ và hy sinh thầm lặng

- William Boldwood – mang tình yêu ám ảnh, nơi khát vọng chiếm hữu dần biến thành bi kịch

- Frank Troy – hào nhoáng, lãng mạn, đại diện cho đam mê rực rỡ nhưng chóng tàn

 

Qua những mối quan hệ ấy, tác phẩm đặt ra câu hỏi sâu sắc: Con người nên chọn sự an toàn của lòng trung thành hay chấp nhận rủi ro của đam mê? Tình yêu là nơi trú ẩn bình yên hay là phép thử khắc nghiệt của số phận?

 

 

Thiên nhiên và đời sống nông thôn – Linh hồn của tác phẩm

 

Trong Xa rời đám đông điên loạn, thiên nhiên không chỉ là bối cảnh mà là một phần linh hồn của câu chuyện. Những cánh đồng trải dài, mùa gặt, cơn bão, nhịp lao động… được miêu tả vừa chân thực vừa thơ mộng.

 

Thiên nhiên hiện diện như một sức mạnh thầm lặng, nhắc nhở con người về sự nhỏ bé của mình trước quy luật nghiệt ngã của đời sống. Hạnh phúc và khổ đau diễn ra lặng lẽ, không phô trương nhưng bền bỉ và ám ảnh.

 

 

Triết lý về tự do và cái giá của lựa chọn

 

Ở tầng sâu tư tưởng, tiểu thuyết là lời suy ngẫm về tự do cá nhân và hệ quả của mỗi quyết định. Thomas Hardy không phán xét nhân vật; ông để họ tự bước đi, tự vấp ngã và tự gánh chịu hậu quả.

 

Những sai lầm trong truyện không xuất phát từ sự xấu xa, mà từ sự non nớt, cô đơn và khát khao được yêu thương – những cảm xúc rất người. Chính điều đó tạo nên tinh thần nhân đạo thầm lặng xuyên suốt tác phẩm.

 

Đặc biệt, hình ảnh Gabriel Oak hiện lên như một điểm tựa đạo đức lặng lẽ. Ở Gabriel, tình yêu không phải là chiếm hữu hay bốc đồng, mà là khả năng ở lại, chờ đợi và nâng đỡ người khác ngay cả khi bản thân chịu thiệt thòi. Đây là kiểu nhân vật để lại dư âm lâu dài trong lòng người đọc.

 

 

Văn phong cổ điển – Trải nghiệm đọc lắng sâu

 

Văn phong của Thomas Hardy mang đậm hơi thở cổ điển: chậm rãi, kỹ lưỡng, giàu miêu tả và chiêm nghiệm. Với độc giả hiện đại, nhịp điệu ấy đòi hỏi sự kiên nhẫn, nhưng đổi lại là trải nghiệm đọc sâu lắng, nơi mỗi chi tiết đều góp phần tạo nên dư âm bền lâu.

 

Xa rời đám đông điên loạn không phải cuốn sách để đọc vội. Đây là tác phẩm để sống cùng, để suy ngẫm và để trở lại nhiều lần.

 

 

Vì sao nên đọc Xa rời đám đông điên loạn?

 

- Khám phá một kiệt tác văn học Anh thế kỷ XIX

- Chiêm nghiệm về tình yêu, tự do và trách nhiệm cá nhân

- Cảm nhận vẻ đẹp trầm lắng của đời sống nông thôn Anh

- Trải nghiệm văn phong cổ điển giàu chiều sâu nhân văn

 

Khép lại Xa rời đám đông điên loạn, người đọc không chỉ nhớ về một câu chuyện tình yêu, mà còn mang theo cảm giác bâng khuâng về kiếp người: mong manh, lạc lối nhưng luôn tìm kiếm ý nghĩa và bình yên.

 

Đây là tác phẩm xứng đáng để đọc chậm, đọc kỹ và để lại trong lòng những rung động dài lâu.', '//cdn.hstatic.net/products/200000979221/8935210314451_2924b165abc0406e8be76b3a683ad531_medium.png', 'Xa Rời Đám Đông Điên Loạn - Thomas Hardy', 6, 159000, 'Còn hàng', '2026-01-01', 'Thomas Hardy', 'Hàn Băng Vũ', 'NXB Văn Học', 'Tân Việt', 603, 'Bìa mềm', 700,1000,1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(30, '“Ai cũng biết tôi, nhưng chẳng ai thấy được tôi. Tôi là thứ mà người ta gọi là Tình Yêu.”

 

Tại một thị trấn nhỏ miền Nam nước Pháp vào những năm 1960, một cuộc gặp gỡ rực rỡ với chính Tình Yêu đã làm thay đổi cuộc đời của Marie-Jeanne, một cô bé mồ côi từ khi cất tiếng khóc chào đời.

 

Khi còn nhỏ, Marie-Jeanne phát hiện ra mình có khả năng nhìn thấy những dấu vết mà Tình Yêu để lại trên người khác - những vầng sáng nhỏ lấp lánh trên khuôn mặt và đôi tay, càng rực rỡ hơn khi người được định sẵn dành cho họ ở gần. Không bao lâu sau, Marie-Jeanne trở thành một bà mối tí hon, kết nối những cặp đôi đích thực trong ngôi làng của mình.

 

Lớn lên, Marie-Jeanne cùng cha nuôi Francis bắt đầu hành trình với thư viện lưu động, rong ruổi qua những thị trấn nhỏ nằm rải rác trong vùng núi Nyons. Ở bất cứ nơi nào họ đặt chân đến, cô lại tiếp tục se duyên cho những tâm hồn đồng điệu – và luôn có một cuốn sách đóng vai trò then chốt trong hành trình đó. Tuy nhiên, người duy nhất mà Marie-Jeanne không thể tìm thấy tri kỷ lại chính là bản thân cô. Trên người cô không hề có vầng sáng nào, dù cô đã mòn mỏi chờ đợi nó xuất hiện. Chẳng phải ai cũng có một nửa của riêng mình sao? Liệu Marie-Jeanne có thể nhận ra người ấy khi Tình Yêu cuối cùng cũng tìm đến với cô không?

 

 

 

Về tác giả:

 

Nina George là một nhà văn và nhà báo người Đức, nổi tiếng với những tiểu thuyết mang màu sắc nhẹ nhàng, giàu cảm xúc, xoay quanh sách, tình yêu, và hành trình chữa lành.

Bà sinh năm 1973, viết nhiều thể loại từ báo chí, truyện ngắn đến tiểu thuyết. Tuy nhiên, tác phẩm giúp bà được biết đến rộng rãi trên thế giới là cuốn The Little Paris Bookshop (Hiệu sách nhỏ ở Paris).

Văn phong của Nina George thường rất dịu dàng, lãng mạn, pha chút triết lý. Bà hay viết về sức mạnh của sách và việc đọc như một cách chữa lành tâm hồn. Nhân vật trong các tác phẩm của bà thường là những người đang bị tổn thương và muốn đi tìm lại chính bản thân mình.

 

 

Tác phẩm tiêu biểu:

- The Little Paris Bookshop

- The Little French Bistro

- The Book of Dreams

Ngoài ra, bà còn là một người hoạt động tích cực trong lĩnh vực văn chương, từng tham gia vận động cho quyền lợi của nhà văn tại Đức và châu Âu.

 

 

Thông tin về tác phẩm:

 

- Bối cảnh thị trấn Nyons (miền Nam nước Pháp) - một không gian văn chương giàu ký ức, nơi đời sống con người gắn chặt với sách, lịch sử và các thế hệ nối tiếp.

- Trung tâm câu chuyện là Marie-Jeanne - cô gái có khả năng cảm nhận “ánh sáng phương Nam”, đại diện cho trực giác về sự kết nối và thấu hiểu con người.

- Xây dựng một concept độc đáo: mai mối bằng sách và thư tay, biến việc đọc thành hành vi kết nối cảm xúc và định mệnh giữa người với người.

- Khai thác sâu chủ đề tình yêu - định mệnh - bỏ lỡ, với những mối quan hệ không hoàn hảo, mang tính bất định và rất gần với đời thực.

- Xung đột tinh tế: người kết nối lại là người đứng ngoài kết nối, tạo nên chiều sâu tâm lý và dư vị cô đơn rất đặc trưng.

- Tác phẩm mở rộng từ câu chuyện cá nhân thành bức tranh cộng đồng, nơi sách trở thành nền tảng cho đối thoại, ký ức và sự gắn kết xã hội.

 

 

 

Trích dẫn hay trong truyện:

 

- Các người thấy đấy, trái tim ban đầu giống như cốc gốm được sơn phủ hoàn hảo đầy xinh đẹp, nhưng năm tháng qua đi khiến chúng nứt ra và sứt mẻ. Trái tim tan vỡ một, hai lần, rồi cứ thế tiếp diễn hết lần này đến lần khác. Mỗi lần như vậy, con người ta lại cố hết sức gắn chúng lại, cố sống với vết thương, chắp vá chúng bằng hy vọng và nước mắt. Ta thật ngưỡng mộ các người vì đã không từ bỏ ta.

- Ta lang thang giữa những cậu trai và cô gái khi ánh sao lóe lên như mưa trút xuống St. Lawrence. Không khí buổi đêm ấm áp mơn trớn trên mặt, trên những đôi tay và đôi chân trần, đẫm mùi cỏ xạ hương, hoa hồng, oải hương, cây xô thơm và bạc hà. Bọn họ cảm giác được bản thân đang tiến vào một cõi ngọt ngào cấm kỵ mà người lớn đã luôn ghen tị canh gác, không cho bọn họ tới.

- Cái Chết đỡ lấy, đưa tay Aimée nắm lấy tay người đàn ông từng hát cho bà. Linh hồn Aimée trút hơi thở cuối cùng trong vòng tay đó. Linh hồn thoát ra khỏi thân thể, phồng lên và phân giải thành ánh sáng đang mở rộng và rực rỡ hơn.', '//cdn.hstatic.net/products/200000979221/dfsb_3c6c3e54cbce44748ae3aa936daa46c9_medium.jpg', 'Ngôi Làng Nhỏ Ở Vùng Núi Nyons - Nina George', 6, 151200, 'Còn hàng', '2026-01-01', 'Nina George', 'Lâm Đức Duy', 'NXB Lao Động', '1980 Books', 336, 'Bìa mềm', 450, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(31, 'Một câu chuyện đời, cũng là một chuyện tình, rất đỗi đau thương. Jude làm tôi nhớ tới Kiếp người của Somerset Maugham. Nhưng Philip Carey rốt cuộc cũng tìm được hạnh phúc muộn màng, còn Jude cả đời phấn đấu, mà không vẫn hoàn không. Nada y pues Nada. Kính mừng hư vô toàn hư vô. Những nhà phê bình Anh Mỹ nói rất nhiều điều, nhiều khía cạnh về tác phẩm này, nhưng họ bỏ quên một điều: Ý nghĩa của Hư vô bàng bạc mênh mang trong Jude.', '//cdn.hstatic.net/products/200000979221/jude-ke-vo-danh-1_248f4e2c76174fafbddc41491fae276a_medium.jpg', 'Jude - Kẻ Vô Danh - Thomas Hardy', 6, 159000, 'Còn hàng', '2019-01-01', 'Thomas Hardy', 'Nguyễn Thành Nhân', 'NXB Tổng hợp Tp.HCM', 'NXB Tổng hợp Tp.HCM', 580, 'Bìa mềm', 700, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(23, 'Ở một thung lũng mang tên Thiên Đường, trong ngôi nhà sơn trắng nằm giữa những vườn nho...
... có một cô bé sôi nổi, vô tư, mơ thành nữ chính trong những chuyện tình sến sẩm...
... có một cậu thiếu niên hoàn hảo, chói ngời, đứa con mơ ước của mọi gia đình...
... có một chàng nghệ sĩ vĩ cầm thiên tài, nổi loạn, ngày ngày khát khao vươn tới đỉnh cao.

Họ, ba anh em nhà Fall, lần lượt chạm mặt một cô gái bí ẩn có mái tóc cầu vồng. Cô là ai, là gì, chưa ai kịp hiểu. Nhưng bằng cách nào đó, cô đã kịp trở nên quan trọng với từng người... Trước khi thế giới dưới chân họ đột nhiên chao đảo. Trước khi những vết rạn ẩn sâu trong mỗi người bỗng toác ra. Trước khi họ lật giở lại những bí mật, những lời nguyền, qua nhiều thế hệ, để tìm lại sự trọn vẹn trong tim.

Vẫn những hình ảnh đậm chất thơ, vẫn những cảm xúc dữ dội mà tinh tế, Jandy Nelson đã trở lại và làm thỏa lòng độc giả sau cả thập kỷ chờ đợi với một câu chuyện bay bổng, huyền hoặc, lớp lớp tầng tầng và đầy những ngã rẽ bất ngờ, về một gia đình chỉ có thể viết tiếp tương lai bằng cách kể lại quá khứ của chính mình.', '//cdn.hstatic.net/products/200000979221/bia-sach-web-34_5c5298175434487a89e5cea168a1c721_medium.jpg', 'Khi Thế Giới Chao Nghiêng -  Jandy Nelson', 6, 268000, 'Còn hàng', '2026-01-01', 'Jandy Nelson', 'Danh Huy', 'NXB Văn Học', 'Nhã Nam', 596, 'Bìa mềm', 700, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(41, 'TÀN NGÀY ĐỂ LẠI - GIẤC MƠ TRỌN VẸN HAY LỜI TỪ BIỆT CHO QUÁ KHỨ?

 

Nếu có một cơ hội để quay lại quá khứ, bạn sẽ làm gì? Cố gắng sửa chữa hay chỉ lặng lẽ nhìn nó trôi đi?

 

Hành trình của một đời người, của những lỡ làng và tiếc nuối

 

"Tàn Ngày Để Lại" là câu chuyện về Stevens, một quản gia tận tụy, cả đời tận hiến cho sự hoàn hảo của công việc, nhưng khi cuộc đời dần khép lại, ông mới bắt đầu tự hỏi: Liệu tất cả những gì mình theo đuổi có thực sự đáng giá?

Một chuyến đi xuyên nước Anh, một cuộc gặp gỡ với người phụ nữ ông từng yêu nhưng chưa bao giờ dám thừa nhận - Miss Kenton. Những ký ức bị chôn giấu suốt hàng chục năm trỗi dậy, kéo Stevens đối diện với câu hỏi đau đớn nhất: Liệu ông có còn cơ hội để thay đổi, hay tất cả đã quá muộn?

 

 

- Một câu chuyện đầy xúc cảm về những điều ta đã đánh mất – tình yêu, thời gian, những cơ hội không thể lấy lại.

- Góc nhìn sâu sắc về cuộc sống và con người – Khi ta dành cả đời để theo đuổi một lý tưởng, liệu đó có thực sự là hạnh phúc?

- Một trong những tác phẩm văn học vĩ đại nhất thế kỷ 20, đạt giải Man Booker Prize

- Từng được chuyển thể thành bộ phim xuất sắc với Anthony Hopkins và Emma Thompson thủ vai

- Dành cho những ai từng tiếc nuối, từng tự hỏi: Nếu được làm lại, tôi có thay đổi điều gì không?

 

 

VỀ TÁC GIẢ

Kazuo Ishiguro – Bậc thầy của những câu chuyện hoài niệm

- Ông là chủ nhân của giải Nobel Văn học 2017, là một bậc thầy trong việc khắc họa những ký ức chông chênh giữa thực và ảo, giữa điều ta mong muốn và điều ta đã mất.

- "Tàn Ngày Để Lại" không chỉ là cuốn sách nổi bật nhất của ông mà còn là một tuyệt tác về sự lỡ làng, về những điều đáng lẽ có thể xảy ra nhưng cuối cùng lại chẳng bao giờ thành hiện thực.', '//cdn.hstatic.net/products/200000979221/dsfgfgf_33655875386d44d69712a136e70395a5_medium.jpg', 'Tàn Ngày Để Lại - Bìa Cứng (Tái Bản 2026)', 6, 158400, 'Còn hàng', '2026-01-01', 'Kazuo Ishiguro', 'An Lý', 'NXB Văn Học', 'Nhã Nam', 286, 'Bìa mềm', 429, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(42, 'Giữa rừng già Nam Mỹ, một chú chó được xua đi săn đuổi một thổ dân da đỏ
Giữa rừng già Nam Mỹ, một chú chó được xua đi săn đuổi một thổ dân da đỏ. Trên đường lần theo dấu kẻ trốn chạy, chú chó dần nhận ra mùi của những thứ mình đã đánh mất: mùi củi khô, mùi bột mì, mùi mật ong,… và rồi mùi người anh em của mình. Chú chó nhớ lại tất cả những gì những Con người của Đất từng dạy cho nó: cách tôn trọng thiên nhiên, biết ơn mẹ đất, sống hòa hợp với vạn vật và đặc biệt cái tên của nó, Afmau - theo tiếng thổ dân nghĩa là Trung thành.

Với tài năng kể chuyện vô song, Luis Sepúlveda biết cách tôn vinh những tình cảm cổ xưa, cao quý một cách sống động, để lại những ấn tượng khó quên về thế giới của người Mapuche, về mối gắn kết của họ với thiên nhiên vĩ đại.', '//cdn.hstatic.net/products/200000979221/gsxfhf_a6dab364d34d457e8ce6f8a7cd79966a_medium.jpg', 'Chuyện Con Chó Tên Là Trung Thành (Tái Bản 2026)', 6, 44800, 'Còn hàng', '2026-01-01', 'Luis Sepúlveda', 'Hoàng Nhụy', 'NXB Hội Nhà Văn', 'Nhã Nam', 96, 'Bìa mềm', 144, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(43, 'MONG MANH HOA TUYẾT là trường thiên tiểu thuyết của Tanizaki Jun" ichirō về đất nước Nhật Bản nhiều tâm tư và xung đột ý thức hệ trước công cuộc canh tân của kỷ nguyên mới. Câu chuyện xoay quanh sự thoái trào của nhà Makioka - một danh gia vọng tộc ở Osaka vào đầu thế kỷ 20, nơi những phong tục truyền thống trên đà tan rã, nơi văn hóa Tây dương len lỏi vào từng tập quán gia đình. Bốn chị em gái nhà Makioka - người đại diện cho quá khứ - người đại diện cho tương lai - một mặt luôn đau đáu về cái danh quá vãng của dòng tộc, mặt khác buộc phải vật lộn để thích nghi với thời cuộc mới...

 

 

Giới thiệu tác giả:

 

Tanizaki Jun"ichirō là một thiên tài văn chương với một văn nghiệp đồ sộ. Ông là người kể chuyện có duyên nhất trong những cây viết tiền chiến, nội dung của các tác phẩm của ông phần nhiều khai thác cảnh sống hoan lạc, đồi phế của xã hội cũ đang suy tàn và miền sâu phong kín của địa ngục nội tâm con người muôn thuở. Văn chương Tanizaki vừa thâm trầm, cổ kính, vừa bóng bẩy, diễm tình, vừa đồi phế bệnh hoạn nhưng không kém phần tinh tế.', '//cdn.hstatic.net/products/200000979221/ccc_78c2221136034afd9e6093b5b2c5d19a_medium.jpg', 'Mong Manh Hoa Tuyết - Tanizaki Junichiro', 6, 323000, 'Còn hàng', '2026-01-01', 'Tanizaki Junichiro', 'Nam Tử', 'NXB Hội Nhà Văn', 'Tao Đàn', 520, 'Bìa mềm', 780, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(47, 'Cuốn sách đạt giải thưởng Booker International 2025. Một tuyển tập tác phẩm đầu tay đồ sộ bằng tiếng Anh của Banu Mushtaq: luật sư, nhà hoạt động, người bảo vệ quyền lợi phụ nữ Hồi giáo và người đoạt giải thưởng văn học cao quý nhất của Ấn Độ.

 

Thông qua 12 câu truyện ngắn, Banu Mushtaq đã khắc họa một cách tinh tế cuộc sống thường nhật của phụ nữ và trẻ em gái trong các cộng đồng Hồi giáo ở miền nam Ấn Độ. Được xuất bản lần đầu bằng tiếng Kannada từ năm 1990 đến năm 2023, được ca ngợi vì lối viết hài hước nhẹ nhàng và tinh tế, những bức chân dung về căng thẳng gia đình và cộng đồng này minh chứng cho nhiều năm làm nhà báo và luật sư của Mushtaq, trong đó bà không ngừng đấu tranh cho quyền phụ nữ và phản đối mọi hình thức áp bức về đẳng cấp và tôn giáo.

 

Được viết theo phong cách vừa dí dỏm, sống động, gần gũi, cảm động lại vừa sắc bén, chính qua các nhân vật của bà – những đứa trẻ lanh lợi, những bà ngoại táo bạo, những giáo sĩ Do Thái ngốc nghếch và những người anh em côn đồ, những người chồng thường xuyên bất hạnh, và trên hết là những người mẹ, những người phải trả giá rất đắt để vượt qua cảm xúc của mình – mà Mushtaq hiện lên như một nhà văn và người quan sát bản chất con người đáng kinh ngạc, xây dựng nên những cung bậc cảm xúc khó tả từ một lối văn phong giàu sức gợi. Tác phẩm của bà đã nhận được cả sự chỉ trích từ giới bảo thủ lẫn những giải thưởng văn học danh giá nhất của Ấn Độ; đây chắc chắn là một tuyển tập sẽ được đọc trong nhiều năm tới.

 

 

VỀ TÁC GIẢ

 

BANU MUSHTAQ là một nhà văn, nhà hoạt động vì quyền phụ nữ và luật sư tại Karnataka, miền Nam Ấn Độ. Bà bắt đầu viết trong các nhóm văn học phản kháng tiến bộ và đã trở thành một tiếng nói quan trọng trong nền văn học Kannada tiến bộ. Mushtaq là tác giả của sáu tập truyện ngắn, một tiểu thuyết, và nhiều tác phẩm tiểu luận. Ngọn đèn trong tim là tác phẩm đầu tiên của bà được dịch sang tiếng Anh, giúp bà trở thành nhà văn Ấn Độ thứ hai giành Giải thưởng Booker Quốc tế.', '//cdn.hstatic.net/products/200000979221/z7613886827888_4782bb406b37886eb7cafc8bb790b594_9c69a880bcb04218ad9ba2f32f7396b2_medium.jpg', 'NGỌN ĐÈN TRONG TIM – Banu Mushtaq', 4, 127200, 'Còn hàng', '2026-01-01', 'Banu Mushtaq', 'Kim Diệu', '01/01/2026', 'Kim Diệu', 280, 'Bìa mềm', 420, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(7, 'TÂM LÝ TRỊ LIỆU HIỆN SINH
 
Lời ngỏ từ người dịch

 
Gửi bạn, độc giả thân mến,

 

Trong hàng ngàn giờ lắng nghe những câu chuyện trong phòng trị liệu, tôi đã cùng thân chủ đối diện với cảm giác cô đơn, lạc lõng, và trống rỗng, tuyệt vọng trước những trải nghiệm đau khổ, hay ngay cả khi họ dường như đang có "tất cả". Đằng sau những giọt nước mắt và nỗi băn khoăn ấy, tôi luôn nghe thấy một câu hỏi chung: "Ý nghĩa cuộc sống là gì?" hay “Tôi đang làm gì với đời mình vậy?” Tôi nhận ra, thân chủ của tôi không phải là những người “có vấn đề” hay “khác thường” đang tìm kiếm ai đó để sắp xếp lại cuộc đời họ, mà cũng giống như tôi, là những người đang vật lộn với chính sự tồn tại của mình.

 

Hành trình ấy đã đưa tôi đi qua nhiều trường phái tâm lý khác nhau, từ những kỹ thuật mang tính ứng dụng cao đến những nền tảng triết lý sâu sắc. Và Tâm lý trị liệu hiện sinh đã giúp tôi trả lời nhiều câu hỏi. Với gốc rễ từ triết học hiện sinh, đây là một liệu pháp hiếm hoi có khả năng lý giải sâu sắc những khó khăn của con người.

 

Cuốn sách Tâm lý Trị liệu Hiện sinh của tác giả Irvin D. Yalom mà bạn đang cầm trên tay có một vị trí đặc biệt trong lịch sử Tâm lý học. Ra mắt năm 1980, tác phẩm này đã bắc một cây cầu quan trọng giữa triết học hiện sinh châu Âu và thực hành trị liệu tâm lý tại Mỹ. Tại thời điểm đó, khi tâm lý học vẫn bị chi phối bởi các trường phái mang nặng tính thực nghiệm và hành vi, Yalom đã mang đến một lựa chọn nhân văn và sâu sắc hơn.

 

Tác phẩm của Yalom là một cột mốc quan trọng vì đã tích hợp một cách có hệ thống các nguyên lý cốt lõi của triết học hiện sinh từ các nhà tư tưởng vĩ đại như Kierkegaard, Nietzsche và Sartre vào một khung thực hành lâm sàng dễ tiếp cận. Ông lập luận rằng, nguồn gốc sâu xa nhất của lo âu và đau khổ ở con người xuất phát từ bốn "định đề" cơ bản của sự tồn tại:

 

Cái chết: Tính hữu hạn không thể tránh khỏi của cuộc sống.
Tự do: Trách nhiệm đối với những lựa chọn và hành động của bản thân.
Sự cô lập: Nỗi cô đơn sâu thẳm trong ý thức của mỗi cá nhân.
Sự vô nghĩa: Sự thiếu vắng một ý nghĩa được định sẵn trong vũ trụ.
 

Thay vì xem đây là những bệnh lý cần được chữa khỏi, Yalom tin rằng liệu pháp hiệu quả là giúp thân chủ đối diện và đấu tranh với những nỗi lo âu hiện sinh này. Ông tin rằng, khi đối mặt với những sự thật khó khăn đó, con người sẽ được thôi thúc để sống chân thật hơn, chịu trách nhiệm cho cuộc đời mình và tự tạo ra ý nghĩa riêng.

 

Tôi đã dịch cuốn sách này không chỉ bằng kiến thức mà còn bằng cả trái tim và lòng biết ơn sâu sắc đối với Yalom - một trong những người thầy đã ảnh hưởng lớn lao đến con đường trở thành một nhà trị liệu của tôi.

 

Với mong muốn lớn nhất là mang những tư tưởng nhân văn sâu sắc này đến gần hơn với độc giả Việt Nam, đây không chỉ là một bản dịch mà còn là một sự sẻ chia chân thành, một lời mời gọi bạn cùng tôi đi sâu vào thế giới nội tâm để khám phá những hữu hạn đớn đau nhưng cũng vô cùng đẹp đẽ của sự tồn tại.

 

Như Yalom đã khẳng định: "Tâm lý trị liệu không chỉ là việc chữa lành bệnh tật, mà còn là việc giúp con người đối diện và vượt qua những nỗi sợ hãi cơ bản của sự tồn tại." Cuốn sách này chính là chìa khóa để bạn thực hiện điều đó, giúp bạn mở rộng tầm nhìn, phát triển sự đồng cảm và trang bị những công cụ để không chỉ trị liệu cho người khác mà còn đối diện với chính mình.

 

Cuối cùng, tôi xin trích một câu nói của Yalom mà tôi luôn tâm niệm: "Mặc dù cái chết về thể xác hủy hoại chúng ta, ý niệm về cái chết lại cứu rỗi chúng ta." Câu trích dẫn mạnh mẽ này gói gọn thông điệp cốt lõi của cuốn sách: bằng cách chấp nhận những giới hạn cuối cùng của mình, chúng ta được giải phóng một cách nghịch lý để sống trọn vẹn hơn và tìm thấy mục đích trong khoảng thời gian hữu hạn của mình.

 

Trân trọng,

 

Dương Thùy Lệ Trang

Thạc sĩ Tâm lý, Nhà trị liệu

 

---

 

LỜI KHEN TẶNG

 

 

“Tôi tin rằng cuốn sách xuất sắc này sẽ trở thành một tác phẩm kinh điển cho những người nghiên cứu liệu pháp tâm lý hiện sinh và cho tất cả các nhà lâm sàng. Nhưng sẽ là một sai lầm nếu chỉ giới hạn nó cho riêng các bác sĩ tâm thần và các nhà tâm lý học - bất kỳ ai quan tâm đến những gì khiến con người hành động như cách họ đang làm sẽ tìm thấy sự giúp đỡ ở đây. Tôi thấy nó dễ đọc đến mức khó lòng mà đặt xuống."  

- Rollo May

 

"Luận văn đáng chú ý này khám phá liệu pháp tâm lý trong bối cảnh liên quan của nó đến các vấn đề lớn của sự tồn tại của con người. Là sản phẩm của kinh nghiệm lâm sàng sâu rộng, được đánh giá và tích hợp bởi một trí tuệ nhạy bén, am hiểu và mạnh mẽ, đây là một thành tựu ấn tượng. Văn phong hùng hồn, trong sáng và được làm sống động bởi những tia sáng của sự dí dỏm.

Cuốn sách mang lại nhiều giá trị cho các nhà trị liệu tâm lý bận rộn với công việc hàng ngày... và sẽ là một trải nghiệm đọc đặc biệt phong phú cho bất kỳ ai suy ngẫm về các vấn đề rộng lớn hơn của đời sống con người.” 

- Jerome D. Frank

 

"Một lần nữa, Irvin Yalom lại cho ra đời một tác phẩm có ý nghĩa lớn và tính thời sự cao. Ông đã kết tinh được bản chất của liệu pháp tâm lý hiện sinh. Với vô số minh họa lâm sàng và một đánh giá kỹ lưỡng về các tài liệu, ông đã xây dựng nên một tác phẩm về những xung đột nảy sinh từ sự đối diện của cá nhân với những nỗi quan tâm tối thượng nhất định: cái chết, tự do, sự cô lập và sự vô nghĩa.

Cuốn sách này nên được đọc bởi mọi bác sĩ nội trú chuyên ngành Tâm thần học và mọi thực tập sinh tâm lý học lâm sàng. Nó xứng đáng có mặt trong thư viện của mọi nhà trị liệu tâm lý."  

- H. Keith H. Brodie

 

---

 

MỤC LỤC

 

LỜI NGỎ TỪ NGƯỜI DỊCH

LỜI TRI ÂN

CHƯƠNG 1: DẪN NHẬP

LIỆU PHÁP HIỆN SINH: MỘT LIỆU PHÁP TÂM LÝ ĐỘNG

ĐỊNH HƯỚNG HIỆN SINH: LẠ NHƯNG QUEN THUỘC ĐẾN KỲ LẠ

LĨNH VỰC CỦA TÂM LÝ TRỊ LIỆU HIỆN SINH

TRỊ LIỆU HIỆN SINH VÀ CỘNG ĐỒNG HỌC THUẬT

PHẦN 1: CÁI CHẾT

CHƯƠNG 2: CUỘC SỐNG, CÁI CHẾT, VÀ NỖI LO ÂU

TƯƠNG THUỘC SỐNG-CHẾT

CÁI CHẾT VÀ NỖI LO ÂU

SỰ LÃNG QUÊN CÁI CHẾT TRONG LÝ THUYẾT VÀ THỰC HÀNH TÂM LÝ TRỊ LIỆU

FREUD: NỖI LO ÂU KHÔNG CÓ CÁI CHẾT

 

CHƯƠNG 3: QUAN NIỆM CỦA TRẺ EM VỀ CÁI CHẾT

SỰ PHỔ BIẾN CỦA NỖI LO LẮNG VỀ CÁI CHẾT Ở TRẺ EM

QUAN NIỆM VỀ CÁI CHẾT: CÁC GIAI ĐOẠN PHÁT TRIỂN

LO ÂU VỀ CÁI CHẾT VÀ SỰ PHÁT TRIỂN CỦA BỆNH LÝ TÂM THẦN

GIÁO DỤC VỀ CÁI CHẾT CHO TRẺ EM

 

CHƯƠNG 4: CÁI CHẾT VÀ BỆNH LÝ TÂM THẦN

NỖI LO SỢ CÁI CHẾT: MỘT MÔ HÌNH BỆNH LÝ TÂM THẦN

SỰ ĐẶC BIỆT

ĐẤNG CỨU RỖI TỐI THƯỢNG

HƯỚNG TỚI MỘT CÁI NHÌN TỔNG THỂ VỀ BỆNH LÝ TÂM THẦN

BỆNH TÂM THẦN PHÂN LIỆT VÀ NỖI SỢ HÃI CÁI CHẾT

MÔ THỨC HIỆN SINH VỀ TÂM BỆNH HỌC: BẰNG CHỨNG NGHIÊN CỨU

CÁI CHẾT NHƯ MỘT TÌNH HUỐNG RANH GIỚI

 

CHƯƠNG 5: CÁI CHẾT VÀ TRỊ LIỆU TÂM LÝ

CÁI CHẾT NHƯ NGUỒN LO ÂU CHỦ YẾU

CÁC VẤN ĐỀ CỦA TRỊ LIỆU

HÀI LÒNG VỚI CUỘC SỐNG VÀ NỖI LO ÂU VỀ CÁI CHẾT:

ĐIỂM TỰA TRỊ LIỆU

GIẢI MẪN CẢM VỚI CÁI CHẾT

TỰ DO

PHẦN 2: TỰ DO

CHƯƠNG 6: TRÁCH NHIỆM

TRÁCH NHIỆM - MỘT MỐI BẬN TÂM HIỆN SINH

NÉ TRÁNH TRÁCH NHIỆM: NHỮNG BIỂU HIỆN LÂM SÀNG

ĐẢM NHẬN TRÁCH NHIỆM VÀ TRỊ LIỆU TÂM LÝ

NHẬN THỨC TRÁCH NHIỆM THEO KIỂU MỸ - HAY, LÀM THẾ NÀO ĐỂ

LÀM CHỦ CUỘC ĐỜI MÌNH, TỰ QUYẾT ĐỊNH, CHĂM SÓC BẢN THÂN, VÀ ĐẠT ĐƯỢC MỤC TIÊU

TRÁCH NHIỆM VÀ TÂM LÝ TRỊ LIỆU: BẰNG CHỨNG NGHIÊN CỨU

NHỮNG GIỚI HẠN CỦA TRÁCH NHIỆM

TRÁCH NHIỆM VÀ CẢM GIÁC TỘI LỖI HIỆN SINH

TRÁCH NHIỆM, SỰ SẴN LÒNG, VÀ HÀNH ĐỘNG

 

CHƯƠNG 7: Ý CHÍ

HƯỚNG TỚI SỰ THẤU HIỂU LÂM SÀNG VỀ Ý CHÍ: RANK, FARBER, MAY

Ý CHÍ VÀ THỰC HÀNH LÂM SÀNG

ƯỚC MUỐN

QUYẾT ĐỊNH - LỰA CHỌN

QUÁ KHỨ SO VỚI TƯƠNG LAI TRONG TRỊ LIỆU TÂM LÝ

PHẦN 3: SỰ CÔ LẬP

CHƯƠNG 8: CÔ LẬP HIỆN SINH

CÔ LẬP HIỆN SINH LÀ GÌ?

SỰ CÔ LẬP VÀ MỐI QUAN HỆ

CÔ LẬP HIỆN SINH VÀ BỆNH LÝ TÂM THẦN TRONG QUAN HỆ LIÊN CÁ NHÂN

HƯỚNG DẪN THẤU HIỂU CÁC MỐI QUAN HỆ LIÊN CÁ NHÂN

 

CHƯƠNG 9: CÔ LẬP HIỆN SINH VÀ TÂM LÝ TRỊ LIỆU

ĐỐI DIỆN VỚI SỰ CÔ LẬP CỦA BỆNH NHÂN

SỰ CÔ LẬP VÀ CUỘC GẶP GỠ GIỮA BỆNH NHÂN-NHÀ TRỊ LIỆU

PHẦN 4: SỰ VÔ NGHĨA

CHƯƠNG 10: SỰ VÔ NGHĨA

VẤN ĐỀ VỀ Ý NGHĨA

Ý NGHĨA CUỘC SỐNG

Ý NGHĨA CÁ NHÂN THẾ TỤC

NHỮNG ĐÓNG GÓP CỦA VIKTOR FRANKL

MẤT Ý NGHĨA: HÀM Ý LÂM SÀNG

NGHIÊN CỨU LÂM SÀNG

 

CHƯƠNG 11: SỰ VÔ NGHĨA VÀ TRỊ LIỆU TÂM LÝ

TẠI SAO CHÚNG TA CẦN Ý NGHĨA?

CHIẾN LƯỢC TRỊ LIỆU TÂM LÝ

 

LỜI BẠT', '//cdn.hstatic.net/products/200000979221/untitled_design__51__fdb303de94eb47c0bfcfa83880ecae72_master_4ef577516b9c4da1aabffd7e844ed445_medium.png', 'Tâm lý Trị liệu Hiện sinh - Irvin D. Yalom', 4, 403750, 'Còn hàng', '2025-01-01', 'Irvin D. Yalom', 'Dương Thùy Lệ Trang', 'Đà Nẵng', 'Khai Tâm', 800, 'Bìa mềm', 1100, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(8, 'Ramanuja đã hỏi anh ta: “Anh đã bao giờ yêu ai chưa?”

Người đàn ông trả lời: “Không, tôi không bao giờ quan tâm đến cái thứ trần tục như thế. Tôi không bao giờ hạ thấp như thế; tôi muốn trải nghiệm Thượng đế”.

Ramanuja đã hỏi lại: “Anh không bao giờ quan tâm đến tình yêu một chút nào à?”

Người tìm kiếm đó trả lời dứt khoát: “Tôi đang nói sự thật”.

Người đàn ông tội nghiệp này đã nói như thế bởi anh ta nghĩ mình nên như thế. Trong thế giới tôn giáo thời đó, nếu đã từng yêu thì sẽ không phải là người có tư cách. Anh ta chắc chắn rằng nếu mình nói mình đã yêu ai đó thì nhà huyền môn này sẽ yêu cầu anh ta từ bỏ tình yêu này ngay tại chỗ - từ bỏ những gắn bó của anh ta, bỏ lại phía sau mọi cảm xúc trần tục trước khi đi tìm sự hướng dẫn. Vậy nên, ngay cả nếu người đàn ông này đã yêu ai đó thì anh ta vẫn cứ phủ nhận điều đó.

Nhưng bạn có thể tìm đâu ra một người chưa bao giờ yêu, cho dù chỉ một chút? Ramanuja đã hỏi lần thứ ba: “Hãy nói điều gì đó. Hãy suy nghĩ cẩn thận. Thậm chí không có một chút tình yêu đối với người nào đó, đối với bất kỳ ai sao? Bạn không yêu bất cứ ai dù chỉ một chút sao?”

Người tìm kiếm đó nói: “Xin thứ lỗi cho tôi, nhưng tại sao thầy cứ hỏi đi hỏi lại cùng một câu hỏi? Thậm chí tôi không muốn dính líu đến tình yêu. Tôi muốn trải nghiệm Thượng đế”.

Ramanuja đã trả lời: “Vậy thì bạn sẽ phải thứ lỗi cho tôi. Bạn hãy vui lòng đến chỗ người nào đó khác. Kinh nghiệm của tôi mách bảo tôi rằng nếu bạn đã yêu ai đó, bất kỳ ai, nếu bạn đã có dù chỉ một sự thoáng qua về tình yêu thì tình yêu đó có thể trải rộng tới nơi có thể chạm vào Thượng đế. Nhưng nếu bạn chưa bao giờ yêu thì trong bạn không gì có thể phát triển. Bạn không có hạt mầm để nó có thể phát triển thành cây. Hãy đi và yêu cầu người nào đó khác”.

------

Sự thật đơn giản là, chính tình dục là điểm khởi đầu của mọi hành trình tới tình yêu. Xuất phát điểm của hành trình tới tình yêu - Gangotri của tình yêu, nguồn cội của dòng sông Hằng tình yêu - chính là tình dục. Và mọi người đều chống đối tình dục - mọi nền văn hóa, mọi tôn giáo, mọi đạo sư, mọi con người thánh thiện. Sự chống đối của họ là sự tấn công vào chính Gangotri, chính cội nguồn, và dòng sông bị chặn lại ở đó: “Tình dục là tội lỗi… Tình dục là phi tôn giáo… Tình dục là độc hại”. Cuối cùng, chính năng lượng dục được chuyển hóa và biến đổi thành tình yêu, nhưng ý nghĩ này chưa bao giờ xuất hiện trong tâm trí chúng ta.

[...]

Vậy nguyên tắc đầu tiên tôi muốn trao cho bạn là, nếu bạn muốn biết hiện tượng được gọi là tình yêu thì bí quyết đầu tiên là bạn phải chấp nhận tính thiêng liêng, thánh thiện của tình dục - bằng tất cả trái tim mình. Và bạn sẽ ngạc nhiên khi thấy rằng bạn càng toàn tâm chấp nhận tình dục thì bạn sẽ càng tự do khỏi nó. Càng ít chấp nhận nó thì bạn càng trở nên lệ thuộc nó hơn, giống như người thánh thiện đó đã trở nên lệ thuộc vào bộ trang phục của mình. Bạn càng chấp nhận, bạn càng trở nên tự do. Sự chấp nhận cuộc sống và tất cả những gì tự nhiên trong cuộc sống một cách trọn vẹn, tôi gọi là tính tôn giáo. Và chính tính tôn giáo này sẽ giải thoát con người.

---
Mục lục
PHẦN I - TỪ TÌNH DỤC ĐẾN SIÊU THỨC

Mở đầu

• Hỏi: Tại sao chủ đề tình dục lại khiến người ta rất không thoải mái? Tại sao lại có sự cấm kỵ như thế?

• Hỏi: Quan hệ tình dục trong lúc thiền sao?

• Hỏi: Ông đã nói rằng tình dục đơn thuần sẽ chỉ tạo ra ngày càng nhiều đứa trẻ; vậy ông tạo ra điều gì khi kết hợp tình dục với thiền?

• Hỏi: Vậy bất kỳ điều gì mà không có ý thức đều là tội lỗi – có thể ông sẽ nói như thế?

• Hỏi: Đức hạnh là gì?

• Hỏi: Về mọi thứ?

 Chương 1 - Đi tìm tình yêu

 Chương 2 - Sự thu hút cơ bản

 Chương 3 - Ô cửa mới

 Chương 4 - Sinh ra một nhân loại mới

 Chương 5 - Từ Than đá tới Kim cương

 PHẦN II - VẤN ĐỀ DỤC TÍNH

 Chương 6 - Phá bỏ sự huấn luyện về tình dục

 Chương 7 - Đạo đức và Phi đạo đức

 Chương 8 - Ảo tưởng và Thực tại

 PHẦN III - KHÔNG NGUYÊN SƠ CŨNG KHÔNG TỘI LỖI

 Chương 9 - Sự hiểu biết trong thực tế

 PHẦN KẾT - TÌM KIẾM SỰ TOÀN VẸN

 Về Osho


', '//cdn.hstatic.net/products/200000979221/untitled_design__24__1e9d42120eae4c08a956ba718f470693_master_294c9aae06474b7d8981d4be3c96fcac_medium.png', 'Vấn đề dục tính: từ Tình dục đến Siêu thức - In lần thứ 2', 4, 189000, 'Còn hàng', '2025-01-01', 'Osho', 'Nguyễn Đình Hách', 'NXB Đà Nẵng', NULL, 564, 'Bìa mềm', 850, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(9, 'Tác phẩm cuối đời (và là cuối cùng) của Giáo sư Cao Huy Thuần

 

Quyển sách này đã được viết như thế nào?

Bạn đang cầm trong tay quyển sách đã được viết trong những ngày tháng cuối cùng của một người cả đời cầm bút không bao giờ mệt mỏi. Quyển sách này mới thật là quyển sách cuối cùng của anh Thuần. Trước đây, ai cũng tưởng Im lặng, như lời chia tay là quyển cuối cùng; ngay chính anh cũng đã nghĩ vậy. Nhưng rồi anh vẫn tiếp tục viết. Như anh từng nói, chữ là "sự sống của tôi, là lồng ngực của tôi thở trên mỗi trang giấy viết… cho đến khi gục chết trên chữ".

Anh Thuần đã viết với một tốc độ như một người trẻ còn sung sức trong những ngày sức khỏe dần dần suy kém. Mắt anh lúc đó đã mờ. Anh vốn là người rất nhạy cảm, dễ xúc động trước vẻ đẹp của con người và thiên nhiên. Mùa xuân năm nay, Paris rộn ràng hoa nở, anh than: "Anh biết hoa nở ngoài hàng hiên đẹp lắm nhưng anh có nhìn thấy được đâu!" Anh đọc rất khó khăn. Anh đọc trên màn hình chỉ rõ khi bài được hiện ra với nền đen chữ trắng. Mắt anh lóa khi gặp phải nhiều màu trắng trên trang giấy. Anh đọc sách với một tấm giấy bôi đen chỉ chừa một khoảng nhỏ để anh di chuyển dần trên trang sách. Lụi cụi vậy mà vẫn bền chí đọc. Tim anh thì cứ yếu dần, lúc đập nhanh, lúc đập chậm, khiến người anh mệt vô cùng. Vậy mà anh nói mỗi ngày anh vẫn kiên trì ngồi viết ít nhất là 2 hay 3 tiếng đồng hồ. Viết được chặng nào, anh gởi qua email cho hai em của anh ở Mỹ là chị Quỳnh và tôi chặng đó để "xin ý kiến", và vì… sợ mất! Vậy mà, thú thật, nhiều lúc tôi chưa kịp đọc đoạn anh gởi thì đã nhận được đoạn tiếp theo rồi!

Thấy anh làm việc quá sức, chị em tôi rất lo lắng. Những lúc nói chuyện và trao đổi thường xuyên với anh trên điện thoại, nhất là khi nghe anh ho sù sụ, chúng tôi khuyên anh nên làm từ từ thôi. Nhưng "mệt mà vui!", anh vẫn nói. Thì thôi, miễn anh vui là được rồi! Hễ còn thở được là anh vẫn còn viết. Cho đến khi bắt đầu thở khó thì anh được đưa vào bệnh viện. Thật là kỳ diệu, anh đã viết xong quyển sách chỉ vài ngày trước khi nhập viện! Lúc viết sắp xong, anh bảo, sách này nên có tranh vẽ minh họa. Thế là cháu ngoại anh, Juliette, 9 tuổi, được anh chọn làm họa sĩ! Và cháu đã rất sung sướng được đồng hành cùng ông ngoại trong quyển sách này. Cùng với chị, em Paul (7 tuổi) sau đó cũng đã vui sướng vẽ tranh cho sách ông ngoại. Nghe mẹ các cháu kể, lúc ở bệnh viện, chỉ vài ngày trước khi mất, những lúc tỉnh táo anh vẫn còn rất minh mẫn, hỏi thăm "Juliette đã vẽ xong con rùa chưa?". Anh vẫn còn nghĩ đến quyển sách trong những giờ phút đó.

Cây viết là người bạn thân thiết không bao giờ rời anh trong đời. Người bạn đó đã đem lại cho anh nguồn vui và lẽ sống. Và cũng nhờ niềm vui vô biên đó mà bây giờ chúng ta mới có được quyển sách này để trân quý.

(Xin chắp tay mạn phép anh để những dòng này vào trong sách của anh, bởi vì không thể nào "xin ý kiến" của anh được nữa rồi!).

Cao thị Mỹ-Lộc

California, 7/2024
---------
LỜI NÓI ĐẦU

            Kalila và Dimma là chuyện đầu trong nhiều chuyện được tập hợp lại thành quyển sách mà lịch sử biết đến dưới tên Ngụ ngôn của Bidpai. Sách xuất hiện tại Ấn Độ cách đây trên 2000 năm, thường được phỏng đoán là sau Những chuyện tiền thân của đức Phật (Jâkata) và chịu ảnh hưởng của tác phẩm này, ít nhất là trong cách mượn thú vật thế người để kể chuyện. Trong Jâkata, Đức Phật đã từng kể chuyện về tiền thân của mình trong nhiều kiếp như là nai, là khỉ, là chim, là sư tử… Ở đây cũng vậy, biên giới giữa người và thú không còn nữa, tất cả đều nói tiếng người, tất cả đều là ta, yêu thương hờn giận ngàn năm vẫn thế, con người vẫn thế với hèn hạ và thanh cao.

            Thể loại kể chuyện như thế, mà bây giờ ta gọi là ngụ ngôn, chắc là mới mẻ vào thời đó, cho nên tiếng tăm của quyển sách vượt biên giới Ấn Độ, lan truyền khắp nơi, Ba Tư, Ả-Rập, Thổ Nhĩ Kỳ, Hy Lạp, Éthiopie, đến tận Trung Hoa. Vua Ba Tư phải phái sứ giả vượt biên lùng sách mang về. Sách được dịch khắp nơi, phổ biến trong mọi vùng văn hóa, kể cả Do Thái, thậm chí nguyên tác viết bằng tiếng Phạn không tìm ra được nữa, sách xưa nhất còn lại là sách dịch từ tiếng Ba Tư và Ả-Rập. Quá nổi tiếng, quá phổ biến rộng rãi, từ vua chúa đến bình dân, tất nhiên nguyên tác không tránh khỏi cải biên cho hợp với mỗi văn hóa, mỗi thời.

            Cho đến thế kỷ 16, sách mới được biết ở châu Âu. Từ 1788 đến 1888, hơn hai mươi bản dịch khác nhau được xuất bản bằng tiếng Anh. Tại Pháp, thi hào La Fontaine, mà thế hệ chúng tôi tại Việt Nam từng học thuộc lòng rất nhiều bài thơ ngụ ngôn nổi tiếng năm châu, thú nhận: "Tôi xin nói, để cảm tạ, rằng một phần lớn trong các bài thơ ngụ ngôn của tôi là lấy từ Bidpai, nhà hiền triết Ấn Độ. Sách của ông đã được dịch ra mọi ngôn ngữ". Từ đó, khi sách đã lan ra đến Âu châu, có người nói: sách của Bidpai biết nhiều quốc gia hơn cả quyển Thánh Kinh.

            Nhưng ai là Bidpai, tác giả? Khó biết. Một trong những giả thuyết kể rằng, và tôi xin kể lại theo bà Doris Lessing: Sau khi Alexandre Đại đế chiếm Ấn Độ, Đại đế đặt lên một chính quyền bất công, bị dân chán ghét, và dân đã nổi dậy, lật đổ bạo chúa, đặt lên ngai một ông vua của mình, đó là vua Dabschelim. Nhưng… tránh vỏ dưa đạp vỏ dừa: vua sau không hơn gì vua trước. Một nhà hiền triết liều chết đến yết kiến vua để tâu rằng trời đất đang nổi giận vì vua tàn bạo, ngang ngược, không thực hiện bổn phận mang hạnh phúc đến cho dân như dân đã giao phó. Nhà hiền triết đó là Bidpai. Như Bidpai tiên đoán, vua tức giận, truyền giam ông vào ngục thất ghê tởm nhất, nhưng sau đó vài ngày, khi cơn giận đã dịu lại và trời đất thấm vào lòng, vua truyền đem ông vào hội kiến, và nhà hiền triết giáo huấn vua bằng những chuyện ngụ ngôn dễ hiểu, bình dân. Chính những chuyện "ngụ ngôn Bidpai" này là kho tàng văn hóa mà các ông vua ở các nước xung quanh muốn tìm gần ngàn năm sau.    

            Trong các thế kỷ sau đó, ngụ ngôn phát triển khắp nơi, và bất cứ ở đâu, ngụ ngôn cũng nhắm đến hai mục đích chính: giáo huấn và mua vui. Nhưng cái mới lạ mà ngụ ngôn Bidpai mang lại nằm ở cách kể chuyện, tạo nên một thể loại văn chương đặc biệt: chuyện này chuyện nọ không phải được kể riêng rẽ, mà lồng vào nhau, đan xen nhau quanh một chuyện chính như một cái trục, nhất quán từ đầu đến cuối, khiến người nghe, người đọc dễ bị cuốn hút, hấp dẫn hơn.

            Tôi vốn thích kể chuyện cho trẻ em, đã từng thể nghiệm qua một quyển sách, đã từng diễn kịch bằng ngụ ngôn La Fontaine trong lớp hồi nhỏ mà không biết, kể cả khi lớn, La Fontaine của văn hóa Tây phương là đến từ Bidpai của phương Đông. Nghĩ rằng người lớn nào cũng đã từng là trẻ em, tôi tự hỏi: Tại sao không kể Bidpai cho các U, từ U20 đến U100? Chỉ với mục đích mua vui thôi, chắc cũng không đến nỗi làm mất thì giờ để chạy đua của thế giới ngày nay.

            Vốn liếng của tôi chỉ căn cứ ở hai nguồn: một là quyển sách song ngữ tiếng Pháp và Ả-Rập do André Miquel dịch từ Ibn Al-Muqaffa, được xem như dịch giả Ả-Rập xưa nhất hồi thế kỷ thứ 8, ông này đã dịch từ bản dịch Ba Tư của Borzouyeh, người được vua Ba Tư phái đi lùng sách ở Ấn Độ hồi thế kỷ thứ 6; hai là quyển sách bằng tiếng Anh (được dịch ra tiếng Pháp) của Ramsay Wood (mà bà Doris Lessing viết Lời tựa), cả hai đều có nhan đề là Kalila và Dimma. Tài văn chương của Ramsay Wood đưa ông đi quá xa vào tiểu thuyết hóa, chắc là hợp với độc giả Âu châu, tôi không theo ông vì tôi nghĩ độc giả Việt Nam không ưa rườm rà, dài dòng, thích đi thẳng vào nội dung hơn. Nhưng Ramsay Wood dạy tôi một điều: hãy kể chuyện với văn phong của riêng mình, miễn là đừng xa với ý chính của ngụ ngôn. Do đó, tôi không phóng tác, cũng không tiểu thuyết hóa, trung thực với nội dung, nhưng bỏ những chỗ mà văn xưa, bối cảnh xưa không hợp với ngày nay, thêm thắt bằng tưởng tượng, bằng ý mới, lấy chỉ xưa thêu áo dài Việt Nam. Ngoài ra, tôi chỉ lấy ba chương trong Bidpai, những chương khác, không có chuyện lồng nhau, tôi thấy không cần thiết. Tôi viết nơi nhan đề : "kể lại" là vì vậy. Kể chuyện xưa đúng với chuyện xưa, nhưng làm mới cách kể chuyện bằng cảnh sắc mới và nhất là bằng văn phong riêng. Cuối cùng, ai đọc ngụ ngôn đều đọc chữ và đọc giữa những hàng chữ. Xưa nay ngụ ngôn vốn thế.

Cao Huy Thuần

---------

MỤC LỤC

Quyển sách này đã được viết như thế nào?
Lời nói đầu
Cổ thư
Bidpai

GIEO GIÓ...
Kalila nói với Dimma: “Bạn đang gieo gió,
bạn sẽ gặt bão”

Sư tử và bò
Con chồn và cái trống
Ông thầy tu và tên ăn trộm
Con quạ, con rắn và con sơn cẩu
Con cò và con cua
Con thỏ và con sư tử
Ba con cá
Con rệp và con rận
Con vịt và ngôi sao
Lạc đà, sử tử, chó sói, sơn cẩu và quạ
Con hải điểu và biển
Con rùa và hai con ngỗng
Bầy khỉ và con chích choè
Chàng xảo quyệt và chàng ngây ngô
Chim hải âu và con chồn xà thực
Chuột ăn sắt
Hoàng thái hậu
Ông hoạ sĩ và cái áo choàng
Ông lang băm và con gái của vua
Người đàn bà và con vẹt

 

BẠN VÀ THÙ
Vua hỏi nhà hiền triết: “Thế nào là làm bạn?
Có hay chăng kẻ thù giai đoạn và kẻ thù bản chất?”
Giữa bạn và thù
Bồ câu cườm, quạ và chuột
Người và rắn
Con chó sói muốn để dành
Ba nhà quê đổi mè
Con khỉ và con rùa
Con sử tử và con sơn cẩu
Cú và quạ
Cú, quạ và vua chim
Thỏ rừng và voi chúa
Chim hoạ mi, thỏ và mèo
Ông đạo sĩ bị lừa
Thương nhân, vợ và tên trộm
Quỷ, tên trộm và ông đạo sĩ
Người thợ mộc bị vợ lừa
Con chuột hoá thành thiếu nữ
Rắn hổ mang và nhái
Đầu năm nói chuyện ngụ ngôn', '//cdn.hstatic.net/products/200000979221/kalilavadimma_2486c1e293bb4ed7b597886f1d522c59_master__1__5189571e36c1439d80bcdb71c518cc9f_medium.jpg', 'Kalila và Dimma - Ngụ ngôn kể lại (Di cảo)', 6, 111150, 'Còn hàng', '2025-01-01', 'Cao Huy Thuần', NULL, 'Văn học', 'Khai Tâm', 224, 'Bìa mềm', 340, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(5, '1. Tâm phân học và Tôn giáo

2. Nghiên cứu Kinh Lăng-già

1. Tâm phân học và Tôn giáo

Khoa Tâm phân học sau Freud đã chứng kiến một cảnh “trăm hoa đua nở” vô cùng phong phú. Những trường phái tâm phân, nhằm khai thác các thành quả và chiều hướng cốt yếu trong tư tưởng của Freud, lần lượt xuất hiện và xác định vị trí của mình tuỳ như lập trường của những trường phái ấy thuận hợp hay chống đối với lập trường của người khai sinh ra khoa học này.

Erich Fromm, tác giả người Đức lai Mỹ của tập sách, chiếm một địa vị độc đáo trong trường phái tâm phân mệnh danh là Tâm phân học hiện sinh hay nhân bản. Như thế không phải vì ông là người đầu tiên đã nêu lên nghi vấn về tính cách phổ quát của phức cảm Oedipe, cũng không phải vì ông đã đưa ra ánh sáng mối liên hệ giữa cá nhân với xã hội và nhiên giới để điều chỉnh lại quan niệm cá nhân cô lập của Freud, nhưng chính vì ông đã nhấn mạnh trên quyền lực vô song của con người trong việc giải đáp những vấn đề chính yếu do cuộc hiện sinh đặt ra. Trung tâm điểm tư tưởng Fromm là mối bận tâm tối hậu của con người, sao cho mình có thể sống đích thực với chính mình, sống trong sự giải thoát toàn diện khỏi những áp chế của bất cứ thế lực thần quyền hay nhân quyền nào, và sống trong sự triển nở toàn diện những khả năng vô tận của mình. Chủ đề ấy xoáy sâu và tỏa rộng trong tất cả những tác phẩm của ông: Escape from Freedom (1941), Man for Himself (1947), Psychoanalysis and Religion (1950), và mới đây, trong cuốn The same society.

Qua tác phẩm Tâm phân học và Tôn giáo, Fromm muốn nối tiếp và làm sinh động lại cái truyền thống đã khởi nguyên từ thời Platon, trong đó nhà tâm lý học hay nói hẹp hơn, nhà tâm phân là một “Y sĩ của Linh hồn”. Tiền đề nền tảng của Fromm: Người ta không thể xâm phạm đến sự nguyên vẹn tri thức và tinh thần mà không phương hại đến toàn thể nhân cách, đã được sử dụng như một viên đá thử vàng. Sau cuộc thử lửa, những tôn giáo đặt nền trên thần quyền đều bị khước từ vì vĩnh viễn trói buộc con người vào tinh thần nô lệ. Chỉ những tôn giáo nhân bản, những tôn giáo xác quyết và đề cao sức mạnh tinh thần đích thực của con người trong nhiệm vụ giải phóng cho chính mình (trong đó Phật giáo là hình ảnh rực rỡ nhất vì đã đáp ứng đúng những yêu sách nói trên) mới được chấp nhận. Những phân tích về tâm trạng “tôn thờ thần tượng” của Fromm xui ta nhớ đến khuôn mặt yêu dấu của Simone Weil khi cô biện giải về quan niệm thiện ác.

Đây là một trong những tác phẩm hiếm hoi đề cập đến một vấn đề rất táo bạo và mới mẻ, với một tinh thần không bị che phủ vì thiên kiến. Vì thế, nếu trên bình diện thực nghiệm, chúng ta có thể tìm ra các chứng lý vạch rõ những bất toàn của đề án Fromm đưa ra, thì trái lại, xét về phương diện những đóng góp mới cho khoa Tâm phân học, lập trường của Fromm phải được chiêm nghiệm một cách sâu xa và nghiêm chỉnh.

- Ban Tu thư Vạn Hạnh, trong lần in bản dịch Việt ngữ năm 1968


Tháng Ba năm 1967

Erich Fromm

 

Mục lục
 
LỜI GIỚI THIỆU

LỜI TỰA I

LỜI TỰA II

Chương 1: VẤN ĐỀ

Chương 2: FREUD VÀ JUNG

Chương 3: PHÂN TÍCH VÀI ĐIỂN HÌNH KINH NGHIỆM TÔN GIÁO

Chương 4: NHÀ TÂM PHÂN HỌC NHƯ MỘT “Y SĨ CỦA LINH HỒN”

Chương 5: TÂM PHÂN HỌC LÀ MỘT ĐE DỌA CHO TÔN GIÁO?

 

2. Nghiên cứu Kinh Lăng-già

Một trong những kinh văn quan trọng nhất của Phật giáo Đại Thừa, trong ấy hầu như tất cả các tôn chỉ chính yếu được trình bày, kể cả giáo lý Thiền.

 

Kinh Lăng-già là một trong các kinh văn Đại Thừa quan trọng nhất, và Phật giáo Nepal xem kinh này là một trong chín kinh điển. Kinh này hàm chứa hầu hết các ý niệm chính, cả mặt triết học và thần học của Phật giáo Đại Thừa. Duy Thức Tông (Yogācāra) của Đại Thừa xem kinh này là kinh văn nền tảng, bởi vì kinh hàm chứa tất cả các ý niệm của duy tâm luận, như Duy-Tâm, tàng thức, làm thành căn bản triết học của tông này.

Bởi vì kinh văn cô đọng, khó hiểu và phức tạp về cách trình bày các ý niệm, tác giả cố gắng hết sức giải thích các ý niệm căn bản của Kinh Lăng-già trong bối cảnh của sự phát triển lịch sử của Phật giáo, mà tuyệt đỉnh là sự xuất hiện của Đại Thừa. Trong phần thứ nhất của sách tác giả đưa ra một nghiên cứu văn bản về kinh trong bối cảnh của nhiều bản dịch thực hiện ở Trung Quốc. Đồng thời tác giả cũng có vạch ra ảnh hưởng của kinh này đối với Phật giáo Trung Quốc và Nhật Bản, nhất là đối với Thiền. Trong phần còn lại của sách, tác giả chuyên chú vào việc giải thích các ý niệm triết học phức tạp tìm thấy trong kinh, và cách mà các ý niệm này được sử dụng bởi nhiều tông phái Phật giáo.

Tác giả cũng vạch ra liên hệ mật thiết hiện hữu giữa Kinh Lăng-già và Phật giáo Thiền. Mặc dù không phải chuyên nhất là một kinh văn Thiền, ảnh hưởng của kinh đối với Thiền không thể nào chối bỏ được. Các ý niệm không liên hệ đến Thiền trong kinh, đặc biệt là các ý niệm thuộc về Duy Thức Tông, cũng được thảo luận bởi tác giả trong phần thứ ba của sách.

 

 

Mục lục
 
NGHIÊN CỨU KINH LĂNG-GIÀ
TỰA CỦA DỊCH GIẢ
LỜI TỰA CỦA TÁC GIẢ

PHẦN I: DẪN NHẬP NGHIÊN CỨU KINH LĂNG-GIÀ

CHƯƠNG 1: CÁC BẢN DỊCH TRUNG VĂN VÀ TẠNG VĂN
CHƯƠNG 2: SO SÁNH NỘI DUNG CỦA BA BẢN DỊCH TRUNG VĂN, MỘT BẢN DỊCH TẠNG VĂN VÀ MỘT NGUYÊN BẢN PHẠN VĂN
CHƯƠNG 3: CÁC VÍ DỤ VỀ DỊ BIỆT GIỮA CÁC VĂN BẢN
CHƯƠNG 4: NGHIÊN CỨU THÊM VỀ KINH VÀ CÁC LIÊN HỆ NỘI TẠI CỦA KINH
CHƯƠNG 5: KINH LĂNG-GIÀ VÀ BỒ-ĐỀ-ĐẠT-MA, SÁNG TỔ CỦA PHẬT GIÁO THIỀN Ở TRUNG QUỐC
CHƯƠNG 6: NGHIÊN CỨU KINH LĂNG-GIÀ SAU BỒ-ĐỀ-ĐẠT-MA Ở TRUNG QUỐC VÀ NHẬT BẢN
CHƯƠNG 7: CHƯƠNG DẪN NHẬP CỦA KINH LĂNG-GIÀ


PHẦN II: KINH LĂNG-GIÀ VÀ GIÁO LÝ PHẬT GIÁO THIỀN


GHI CHÚ SƠ KHỞI


CHƯƠNG 8: MỘT TỔNG QUAN VỀ CÁC KHÁI NIỆM CHÍNH GIẢI THÍCH TRONG KINH
1. Tầm vóc của Phật giáo Đại Thừa
2. Giáo lý của Kinh Lăng-già
3. Tầm quan trọng cực kỳ của nội chứng
4. Kinh nghiệm nội tâm và ngôn ngữ
5. Các phức tạp tai hại phát sinh từ Phân biệt
6. Ý nghĩa của Yathābhūtam và Māyā
7. Vô Sinh có nghĩa là gì?
8. Nirvāṇa được giải thích như thế nào?
9. Yếu tính của Phật tính
10. Xuất Thế Gian Trí
11. Giáo lý Tam Thân
12. Xuất Thế Gian Trí và nguyên nhân tối sơ
13. Ngụ ngôn về cát sông Hằng


CHƯƠNG 9: NỘI DUNG TRÍ THỨC CỦA KINH NGHIỆM PHẬT GIÁO
1. Ngũ Pháp
2. Ba loại tự tính
3. Hai loại trí
4. Lý thuyết Nhị Vô Ngã


CHƯƠNG 10: TÂM LÝ LUẬN CỦA KINH NGHIỆM PHẬT GIÁO 
1. Giáo lý Duy Tâm
2. Giải thích các từ quan trọng
3 Lý thuyết Duy Tâm
4. Sự chuyển hóa của hệ thống Thức
5. Ba thể cách của Thức
6. Các tác năng của Bát Thức
7. Tác năng của Mạt-na
8. Sự thức tỉnh của Bát-nhã


CHƯƠNG 11: ĐỜI SỐNG VÀ HOẠT ĐỘNG CỦA MỘT BỒ-TÁT
1. Kỷ luật tự thân và Gia trì (Adiṣṭhāna)
2. Thanh Tịnh Hóa (Viśuddhi) Tâm
3. Ý Sinh Thân (Manomayakāya)
4. Bồ-tát và đời sống xã hội
5. Bồ-tát không bao giờ nhập Niết-bàn
6. Các nguyện của Bồ-tát và các hoạt động vô nỗ lực
7. Thập nguyện của Bồ-tát Samantabhadra (Phổ Hiền)

PHẦN III: MỘT SỐ LÝ THUYẾT QUAN TRỌNG GIẢI THÍCH TRONG KINH LĂNG-GIÀ


CHƯƠNG 12: GIÁO LÝ “DUY TÂM” (Cittamātra)
1. Một trong các lý thuyết chính của Kinh
2. Các đoạn trích dẫn liên hệ với Giáo lý
3. Tâm (Citta) và Chuyển hóa
4. Citta (Tâm), Ālayavijñāna (A-lại-da Thức) và Ātman (Ngã)
5. Hư vọng phân biệt, Vô sinh và Duyên khởi
6. Bằng cớ của “Duy Tâm”
7. Vài nhận định kết thúc


CHƯƠNG 13: KHÁI NIỆM VÔ SINH (Anutpāda)
1. Kinh Bát-nhã-ba-la-mật-đa và Kinh Lăng-già
2. Vô Sinh (Anutpāda) có nghĩa là gì?
3. Khái niệm của Phật giáo về Bất Tử
4. Vô Sinh có nghĩa là siêu việt Tương đối tính
5. Vô Sinh, Chân lý Siêu việt và Thường hằng Bất khả tư nghị
6. Khái niệm tích cực trong Vô Sinh


CHƯƠNG 14: TAM THÂN CỦA PHẬT
1. Đại cương Giáo lý
2. Kinh Kim Quang Minh về Tam Thân
3. Pháp Thân trong Kinh Lăng-già
4. Chưa có Tam Thân, mà chỉ có một Phật Tam Vị
5. Đẳng Lưu (Niṣyanda) và Biến Hóa (Nirmāṇa) Phật
6. Vipāka Buddha (Dị Thục Phật/Báo Phật)
7. Tam Thân trong Đại Thừa Khởi Tín Luận


CHƯƠNG 15: TATHĀGATA (NHƯ LAI)


CHƯƠNG 16: CÁC CHỦ ĐỀ THỨ YẾU
1. Nhất Thừa (Ekayāna)
2. Ngũ Vô Gián Nghiệp
3. Lục Ba-la-mật (Pāramitā)
4. Tứ Thiền
5. Thực Nhục (Māṁsabhakṣaṇa)


TỪ VỰNG: PHẠN VĂN - TRUNG VĂN - VIỆT VĂN', '//product.hstatic.net/200000979221/product/z6363351601361_df8d81f1598aec98b2416371559b9f86_51e4fb6d781e4fe196749fbc2691feeb_medium.jpg', 'Combo Khám Phá Tâm Thức - 2 cuốn, giá sốc chỉ 229k!', 4, 229000, 'Còn hàng', NULL, 'Daisetz Teitaro Suzuki, Erich Fromm', 'Thích Nữ Trí Hải, Như Hạnh', 'Khai Tâm', NULL, 716, 'Bìa mềm', 900, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(6, '  1. Hành trình nội tại
2. Thiền: Nghệ thuật nhập định

3. Con Đường Của Đạo - Tập 1


1. Hành trình nội tại: Thiền và nghệ thuật đối diện với cuộc sống

 

Thính giả thân yêu,

  
Trong buổi gặp đầu của chúng ta tại trại thiền này, tôi muốn nói tới bước đầu tiên của một thiền sinh, một người đi tìm. Bước đầu tiên ấy là gì? Một nhà tư tưởng hoặc một người yêu sẽ đi theo những con đường nhất định nào đó. Thế nhưng một người đi tìm lại phải qua một cuộc hành trình khác biệt hoàn toàn. Đối với người đi tìm, đâu là bước đầu tiên của cuộc hành trình?

Cơ thể chính là bước đầu của người đi tìm - thế nhưng lại không ai quan tâm hay để ý đến. Không phải chỉ đôi lúc thôi mà đã từ hàng ngàn năm nay, ta đã lãng quên cơ thể. Sự xao lãng này có hai dạng. Đầu tiên, có những kẻ phóng túng xao lãng cơ thể. Họ chẳng có kinh nghiệm gì về cuộc sống ngoài việc ăn, ngủ và mặc. Họ đã quên lãng cơ thể, lạm dụng và làm hao mòn nó một cách ngu ngốc. Họ đã phá hỏng dụng cụ của họ, cây đàn veena  của họ.

Nếu một nhạc cụ - ví như cây đàn veena - hư hỏng, nó không thể nào phát ra âm nhạc. Âm nhạc là điều khác hẳn cây đàn. Âm nhạc là một thứ. Cây đàn lại là thứ khác. Nhưng nếu không có đàn thì không thể nào phát ra nhạc được.

Những người phóng đãng đã là một loại, thế rồi lại có một loại người khác xao nhãng cơ thể bằng yoga và bằng sự hành xác. Họ tra tấn, đàn áp và thù ghét cơ thể. Chẳng ai, người buông thả cũng như người khắc kỷ, hiểu được tầm quan trọng của cơ thể.

Vì thế, có hai loại: buông thả và tra tấn cơ thể. Một bởi những người phóng túng và một bởi những người khắc kỷ. Cả hai đều làm hư hại cho cơ thể. Tại phương Tây, cơ thể bị hư hại theo một cách và tại phương Đông, theo một cách khác. Nhưng họ thảy đều là những kẻ tham dự vào việc phá hoại nó. Những người lui tới các nhà thờ hay các câu lạc bộ làm hại cho cơ thể theo một cách, còn những người đứng chân trần dưới nắng hoặc trốn chạy vào rừng sâu lại làm hại cơ thể theo một cách khác.

 

 

Mục lục
 
CHƯƠNG 1: Cơ thể - bước đầu tiên của người tìm kiếm

CHƯƠNG 2: Từ đầu xuống tim, từ tim xuống rốn
 
CHƯƠNG 3: Hành trình hướng đến rốn: thực phẩm phù hợp - làm việc đúng đắn - ngủ nghỉ đúng đắn  

CHƯƠNG 4: Những cách đối phó với tâm trí  

CHƯƠNG 5: Tự do khỏi cái ảo tưởng của kiến thức  

CHƯƠNG 6: Tự do thoát khỏi niềm tin 

CHƯƠNG 7: Những lời kinh về cây đàn trái tim  

CHƯƠNG 8: Tự do thoát khỏi “CÁI TÔI” 

 

2. Thiền: Nghệ thuật nhập định


 

3. Con Đường Của Đạo - Tập 1

 

I. Lời giới thiệu

The way of Tao: Osho giảng những câu kinh của Lão Tử trong cuốn Đạo Đức Kinh dựa trên những trải nghiệm tâm linh và thiền của chính bản thân ông. Những câu kinh của Lão Tử phản ánh những quy luật bất biến của vũ trụ nên nhiều khi nó mâu thuẫn với tư duy và hiểu biết thông thường. Toàn bộ những câu kinh của Lão Tử bao hàm và tác động lên toàn bộ sự vận hành của vũ trụ, trong đó có loài người. Trên cơ sở nhận thức đó, con người nên sống thuận tự nhiên. Đó là lối sống đúng đắn của những người có Đạo.



Khó khăn lớn nhất mà con người phải đối mặt khi họ bắt đầu diễn đạt Sự Thật là: Ngay khi Sự Thật được chuyển thành lời, nó trở nên Không Thật. Nó trở thành những gì không phải là nó. Khi đó, những gì cần truyền đạt thì vẫn chưa được nói ra; và những gì không cần truyền đạt thì lại được nói ra. Lão Tử bắt đầu câu đầu tiên của mình bằng phát biểu này". 
- Osho
Mời bạn cùng tham gia vào cuộc luận, cuộc giải ấy.

----

Lão Tử là một trong số rất ít những người đã biết, không phải bởi lời nói, không phải bởi kinh sách mà bởi cuộc sống thực tế. Ông cũng là một trong số rất ít những người biết đã không ngừng nỗ lực tiết lộ những gì họ biết. Nhưng chính trải nghiệm đầu tiên của những người chứng ngộ đó, khi họ cố gắng diễn đạt những gì họ đã biết, là: Bất kỳ điều gì có thể diễn đạt đều không phải là Sự Thật. Cái gì có thể mang hình tướng thì luôn mất đi sức mạnh tinh thần của nó (của cái vô hình tướng).

Bây giờ nếu ai đó mong muốn tạo ra một bức tranh về bầu trời thì điều này không bao giờ có thể thực hiện được. Bất kỳ bức tranh nào được tạo ra đều không phải là bầu trời, bởi bầu trời là không gian bao gồm mọi thứ. Một bức tranh không thể chứa đựng bất kỳ thứ gì; bản thân nó được bao quanh bởi không gian. Thế nên, Sự Thật được diễn đạt thành lời cũng giống như bầu trời được vẽ trong tranh. Không con chim nào có thể bay lượn trên bầu trời của một bức tranh, không mặt trời nào xuất hiện vào buổi sáng cũng như không ngôi sao nào xuất hiện vào ban đêm. Dù với mục đích nào, bầu trời trong tranh đều vô hồn và chỉ là cái tên. Bầu trời không thể tồn tại trong một bức tranh. Khó khăn lớn nhất mà con người phải đối mặt khi họ bắt đầu diễn đạt Sự Thật là: Ngay khi Sự Thật được chuyển thành lời, nó trở nên Không Thật. Nó trở thành những gì không phải là nó. Khi đó, những gì cần truyền đạt thì vẫn chưa được nói ra; và những gì không cần truyền đạt thì lại được nói ra. Lão Tử bắt đầu câu đầu tiên của mình bằng phát biểu này.


II. Mục lục

Chương 1: Đạo vĩnh cửu, bất biến

Chương 2: Đạo - mạch nguồn nguyên thủy bí ẩn

Chương 3: Đi vào những chiều sâu của Đạo

Chương 4: Đạo huyền bí - vượt lên vô minh và hiểu biết

Chương 5: Vẻ đẹp và điều thiện - không bị ảnh hưởng bởi những đối cực tương ứng

Chương 6: Giai điệu của những nốt nhạc đối lập

Chương 7: Hành động phi hành động và cuộc đối thoại thầm lặng của người trí huệ

Chương 8: Hành động vượt lên sự sở hữu và sự công nhận

Chương 9: Sự độc hại của tham vọng và trật tự của cuộc sống

Chương 10: Bí mật của cái dạ dày no nê và một tâm trí trống rỗng - Đạo

Chương 11: Kiến thức (lý thuyết) trống rỗng dẫn tới ham muốn

Chương 12: Đạo - Sự trống rỗng tột đỉnh, sự sơ khai tột cùng, sự hỗ trợ lý tưởng

Chương 13: Cái chết của bản ngã và sự thâm nhập vào điều huyền bí

Chương 14: Sự phản chiếu của cái có trước cả Thượng đế

Chương 15: Hiểu biết, trống rỗng, buông bỏ và nỗ lực

Chương 16: Bộ ba không thiên vị - Trời, Đất và Thánh thần

Chương 17: Sự hợp nhất của các mặt đối lập và sự sắp đặt trong trống rỗng

Chương 18: Năng lượng tối thượng - tương ứng với nữ tính bền bỉ và huyền bí

Chương 19: Những chiều hướng khác của một tâm thức nữ tính: trung thành, chấp nhận và buông bỏ

Chương 20: Phúc lành thay những người sẵn sàng là người cuối cùng

Chương 21: Bản chất của nước rất giống với Đạo

Chương 22: Lão Tử là hữu ích nhất trong tình trạng hiện tại của thế giới', '//product.hstatic.net/200000979221/product/z6363358250869_1fe54a111848514e05d10eab6101f1da_21af8fa5ebc34c2597ecc0bc5ebb3991_medium.jpg', 'Combo Khám Phá Nội Tâm - 3 cuốn, giá sốc chỉ 360k!', 4, 360000, 'Còn hàng', NULL, 'Osho', 'Chánh Tín, Nguyễn Đình Hách', 'Khai Tâm', NULL, 1284, 'Bìa mềm', 1600, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(10, '1. Hồ Thích Thiền học Án

2. Thiền đạo tu tập

Hồ Thích Thiền học Án

 1. Học thuật của Bác sĩ Hồ Thích thông quán Trung Tây. Sách Thần Hội Hòa Thượng Di Tập của ông khiến cả thế giới chú ý đến tư tưởng Thiền học Trung Quốc, lại càng khiến các học giả Nhật Bản đạt đến cao trào đối với nghiên cứu về vấn đề này. 

2. Học thuật giới Nhật Bản trọng thị học vấn của Bác sĩ Hồ Thích cũng như quan tâm đến phương pháp và thái độ nghiên cứu của ông. Thuở sinh tiền Bác sĩ Hồ Thích có ba người bạn văn hóa là ba giáo sư Nhật Bản lừng danh: Một vị đã khứ thế là Suzuki Daisetz Tiên sinh đã từng cùng Bác sĩ Hồ Thích triển khai luận chiến liên hệ đến sơ kỳ Thiền Tông sử Trung Quốc. Còn hai vị tiên sinh kia là Iriya Yoshitaka và Yanagida Seizan, đều đã từng cùng Bác sĩ Hồ Thích trao đổi thư tín đối luận về Thiền học.

3. Yanagida Seizan Tiên sinh là đương đại quyền uy của Phật Học Nhật Bản. Ông thức tỉnh người đời, nhấn mạnh sự thành tựu về nghiên cứu sơ kỳ Thiền Tông sử của Bác sĩ Hồ Thích cũng như nhận thức rằng Bác sĩ Hồ Thích vào cuối đời vùi đầu vào việc nghiên cứu Thiền sử, cho nên chưa hoàn thành chuẩn bị chấp bút quyển hạ của sách Trung Quốc Triết học Sử Đại cương. Nãi Dương nhớ lại cách nhìn này, cho nên xin phép đem các luận trước Thiền học của Bác sĩ Hồ Thích, xếp đặt có hệ thống cũng như chỉnh lý, thu thành một thiên, lấy tựa đề là Hồ Thích Thiền học Án. Hồ Thích Kỷ niệm Quán của Trung ương Nghiên cứu Viện nghe được tin này, vui lòng trợ giúp.

4. Thiết kế sách Hồ Thích Thiền học Án chỉ nhằm tiện lợi nghiên cứu đủ để đại biểu vị tri thức nhân đa dạng này của Trung Quốc cận đại học vấn. Bác sĩ Hồ Thích từng nói: “Muốn thu hoạch gì, thì phải vun trồng thế nào”. Nãi Dương vừa biên tập vừa học hỏi, cũng như công tác của người làm vườn, mong các hiền giả trong cũng như ngoài nước không hẹp lượng chỉ giáo!

5. Yanagida Seizan Tiên Sinh chủ biên sách này, đặc biệt tuyển chọn thiên “Bác sĩ Hồ Thích và nghiên cứu sơ kỳ Thiền Tông Sử Trung Quốc” làm giải đề thông quán. Iriya Yoshitaka Tiên sinh nhiệt tâm duyệt lại, còn viết thêm một thiên “Nhớ Hồ Thích Tiên sinh”, khiến người ta cảm động. Ngoài ra, còn nhờ Mao Tử Thủy Tiên sinh đai biểu trước tác quyền của Bác sĩ Hồ Thích, đồng ý dẫn dụng di trước của Bác sĩ. Đài Loan Chính Trung Thư Cục từ khởi nguyên hợp tác với Nhật Bản Trung Văn Xuất Bản Xã trong việc san hành. Chỉ việc này thôi cũng xin hết sức thâm tạ!

Nguyện đem sách này kính dâng hương linh Bác sĩ Hồ Thích trên trời! 

Lý Nãi Dương cẩn chí.
3/1/1975 tại Kinh Đô

 

Mục lục
HỒ THÍCH THIỀN HỌC ÁN 
I. Bồ-đề-đạt-ma khảo (Một chương của Trung Quốc Trung cổ Triết học Sử) 
ĐÀN KINH KHẢO 
II. Đàn Kinh Khảo (1) (Bạt Tào Khê Đại sư Biệt truyện) 
III. Đàn Kinh khảo (2) (Ghi về Lục Tổ Đàn Kinh bản Bắc Tống) 
THIỀN TÔNG THẾ HỆ THỜI ĐẠI BẠCH CƯ DỊ 
IV. Thiền tông Thế hệ Thời đại Bạch Cư Dị 
V. Hà Trạch Đại sư Thần Hội truyện 
LĂNG-GIÀ SƯ TƯ KÝ TỰ 
VI. Lăng-già Sư tư ký Tự	
VII. Lăng-già tông khảo 
PHỤ LỤC 
I. Từ các bản dịch nghiên cứu Thiền pháp Phật giáo 
II. Thiền học Cổ sử khảo 
III. Luận về Cương lĩnh của Thiền tông Sử	
IV. Hải ngoại Độc thư Tạp ký 
 

Thiền đạo tu tập

Những người Tây phương nhiệt thành nghiên cứu Thiền thường thấy rằng, sau khi cái quyến rũ ban đầu đã mòn mỏi, những bước tiếp tục cần thiết để theo đuổi nó một cách đứng đắn trở thành chán nản và vô hiệu quả. Cái kinh nghiệm Ngộ thì tuyệt diệu thật, nhưng vấn đề chủ yếu là, làm thế nào để thể nhập vào kinh nghiệm ấy? Vấn đề nắm bắt “nàng phù thủy Thiền” khiêu khích này đối với đa số những người hâm mộ Thiền ở Tây phương vẫn chưa được giải quyết.


Ấy là bởi vì việc nghiên cứu Thiền ở Tây phương vẫn còn trong giai đoạn vỡ lòng, và các người học vẫn còn lẩn quẩn trong cái vùng mơ hồ giữa việc “quan tâm đến” và “hiểu” Thiền. Đa số họ chưa đạt đến mức chín chắn trong việc nghiên cứu để họ có thể thực sự tu tập Thiền, chứng đắc Thiền, và biến Thiền thành cái sở hữu thâm sâu nhất của họ.
 
Bởi vì Thiền, tự bản tính và ở các mức độ cao, không phải là một triết học, mà là một kinh nghiệm trực tiếp mà người ta phải thâm nhập bằng cả con người mình, mục tiêu đầu tiên phải là nhằm để đạt đến và thể hiện kinh nghiệm Thiền. Để thể hiện cái kinh nghiệm tối thượng này, hay là Ngộ, ta cần phải hoặc là thâm tín một Thiền sư đã đắc pháp, hoặc là tiếp tục phấn đấu một mình bằng cách nghiên cứu và tu tập thực sự.

Với hy vọng tăng tiến một kiến thức về Thiền và giúp cho những người vẫn hằng tìm kiếm chỉ nam thực tập được dễ dàng hơn, tôi tuyển chọn, dịch, và trình bày ở đây một số tự truyện và pháp ngữ ngăn ngắn của các Thiền sư vĩ đại, từ các tài liệu cổ xưa lẫn cận đại, mà mặc dù rất phổ thông bên Đông phương, bên Tây phương lại không được biết đến lắm. Từ nội dung của những tài liệu này, ta có thể có được một hình ảnh về đời sống và hành trạng của các Thiền sư, nhờ thế hiểu rõ hơn Thiền đã được thực sự tu tập như thế nào. Vì không ai đủ tư cách hơn những Thiền sư đã đắc pháp này để đối trị với vấn đề tu tập Thiền. Do đó, theo gương và chỉ thị của họ là con đường đúng và an toàn nhất để tu tập Thiền. Chính vì lý do này mà tôi giới thiệu các pháp ngữ của bốn Thiền sư Trung Hoa lẫy lừng là Hư Vân, Tông Cảo, Bác Sơn và Hám Sơn.

Ngoài những đề nghị và phê bình của riêng tôi về việc tu tập Thiền, mà độc giả có thể thấy ở phần đầu Chương II, tôi cũng đưa ra một cái nhìn khái quát về các phương diện cốt yếu của Thiền ngay ở phần đầu sách. Hy vọng rằng sau khi đọc chương đầu, độc giả có thể có được một khái quát sâu xa hơn về Thiền, nhờ thế có thể theo đuổi việc nghiên cứu của mình dễ dàng hơn trước nhiều. Tuy nhiên, người mới đến với Phật giáo có thể gặp phải đôi khó khăn. Mặc dù tổng quát thì sách này có tính cách nhập môn, nhưng có lẽ về một số vấn đề và trên các phương diện nào đó của việc nghiên cứu Thiền, nó chuyên biệt hơn một số sách khác hiện có bằng Anh ngữ.

Chương III, “Bốn nan đề của Thiền”, vốn là một tiểu luận về “bản chất của Thiền” đăng trong tờ Philosophy East and West, số tháng giêng 1957, do Đại học Hawaii xuất bản. Với vài thay đổi nhỏ, bài đó bây giờ được cho vào sách này. Tôi tin rằng bốn vấn đề bàn luận trong đó rất là quan trọng cho việc nghiên cứu Thiền.

Chương IV, “Phật và Thiền định”, vốn được viết dưới hình thức một giảng thoại, đọc trong một cuộc hội thảo tại Đại học Columbia, vào 1954, theo lời mời của Tiến sĩ Jean Mahler. Bài đưa ra một số giáo lý căn bản của Phật giáo và vài nguyên tắc cốt yếu làm căn bản cho việc tu tập Thiền định mà có lẽ chưa được giới thiệu đầy đủ cho Tây phương.

Vì nhiều thành ngữ và từ ngữ Thiền quá khó nếu không nói là không tài nào dịch được, mặc dù một số học giả cho là hoàn toàn bất khả diễn dịch, tôi đã phải, trong một vài thí dụ, dùng đến lối dịch thoát. Một số chữ Nhật như “koan” tức là Công án, “Satori” tức là Ngộ, “Zen” tức là Thiền... hiện giờ đã được ổn định và thông dụng bên Tây phương, và chúng cũng được dùng trong sách này, cùng với nguyên ngữ Trung Hoa. Phương pháp La Mã hóa những chữ Hán sử dụng trong sách được dựa theo hệ thống Wade-Giles. Tôi cũng bỏ tất cả các dấu của chữ Hán và Sanskrit trong bản văn vì chúng chỉ tổ làm các độc giả thông thường bối rối và không cần thiết đối với các học giả Hoa ngữ và Sanskrit, vì họ sẽ nhận ra được ngay nguyên ngữ Trung Hoa và chữ Devanagiri.

Tôi xin được thâm tạ ông George Currier, cô Gwendolyn Winsor, bà Dorothy Donath và tiện nội, Hsiang Hsiang, tất cả đã trợ giúp tôi rất nhiều trong việc viết tiếng Anh, chuẩn bị, in và đánh máy bản thảo và đã đưa ra những đề nghị và phê bình rất có giá trị về tác phẩm này. Tôi cũng xin cảm tạ người bạn cũ, ông P. J. Gruber, đã luôn luôn trợ giúp và khuyến khích.

Là một người Trung Hoa tị nạn, tôi cũng xin cảm tạ tất cả các bằng hữu Hoa Kỳ của tôi và cả hai Cơ sở Bollingen và Cơ sở Nghiên cứu Á Đông đã rộng lượng giúp tôi cơ hội tiếp tục công việc và nghiên cứu đạo Phật ở Mỹ quốc đây. Tôi thật mang ơn họ vô cùng.

New York City, tháng 3, 1959
Chang Chen-Chi

 

Mục lục
TỰA CỦA DỊCH GIẢ
LỜI TỰA CỦA TÁC GIẢ

CHƯƠNG I: BẢN CHẤT CỦA THIỀN
PHONG CÁCH THIỀN VÀ NGHỆ THUẬT THIỀN
CỐT TỦY CỦA THIỀN: KHẢO SÁT BA PHƯƠNG DIỆN CHÍNH YẾU CỦA TÂM
BỐN ĐIỂM CỐT YẾU TRONG PHẬT GIÁO THIỀN TÔNG

CHƯƠNG II: THIỀN ĐẠO TU TẬP
KHÁI QUÁT VỀ SỰ TU TẬP THIỀN
TU TẬP THIỀN BẰNG CÁCH QUÁN TÂM TRONG TĨNH LẶNG
TU THIỀN BẰNG CÁCH THAM CÔNG ÁN
PHÁP NGỮ CỦA BỐN THIỀN SƯ
TỰ TRUYỆN CỦA NĂM THIỀN SƯ

CHƯƠNG III: BỐN NAN ĐỀ CỦA THIỀN
THIỀN VÀ PHẬT GIÁO ĐẠI THỪA
“TỨ LIỆU GIẢN” CỦA LÂM TẾ

CHƯƠNG IV: PHẬT VÀ THIỀN ĐỊNH
BA PHƯƠNG DIỆN CỦA PHẬT SO VỚI SÁU PHƯƠNG THỨC TƯ TƯỞNG CỦA CHÚNG SINH', '//product.hstatic.net/200000979221/product/z6363351563088_776878cb2c22093168711b0430af7347_70847833f2c54e92b4ec85a9a3c7af46_medium.jpg', 'Combo Thiền Học và Tu Tập - 2 cuốn, giá sốc chỉ 108k!', 2, 108000, 'Còn hàng', NULL, 'Chang Chen-Chi, Hồ Thích', 'Như Hạnh', 'Khai Tâm', NULL, 617, 'Bìa mềm', 700, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(36, 'Được xuất bản lần đầu từ thế kỷ 19 ở nước Anh, Chú chó vùng Flanders đã đưa tên tuổi nữ văn sĩ Ouida đến với hàng triệu độc giả khắp thế giới. Có lẽ chính bà cũng không thể tưởng tượng được, Chú chó vùng Flanders được xem như tác phẩm kinh điển dành cho thiếu nhi ở rất nhiều đất nước xa xôi như Ukraine, Nga, Nhật Bản, Hàn Quốc... và trong suốt hơn một trăm năm qua đã được nhiều lần chuyển thể thành kịch, phim, phim hoạt hình...

 

Câu chuyện giản dị mà cảm động về cậu bé Nello và chú chó trung thành Patrasche đã vượt qua thời gian và biên giới, trở thành một khúc bi ca của ước vọng chân thành bị thế gian vùi dập.

 

Bên cạnh đó, tuyển tập này còn có những truyện ngắn tiêu biểu khác của Ouida như Cái lò Nürnberg, Trong xứ táo và Bá tước nhỏ – những khúc ca thơ mộng về tuổi thơ, nơi sự ngây thơ đối đầu với hiện thực khắc nghiệt.', '//cdn.hstatic.net/products/200000979221/8935235244757_ba980fc9fe784102bfb63619c292d283_medium.jpg', 'Chú Chó Vùng Flanders - Ouida', 6, 88000, 'Còn hàng', '2026-01-01', 'Ouida', 'Thiên Nga', 'NXB Văn Học', 'Nhã Nam', 240, 'Bìa mềm', 300, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(37, 'Giữa khói lửa của Thế chiến II, cậu bé 11 tuổi Eric tìm thấy niềm vui duy nhất ở sở thú London, nơi có cô khỉ đột khổng lồ Gertrude, cũng là người bạn chí cốt của cậu. Khi bom đạn và những thế lực đen tối khác đe dọa mạng sống của Gertrude cũng như toàn dân Anh quốc, Eric cùng ông mình – người quản thú thân thiện Sid – dấn thân vào một hành trình táo bạo... Một cuộc phiêu lưu kịch tính, nghẹt thở nhưng đầy ắp tiếng cười, tình bạn và lòng dũng cảm bắt đầu!', '//cdn.hstatic.net/products/200000979221/bia-sach-web-36_ea9091f2963a44399aa0ed390fcb44cd_medium.jpg', 'Mật hiệu quả chuối - David Walliams', 6, 198400, 'Còn hàng', '2026-01-01', 'David Walliams', 'Nguyễn Khang Thịnh', 'NXB Hội Nhà Văn', 'Nhã Nam', 388, 'Bìa mềm', 450, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(45, 'Lũ Người Quỷ Ám

 

"Chúng tôi nhận thấy tác giả tin rằng con người dù sa đọa đến đâu vẫn có điểm tinh anh và có cơ cứu chuộc. Tác phẩm này có tính cách giải hoặc chứ không có tính cách lên án. Những kẻ mê lầm mà hành động sai quấy rồi cũng có ngày quay trở lại với nhân tính. Họ chỉ bị "quỷ ám", chứ không phải là "ma quỷ". Trung thành với niềm tin ở con người đó của tác giả, chúng tôi dịch là Lũ người quỷ ám, mà không nô lệ vào hình thức như các bản dịch Anh và Pháp mới đây." - Dịch giả Nguyễn Ngọc Minh.



Những kẻ đó có học và đầy lý tưởng - mong muốn làm việc gì đó lớn lao, cao thượng. Họ có niềm tin không thể lay chuyển rằng việc họ làm là vì điều tốt đẹp nhất cho nước Nga và cả loài người. Họ sẵn sàng nhúng tay vào máu nếu họ thấy đó là việc cần thiết để thay đổi thế giới theo cách họ muốn, dựa trên một lý thuyết của riêng họ về thiện ác và thượng đế. Tuy nhiên, bất kể họ nói gì, không khỏi có cảm giác có một con quỷ hiểm độc đang quanh quẩn đâu đó...



Fyodor Dostoyevsky, một trong ít số nhà văn lớn nhất thế giới, làm ta choáng ngợp với một câu chuyện vô tiền khoáng hậu mà không dễ gì lý giải về chuyện con người có thể làm điều ác nhân danh điều thiện như thế nào; với sức mạnh nghệ thuật vô song, ông đã mang tới bức tranh sống động về sự phức tạp, biến ảo, tinh vi của tâm hồn và tư tưởng con người.

 

 

Thông tin tác giả
 
Fyodor Dostoevsky

Tên đầy đủ là Fyodor Mikhailovich Dostoevsky (1821 – 1881) là nhà văn, nhà tư tưởng, triết gia, nhà báo Nga, thành viên Viện Hàn lâm Khoa học Petersburg từ năm 1877. Cùng với Lev Tolstoy, ông được xem là một trong hai nhà văn Nga vĩ đại thế kỷ XIX.

Dostoyevsky viết văn từ năm 20 tuổi, nổi tiếng nhất với chuỗi tiểu thuyết viết trong 15 năm cuối đời “đưa nhân loại trưởng thành lên một bước”: Tội ác và hình phạt, Chàng ngốc, Lũ người quỷ ám, Đầu xanh tuổi trẻ, Anh em nhà Karamazov. Ông được đánh giá đúng tầm vóc chỉ sau khi đã qua đời, được xem là người sáng lập hay dự báo chủ nghĩa hiện sinh thế kỷ 20.

Nhiều bộ óc thiên tài của thế giới như đại văn hào Nga L. Tolstoy, F. Nietszche, S. Freud, hay A. Einstein… đều đọc Dostoyevsky và nghiêng mình trước tài năng của ông. Nhiều tác phẩm của Dostoevsky được dựng phim, kịch, nhạc kịch cả ở Nga lẫn nước ngoài.

Macxim Gorki nhận xét Dostoevsky là “nhà văn thiên tài, biết phân tích những bệnh trạng của xã hội thời ông” và “là một thiên tài không thể phủ nhận được; với sức biểu hiện như vậy, chỉ có Shakespeare mới có thể đặt ngang hàng được”.', '//cdn.hstatic.net/products/200000979221/lu-nguoi-quy-am_008292842fc24ab59e7c05a7a4faed4d_master_d9bf19d203a04c408ca1b8566784d5d9_medium.png', 'LŨ NGƯỜI QUỶ ÁM – Fyodor Dostoyevsky', 6, 360000, 'Còn hàng', '2026-01-01', 'Fyodor Dostoevsky', 'Nguyễn Ngọc Minh', 'NXB Hà Nội', 'Nhã Nam', 662, 'Bìa mềm', 665,1000,1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(13, 'Cuộc sống con người là một hành trình mưu cầu hạnh phúc. Hạnh phúc mang nhiều chiều kích, nhiều khuôn mặt; với người này là những điều rất đỗi giản đơn, với người kia lại là những ước vọng vô cùng lớn lao...

 

Mời bạn khởi đầu ngày mới với trích dẫn từ những câu nói của Thiền sư Thích Nhất Hạnh. Đây có thể sẽ là một trong những cách giúp chúng ta thực tập chánh niệm mọi lúc mọi nơi và khơi nguồn hạnh phúc đích thực từ nội tại để từ đó lan tỏa giá trị ấy đến với tha nhân.

 

 Mong rằng mỗi trang sách, vượt ra ngoài khuôn khổ tôn giáo, sẽ như một dòng suối lành rửa trôi những khổ đau, vướng mắc, để lại sự bình an, hạnh phúc trong tâm hồn người đọc.', '//cdn.hstatic.net/products/200000979221/vvdzdav_d8990345a6684cf6983ba0e2f6916f79_medium.jpg', '365 Ngày Hạnh Phúc', 2, 239200, 'Còn hàng', '2026-01-01', 'Thích Nhất Hạnh', NULL, 'NXB Dân Trí', 'Phanbook', 366, 'Bìa mềm', 470, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(39, 'Sao Hỏa sẽ dẫn dắt các độc giả bước vào hành trình đến Hành tinh Đỏ. Ngay từ thời cổ đại, nó đã kích thích trí tưởng tượng của con người. Các nhà thiên văn học Trung Quốc cho rằng màu đỏ của Sao Hỏa gợi lên hình ảnh của lửa nên họ gọi nó là Hỏa tinh, tức ngôi sao lửa. Người Hy Lạp liên tưởng màu đỏ với máu và đặt tên cho nó theo vị thần chiến tranh của họ: Ares. Còn người La Mã, những người tiếp nhận thế giới thần thoại Hy Lạp, gọi hành tinh này là “Mars”. Đến thời Trung Cổ, nhờ có kính viễn vọng, các nhà khoa học đã phát hiện thêm nhiều chi tiết hơn về Hành tinh Đỏ, chẳng hạn như nhà thiên văn học người Ý Giovanni Domenico Cassini xác định được thời gian quay của Sao Hỏa là 24 giờ 40 phút, chỉ lệch ba phút so với hiện tại.

 

Tuy nhiên, việc nghiên cứu hành tinh này bằng kính thiên văn đặt trên Trái Đất đã đi đến giới hạn. Để tìm hiểu thêm, con người cần phải tìm cách đặt chân lên đó.

 

Và sáu mươi năm qua, hành trình đến Sao Hỏa đã đạt được một số thành tựu nhất định: từ tàu thăm dò bay qua đến tàu quỹ đạo, tiếp theo là các xe thám hiểm tự hành hạ cánh thành công. Ngày nay, các xe tự hành thực hiện nhiều nhiệm vụ khoa học nhằm khám phá những bí mật của Sao Hỏa.

 

Vậy trong tương lai, liệu con người có thể tới đó và sống lâu dài không? Và làm thế nào một thuộc địa trên Sao Hỏa có thể tự cung cấp nước, thực phẩm và ôxy? Độc giả có thể biết đáp án của các câu hỏi trên sau khi gập cuốn sách Sao Hỏa.', '//cdn.hstatic.net/products/200000979221/b_a_sao-h_a_1_2294227446c84b998b93e5f18d5b98a4_medium.jpg', 'Thế Nào Và Tại Sao - Sao Hỏa - Hành Trình Đến Hành Tinh Đỏ - Ts. Manfred Baur', 24, 88000, 'Còn hàng', '2026-01-01', 'Ts. Manfred Baur', 'Vũ Viết Thắng', 'NXB Phụ Nữ', 'Tân Việt', 48, 'Bìa mềm', 120, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(19, 'Ở một thung lũng mang tên Thiên Đường, trong ngôi nhà sơn trắng nằm giữa những vườn nho...
... có một cô bé sôi nổi, vô tư, mơ thành nữ chính trong những chuyện tình sến sẩm...
... có một cậu thiếu niên hoàn hảo, chói ngời, đứa con mơ ước của mọi gia đình...
... có một chàng nghệ sĩ vĩ cầm thiên tài, nổi loạn, ngày ngày khát khao vươn tới đỉnh cao.

Họ, ba anh em nhà Fall, lần lượt chạm mặt một cô gái bí ẩn có mái tóc cầu vồng. Cô là ai, là gì, chưa ai kịp hiểu. Nhưng bằng cách nào đó, cô đã kịp trở nên quan trọng với từng người... Trước khi thế giới dưới chân họ đột nhiên chao đảo. Trước khi những vết rạn ẩn sâu trong mỗi người bỗng toác ra. Trước khi họ lật giở lại những bí mật, những lời nguyền, qua nhiều thế hệ, để tìm lại sự trọn vẹn trong tim.

Vẫn những hình ảnh đậm chất thơ, vẫn những cảm xúc dữ dội mà tinh tế, Jandy Nelson đã trở lại và làm thỏa lòng độc giả sau cả thập kỷ chờ đợi với một câu chuyện bay bổng, huyền hoặc, lớp lớp tầng tầng và đầy những ngã rẽ bất ngờ, về một gia đình chỉ có thể viết tiếp tương lai bằng cách kể lại quá khứ của chính mình.', '//cdn.hstatic.net/products/200000979221/bia-sach-web-34_5c5298175434487a89e5cea168a1c721_medium.jpg', 'Khi Thế Giới Chao Nghiêng -  Jandy Nelson', 6, 268000, 'Còn hàng', '2026-01-01', 'Jandy Nelson', 'Danh Huy', 'NXB Văn Học', 'Nhã Nam', 596, 'Bìa mềm', 700, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(21, 'Tiệm giặt là Nửa đêm là đơn vị tổ chức workshop Chết cô độc, một workshop kỳ quái kéo dài 12 tuần giúp người tham gia luyện tập để đạt tới sự cô độc lý tưởng. Tại đây, những bậc thầy của nghệ thuật cô độc kiên nhẫn thực hành các nghi thức nhỏ bé và vô dụng: mỗi ngày kể một câu chuyện hài cho lợn; đều đặn dắt một chú chó vô hình đi dạo; tối đến mặc bộ đồ gấu trúc đứng khóc giữa phố; kể cả biết trước không cây táo nào mọc lên vẫn trồng lõi táo vào ly mì rỗng; lang thang trong đêm viết lên thân cây những câu từ lẻ loi dù biết nét chì yếu ớt chẳng đủ sức giữ lại một cái tên.

 

Với văn phong lạ lùng, châm biếm tựa như một vở hài kịch đen, Tiệm giặt là Nửa đêm nhìn trực diện vào nỗi cô đơn không thể tránh khỏi của con người. Giống như vòng quay đơn điệu của máy giặt tự động, cuốn sách mở ra một không gian chất chứa sự lặp đi lặp lại của cuộc sống thường nhật, nhưng cũng chính là nơi tuyệt vời để trải nghiệm sự tĩnh lặng và cô độc. Và ở tận cùng nỗi cô độc ấy, các nhân vật tìm thấy những kết nối mong manh mà sâu sắc, bởi dù biết hiện thực lạnh lùng và vô nghĩa, họ vẫn không ngừng yêu lấy một điều gì đó.', '//cdn.hstatic.net/products/200000979221/bia-sach-web-34-498ba553-2c54-4773-8b94-a21aac548c59_881aad8d962d460fab20307815e9fcdf_medium.jpg', 'Tiệm Giặt Là Nửa Đêm -  Park Ji Young', 6, 160000, 'Còn hàng', '2026-01-01', 'Park Ji Young', 'Nguyễn Thị Hồng Liên', ' NXB Hà Nội', 'Nhã Nam', 384, 'Bìa mềm', 450, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(22, 'Thời đại chúng ta đang sống là thời đại của sự chữa lành tổn thương tinh thần. Tính riêng trên các nền tảng mạng xã hội trong vài năm qua, có tới hàng triệu bài viết và thảo luận xoay quanh chủ đề chữa lành hay healing. Nhưng như mọi vấn đề sức khỏe khác, chăm sóc tổn thương tinh thần đòi hỏi những hiểu biết đầy đủ và nghiêm túc.

Vì tâm hồn biết lành lại của chuyên gia tâm lý Đặng Hoàng Ngân mang đến bạn đọc một hệ thống tri thức cơ bản về chăm sóc sức khỏe tinh thần. Xuất phát từ việc lý giải và bác bỏ những ngộ nhận phổ biến về các tổn thương tâm lý, cuốn sách đi sâu vào việc hiểu bản chất của tinh thần con người dựa trên một vài lý thuyết nổi bật trong tâm lý học: từ công nhận sự bất ổn, quan sát tâm trí, nhận diện cơ chế phòng vệ, cho đến việc kết nối với lịch sử cá nhân. 
Và như một công cụ đồng hành cùng bạn trải qua những thời khắc tinh thần khó khăn, cuốn sách còn giới thiệu các bài tập và phương pháp chăm sóc sức khỏe tinh thần; những thông tin cần biết khi tìm kiếm trợ giúp tâm lý; một số chương trình cộng đồng cũng như gợi ý sách đọc thêm... Bởi, tâm hồn chúng ta xứng đáng được chăm sóc bằng tất cả tình thương và hiểu biết, để khơi dậy những nguồn sống an vui, yêu đời.', '//cdn.hstatic.net/products/200000979221/dcv_59d03291e98f4e1086f4b278ce0f0aa9_medium.jpg', 'Vì Tâm Hồn Biết Lành Lại -  Đặng Hoàng Ngân', 5, 140000, 'Còn hàng', '2026-01-01', 'Đặng Hoàng Ngân', NULL, 'NXB Dân Trí', 'Nhã Nam', 304, 'Bìa mềm', 450, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(27, 'Cuốn sách là một tuyển tập những câu truyện “trinh thám” ngắn liên quan đến hành trình phá án hay đi tìm câu trả lời cho những bí ẩn hay “vụ án” xuất phát hoặc liên quan đến tiệm sách Tanabe nơi lão Iwa làm chủ. Trong suốt những hành trình nhỏ ấy, cả lão Iwa và đứa cháu Minoru của mình đã cho độc giả thấy lần lượt từng lớp lang bản chất con người (cả tiêu cực lẫn tích cực) cũng như mối quan hệ và tình cảm gia đình được thể hiện khéo léo qua những tương tác của hai ông cháu.

 

Tác giả: 

 Tác giả Miyabe Miyuki sinh năm 1960 tại Tokyo, được biết đến như “Tác giả quốc dân của nền văn học Nhật Bản”. Sau khi ra mắt công chúng lần đầu vào năm 1987, bà tiếp tục viết sách và nhận được rất nhiều giải thưởng ở nhiều thể loại khác nhau như tiểu thuyết trinh thám, tiểu thuyết thời đại, tiểu thuyết giả tưởng… Bên cạnh đó, 11 năm liền bà được bầu chọn là “Tác giả nữ được yêu thích nhất” và được xem là “Kỳ tích của lịch sử văn học Nhật Bản”.', '//cdn.hstatic.net/products/200000979221/untitled_d1b6cb7b2e754476aa588253e7688d85_medium.png', 'Chuyện Kỳ Lạ Ở Tiệm Sách Cũ Tanabe - Miyabe Miyuki - Sách bỏ túi', 6, 111200, 'Còn hàng', '2026-01-01', 'Miyabe Miyuki', 'Lê Hồng', 'NXB Thanh Niên', '1980 Books', 288, 'Bìa mềm', 540, 1000, 1);
INSERT INTO public.book
(id, description, img_src, "name", category_id, price, status, publish_date, author, translator, publisher, distributor, page_count, cover_type, weight, stock_quantity, discount_id)
VALUES(28, 'Trắng (Tiểu Thuyết)

 

Là câu chuyện của người đang cố gắng nói lời tiễn biệt với một phần quan trọng trong mình. Từ thế giới phủ đầy màu trắng ở Warsar, Han Kang đã lang thang vào thế giới tràn ngập sắc trắng của quá khứ xa xôi, với tã quấn, áo sơ sinh và sữa mẹ.

Trắng là màu da của người chị qua đời từ lúc sơ sinh mà cô không có cơ hội gặp gỡ, là bánh trăng tròn lúc chưa hấp, đẹp đẽ như thể chẳng được phép tồn tại trên đời. Trắng là nỗi đau cũ chưa lành, là nỗi đau mới còn vấn vương hoài niệm, và chính vì vậy mà không thể thành thứ ánh sáng trọn vẹn, cũng chẳng thể làm một bóng tối đúng nghĩa.

Trắng như sự bắt đầu của mọi thứ và cũng là điểm kết thúc của tất cả. Trắng đem chúng ta đến với thế giới đan xen giữa sự sống và cái chết, giữa hiện tại và quá khứ, như một chuyến du hành nhằm kiếm tìm sức mạnh nội tại, trải nghiệm sự mong manh của kiếp người, đồng thời nỗ lực tìm cách xây dựng cuộc sống mới từ đống tro tàn của đổ nát.

Trắng xóa nhòa ranh giới của các thể loại, làm mờ lằn ranh giữa tự truyện và văn chương – trở thành một trong những tác phẩm đặc biệt và riêng tư nhất của Han Kang.

Tác phẩm đã lọt vào Shortlist của International Man Booker năm 2018.

 

 
HOÀNG TỬ BÉ
Thông tin tác giả
Han Kang

Sinh năm 1970 tại Gwangju sau đó cùng gia đình chuyển lên Seoul sống từ năm mười tuổi. Sau khi tốt nghiệp khoa Văn trường đại học Yonsei, Han Kang đăng đàn năm 1993 trên báo Văn học và Xã hội với tư cách một nhà thơ. Năm 1994, cô cho ra mắt truyện ngắn “Mỏ neo đỏ”, giành giải tác giả trẻ của báo Seoul Shinmun, kể từ đó bắt đầu chính thức hoạt động văn chương.

Suốt sự nghiệp viết văn gần ba mươi năm, với 3 tập truyện ngắn, 6 tiểu thuyết và 1 tập thơ, Han Kang đã giành được nhiều giải thưởng văn học danh giá cả trong và ngoài nước, trở thành một trong những nhà văn quan trọng nhất của văn học Hàn Quốc hiện đại. Trong đó nổi bật nhất là giải Man Booker International năm 2016 dành cho tác phẩm Người ăn chay. Năm 2018, cô tiếp tục lọt vào danh sách đề cử của giải thưởng này với tiểu thuyết giàu tính tự thuật Trắng.


', '//cdn.hstatic.net/products/200000979221/trang-han-kang_a2b7fb8ca6cc4b9bb6e3609a4dba38e2_medium.jpg', 'Trắng - Han Kang', 6, 88000, 'Còn hàng', '2026-01-01', 'Han Kang', 'Hà Linh', 'NXB Hà Nội', 'Nhã Nam', 100, 'Bìa mềm', 150, 1000, 1);
