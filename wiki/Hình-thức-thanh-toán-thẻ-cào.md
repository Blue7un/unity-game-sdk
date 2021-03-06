### 1. Giao thức: HTTP/POST
### 2. Danh sách tham số
* `status`: Integer (Trạng thái giao dịch: 1 - Giao dịch được thực hiện thành công, 0 - Giao dịch thất bại.)
* `sandbox`: Integer (Giao dịch sandbox - giao dịch test: 1 - Môi trường sandbox, giao dịch được thực hiện bởi Appota giúp Nhà phát triển kiểm tra kết nối, 0 - Giao dịch được thực hiện bởi người dùng, Appota ghi nhận giao dịch)
* `transaction_id`: String (Mã giao dịch trên hệ thống Appota, Nhà phát triển có thể sử dụng mã này để xác minh giao dịch)
* `transaction_type`: `CARD` (Loại giao dịch) 
* `card_code`: String (Mã thẻ cào)
* `card_serial`: String (Mã serial của thẻ cào)
* `card_vendor`: String	(Nhà cung cấp thẻ cào: `VIETTEL`- thẻ cào điện thoại Viettel, `VINAPHONE` - thẻ cào điện thoại VinaPhone, `MOBIFONE` - thẻ cào điện thoại MobiFone, `FPT` - thẻ FPT Gate, `VNPTEPAY` - thẻ đa năng MegaCard)
* `amount`: Integer (Giá trị của thẻ cào)
* `currency`: String (Đơn vị tiền được tính - VND)
* `state`: String (Giá trị trường `state` trong hàm `AppotaGameSDK`.`getInstance()`.`init()`)
* `target`: String (Thông tin định danh người dùng của Appota)
* `country_code`: String (Mã quốc gia - VN)
* `hash`: String (Mã băm bảo mật nhằm xác nhận thông báo được gửi bởi hệ thống Appota)


Chú thích: 
* hash = `md5`(`amount` + `card_code` + `card_serial` + `card_vendor` + `country_code` + `currency` + `sandbox` + `state` + `status` + `target` + `transaction_id` + `transaction_type` + `client_secret`)
(Chuỗi nối giá trị các tham số sắp xếp theo thứ tự từ a->z của tên tham số).
* `client_secret`: Giá trị của Client Secret được cấp phát khi đăng ký ứng dụng.