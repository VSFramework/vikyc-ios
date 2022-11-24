# VikycSDK
- Framework nhằm mục đích xác minh danh tính(KYC) được tạo ra bởi [Vision Network](https://visionnetwork.vn).

# Install
- Cách cài đặt
* Bước 1: Install Pod
- Framework *VikycSDK* hiện tại cần Install những cocoapods sau:

```
  pod 'OpenSSL-Universal'
```

` vui lòng chạy `pod init` nếu project chưa được install cocoapods `

* Bước 2: Copy file Vikyc.xcframework vào project:

> project -> Copy item if needed -> Create groups -> chọn target -> finish
[ảnh 1](image/Image_1.png)
> tiếp tục vào chọn target trong xcodeproj -> chọn General -> tìm đến dòng Frameworks, Libraries, And Embedded Content -> tìm đến Vikyc.xcFramework -> tại cột Embed đổi từ `Do not Embedded` -> Embed & Sign
[Ảnh 2](image/Image_2.png)

* Bước 3: Thêm capabilities cho ứng dụng của bạn
+ Vikyc cần quyền truy cập vào NFC,vậy nên hãy làm theo hưỡng dẫn sau
    + Vào phần Target của project, mục Signing & Capabilities.
    + Tìm và thêm Near Field Communication Tag Reader Session Formats vào  Capabilities
    
+ Khai báo sử dụng NFC tại file .plist
+ Khai báo sử dụng Camera tại file .plist
+ khai báo kiểu tag của thẻ CCCD

*Copy đoạn code dưới đây vào file plist của project*

```
<plist version="1.0">
<string>This app uses NFC to Capture CCCD</string>
</plist>
<plist version="1.0">
<string>sample deeplink cần quyền camera để chụp giấy tờ tuỳ thân</string>
</plist>
<plist version="1.0">
<string>This app uses NFC to scan CCCD</string>
</plist>
<array>
    <string>A0000002471001</string>
    <string>A0000002472001</string>
    <string>00000000000000</string>
</array>
</plist>

```
    

# Usage
VikycSDK được thiết kế để sử dụng dễ dàng, đơn giản. 
+ Gồm các bước sau: 
    + cấu hình Key: [ClientKey], [SecretKey]
    + cấu hình services_code, reqId
    + sử dụng dịch vụ NFC và xác minh CCCD.
    + Nhận kết quả từ Vikyc
    

## làm việc với VSConfigKeyBuilder
- Để sử dụng được dịch vụ vikyc, đầu tiên cần khởi tạo VSConfigKeyBuilder
    - VSConfigKeyBuilder: cung cấp cơ chế xác định các biến, các hàm được liên kết với VikycSDK
    
```Swift 
      let settingKey = VSConfigKeyBuilder(clientKey: \#ClientKey, secretKey: \#SecretKey)
            settingKey.configCode(serviceCode: "vikyc_3", reqId: "123123", isCapturFaceImage: Option<true/false>)
```
- Chi tiết:

| Key | Chi tiết |
| --- | --- |
| ClientKey | ID ứng dụng của đối tác, mỗi ứng dụng sẽ có một ID duy nhất. |
| SecretKey | Dùng để tạo, xác thực chữ ký điện tử signature. |
| serviceCode | Gói dịch vụ muốn sử dụng: ví dụ [vikyc_3] hoặc [vikyc_4] |
| reqId | Mã giao dịch phía đối tác sinh ra, duy nhất cho mỗi giao dịch (tối đa 50 kí tự) |
| isCapturFaceImage | Sử dụng chức năng nhận diện khuôn mặt: <default : false > |


## Sử dụng VSVikycBuild
- Trước khi di chuyển tới Screen Vikyc và đã cấu hình xong *VSConfigKeyBuilder*, hãy gọi function build tại [settingKey]

### Định nghĩa Function: 
   + build(withPhoto: CitizenIdentityPhoto, resultOption: ResponseOption? = nil) -> VSVikycBuild (*1)
   + build(withOcr: CitizenIdentityModel, resultOption: ResponseOption? = nil) -> VSVikycBuild (*2)
   + build(resultOption: ResponseOption? = nil) -> VSVikycBuild
### Param: 
    + withPhoto: sử dụng chức năng OCR của Vikyc,tham truyền vào 2 ảnh mặt trước và sau của CCCD, ảnh selfie là option
    + withOcr: sử dụng chức năng OCR đã có sẵn dữ liệu, chỉ sử dụng chức năng NFC và xác nhận thông tin của Rar
    + resultOption: tuỳ chọn nhận kết quả từ vikyc
        + onlyVikyc: nhận kết quả từ rar
        + option: nhận kết quả từ CCCD hoặc rar
        + onlyChip: nhận kết quả từ CCCD
    
### cách sử dụng
```Swift
    let settingKey = VSConfigKeyBuilder(clientKey: \#ClientKey, secretKey: \#SecretKey)
    settingKey.configCode(serviceCode: "vikyc_3", reqId: "123123", isCapturFaceImage: Option<true/false>)
    
    // để sử dụng full dịch vụ của Vikyc: chụp ảnh
    
    // đối với SwiftUI
    ViKycModule.openScanView(config: settingKey.build(resultOption: .onlyVikyc)!)
    
    // đối với UIKit
    ViKycModule.openScanCCCD(config: settingKey.build(resultOption: .onlyVikyc))
```

## Nhận Kết quả
- để nhận kết quả được trả về từ Vikyc, Vikyc đã thiết kế để có thể nhận được bất kỳ đâu, bất kỳ chỗ nào trong ứng dụng được tích hợp Vikyc

### cách sử dụng
```Swift
    let settingKey = VSConfigKeyBuilder(clientKey: \#ClientKey, secretKey: \#SecretKey)
    settingKey.configCode(serviceCode: "vikyc_3", reqId: "123123", isCapturFaceImage: Option<true/false>)
    
    // để sử dụng full dịch vụ của Vikyc: chụp ảnh
    
    let buildSetting = settingKey.build(resultOption: .onlyVikyc)
    
    // đối với SwiftUI
    ViKycModule.openScanView(config: buildSetting)
    
    // đối với UIKit
    ViKycModule.openScanCCCD(config: buildSetting)
    
    buildSetting.receiverValues { vsResponse in
        print("receivesValues")
        self.config = nil
        switch vsResponse {
            case .response(let resp):
            // kết quả giá trị nhận từ CCCD/ Rar
                print("resp", resp)
            case .finished:
            // trạng thái hoàn thành của Vikyc, nhận khi đóng Screen Vikyc 
                break
            case .error(let errors):
            // Lỗi của vikyc trả về 
                print("errors", errors)
            @unknown default:
                return
        }
    }
}
```

### Định nghĩa (*1*)(*2*)

** 1 Thông tin request CitizenIdentityPhoto **
* Ảnh của CCCD, gồm 2 giá trị là ảnh mặt trước và ảnh mặt sau Kiểu định dạng là Data **

| Tên | Định nghĩa | Require |
| --- | --- | --- |
| backPhoto | Ảnh mặt sau của CCCD | \* |
| frontPhoto | Ảnh mặt trước của CCCD | \* |
| selfiePhoto | Ảnh selfie cá nhân | Option |



*2 Thông tin request CitizenIdentityModel*
+ 2.1. CitizenIdentityModel

| Tên | Định nghĩa | Require |
| --- | --- | --- |
| ocrQrCode | CitizenIdentityQRCode Thông tin trong mã QRCode được in trên thẻ CCCD| \* |
| ocrFront | CitizenIdentityFrontPhoto Thông tin mặt trước của thẻ CCCD | \* |
| ocrBack | CitizenIdentityBackPhoto Thông tin đằng sau thẻ CCCD | \* |


+ 2.1.1. CitizenIdentityQRCode: Thông tin trong mã QRCode được in trên thẻ CCCD

| Tên | Kiểu dữ liệu| Định nghĩa | Require |
| --- | --- | --- |
| numberCard | String |Số thẻ cccd | \* |
| fullName | String |Số thẻ cccd | \* |
| dateBirthDay | String | Ngày sinh(định dạng dd/MM/yyyy) | \* |
| rangeDate | String | Ngày Cấp(định dạng dd/MM/yyyy) | \* |
| sex | String | Giới tính(Nam/Nữ) | \* |
| numberCardOld | String | Số CMT cũ | option |
| placeOfResidence | String | Nơi thường chú | option |

2.1.2: CitizenIdentityFrontPhoto: Thông tin mặt trước của thẻ CCCD

| Tên | Kiểu dữ liệu| Định nghĩa | Require |
| --- | --- | --- |
| numberCard | String |Số thẻ cccd | \* |
| fullName | String |Số thẻ cccd | \* |
| dateBirthDay | String | Ngày sinh(định dạng dd/MM/yyyy) | \* |
| rangeDate | String | Ngày Cấp(định dạng dd/MM/yyyy) | \* |
| sex | String | Giới tính(Nam/Nữ) | \* |
| numberCardOld | String | Số CMT cũ | option |
| placeOfResidence | String | Nơi thường chú | option |
| nationality | String | Quê quán | option |

2.1.3: CitizenIdentityBackPhoto: Thông tin mặt sau của thẻ CCCD

| Tên | Kiểu dữ liệu| Định nghĩa | Require |
| --- | --- | --- |
| backPhoto | Data | ảnh mặt sau CCCD | option |
| mrzString | String | định dạng mã MRZ được in đằng sau thẻ CCCD | \* | (*1*)
| dateBirthDay | String | Ngày sinh(định dạng dd/MM/yyyy) | \* |
| rangeDate | String | Ngày Cấp(định dạng dd/MM/yyyy) | \* |
| identifying | String | Đặc điểm nhận dạng | option |

(*1*): MRZ mẫu
`IDVNM10231422150010102314221<<6\n9907206M3907204VNM<<<<<<<<<<<0\nxxx<<xxx<xxx<<<<<<<<<<<<<<<<`

Chú ý: 
+ \* là bắt buộc
+ option: có thể null

##Ví dụ 
```Swift
import VikycSDK
import UIKit

class SampleVikyc: UIViewController { 

    @IBOutlet weak var openVikycButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    /**
       - Trong đó [ClientKey] và [SecretKey] được cấp bởi Vision Network
       - [ClientKey]: ID ứng dụng của đối tác, mỗi ứng dụng sẽ có một ID duy nhất.
       - [SecretKey]: Dùng để tạo, xác thực chữ ký điện tử signature.
       - [serviceCode] : gói dịch vụ muốn sử dụng: ví dụ [vikyc_3] hoặc [vikyc_4]
       - [reqId] : Mã giao dịch phía đối tác sinh ra, duy nhất cho mỗi giao dịch (tối đa 50 kí tự)
    */
    @IBAction func onOpenVikyc(_ sender: Any){ 
        do { 
            let config  = VSConfigKeyBuilder(clientKey: \*ClientKey, secretKey: \*SecretKey)
            try config.configCode(serviceCode: serviceCode, reqId: reqId)
            
            
            let fontData = CitizenIdentityFrontPhoto(numberCard: "0011023142215", fullName: "xxx xxx xxx", dateBirthDay: "20/07/1999", expiryDate: "20/07/2039", sex: "Nam")
            //
            let mrz = "IDVNM10231422150010102314221<<6\n9907206M3907204VNM<<<<<<<<<<<0\nxxx<<xxx<xxx<<<<<<<<<<<<<<<<"
            let backData = CitizenIdentityBackPhoto(mrzString: mrz, identifying: nil, dateRange: "19/09/2021")
            let qrCode =  CitizenIdentityQRCode(numberCard: "0011023142215", fullName: "xxx xxx xxx", dateBirthDay: "20/07/1999", sex: "Nam", rangeDate: "20/07/2039")
            // ảnh được selfie
            let selfie = UIImage(named: "IMG_0089")?.jpegData(compressionQuality: 1)
            let fullOCR = CitizenIdentityModel(ocrQrCode: qrCode, ocrFront: fontData, ocrBack: backData,selfiePhoto: selfie)
            ////
            
            let settingBuild =  settingKey.build(resultOption: .onlyVikyc)
            // đối với SwiftUI
            ViKycModule.openScanView(withOcr: fullOCR,config: settingBuild)

            // đối với UIKit
            ViKycModule.openScanCCCD(withOcr: fullOCR,config: settingBuild)
            
        }catch { 
            // những lỗi setting [key, secretkey, serviceCode,reqId] được trả về tại đây
            // lỗi empty
        }   

    }
}

```
