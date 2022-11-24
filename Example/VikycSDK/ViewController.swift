//
//  ViewController.swift
//  VikycSDK
//
//  Created by Thanhdv2007 on 11/15/2022.
//  Copyright (c) 2022 Thanhdv2007. All rights reserved.
//

import UIKit
import VikycSDK


class ViewController: UIViewController {

    var config: VSVikycBuild? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onActionOpenFull(_ sender: Any) {
        do {
            // Gọi VSConfigKeyBuilder và truyền 2 parameter là CLIENT_KEY và SECRETKEY
            let config = try VSConfigKeyBuilder(clientKey: "#CLIENT_KEY", secretKey: "#SECRETKEY")
            // setting gói dịch vụ vikyc, và reqID
            try config.configCode(serviceCode: "vikyc_3", reqId: "123312", isCapturFaceImage: false)
            
            // đóng gói các cấu hình trên thành 1 func build
            self.config = config.build()
            
            // goij màn hình hiển thị scan CCCD của VIKYC
            let vc = ViKycModule.openScanCCCD(config: self.config!)
            
            
            // Present View
            self.present(vc, animated: true)
            
            // chờ kết quả từ vikyc
            self.config?.vsResult = { result in
                print("receivesValues")
                self.config = nil
                switch result {
                case .response(let resp):
                    print("resp", resp)
                case .finished:
                        // chủ động đóng view
                    vc.dismiss(animated: true)
                    break
                case .error(let errors):
                    print("resp", errors)
                @unknown default:
                    return
                }
            }
        } catch {
            print("errrorr => \(error)")
        }
    

    }
    
    @IBAction func onActionWithOCR(_ sender: Any) {
        do {
            // cần điền đầy đủ thông tin như sau
            // thông tin mặt trước
            let fontData = CitizenIdentityFrontPhoto(numberCard: "001096021397", fullName: "Đào Văn Thành", dateBirthDay: "20/07/1996", expiryDate: "20/07/2036", sex: "Nam")
//
            // thông tin mặt sau và mã mrz
            let mrz = "IDVNM0960213975001096021397<<6\n9607206M3607204VNM<<<<<<<<<<<0\nDAO<<VAN<THANH<<<<<<<<<<<<<<<<"
            let backData = CitizenIdentityBackPhoto(mrzString: mrz, identifying: nil, dateRange: "19/09/2021")
            
            // qrcode được in trên thẻ mặt trước
            let qrCode =  CitizenIdentityQRCode(numberCard: "001096021397", fullName: "Đào Văn Thành", dateBirthDay: "20/07/1996", sex: "Nam", rangeDate: "20/07/2036")
            
            // ảnh selfie của người cần xác minh thông tin
            let selfie = UIImageJPEGRepresentation(UIImage(named: "IMG_0089")!, 1)
            let fullOCR = CitizenIdentityModel(ocrQrCode: qrCode, ocrFront: fontData, ocrBack: backData,selfiePhoto: selfie)
            
            
            let config = try VSConfigKeyBuilder(clientKey: "c9d4-023c-4874-2a21", secretKey: "e4e83a37b35f9352bcd5e4992e5488f3")
            try config.configCode(serviceCode: "vikyc_4", reqId: "123312")
            self.config = config.build(withOcr: fullOCR)
            let vc = ViKycModule.openScanCCCD(config: self.config!)
            self.present(vc, animated: true)
            
            // chờ kết quả từ vikyc
            self.config?.vsResult = { result in
                print("receivesValues")
                self.config = nil
                switch result {
                case .response(let resp):
                    print("resp", resp)
                case .finished:
                        // chủ động đóng view
                    vc.dismiss(animated: true)
                    break
                case .error(let errors):
                    print("resp", errors)
                @unknown default:
                    return
                }
            }
            
        } catch {
            print("errrorr => \(error)")
        }
        
     
        
    }
    
}

