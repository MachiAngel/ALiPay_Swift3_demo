//
//  ViewController.swift
//  alipay_Swift3_demo
//
//  Created by Shiang-Yu Huang on 2017/7/22.
//  Copyright © 2017年 Shiang-Yu Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

   
    @IBAction func alipayBtnPressed(_ sender: UIButton) {
        let rsa2PrivateKey = "請輸入您或後台製作的私鑰" //私鑰rsa2格式
        let order = Order()
        order.app_id = "請輸入公司申請支付寶的appid"  //公司申請的支付寶appid
        order.method = "alipay.trade.app.pay"//依照官方範例
        order.charset = "utf-8" //依照官方範例
        order.notify_url = "https://xxxxxxxxxx.com" //商品請求結果支付寶異步通知的網址(你們家server後台)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        order.timestamp = dateFormatter.string(from: Date()) //依照官方範例
        order.version = "1.0" //依照官方範例
        order.sign_type = "RSA2" //根据商户设置的私钥来决定
        // NOTE: 以下商品数据
        order.biz_content = BizContent()
        order.biz_content.body = "測試測試測試測試測試測試" //自定訂單內容
        order.biz_content.subject = "測試" //自定訂單title
        order.biz_content.out_trade_no = "000001" //自定訂單id
        order.biz_content.timeout_express = "30m" //依照官方範例
        order.biz_content.total_amount = "0.01" //商品價格
        //以下将商品信息拼成string 全部都照範例規則
        let orderInfo = order.orderInfoEncoded(false)
        let orderInfoEncoded = order.orderInfoEncoded(true)
        let signer = RSADataSigner(privateKey: rsa2PrivateKey)
        let signString = signer?.sign(orderInfo, withRSA2: true)
        var orderString = ""
        
        if let signString = signString ,let orderInfoEncoded = orderInfoEncoded{
            let appScheme = "alipaydemo"   //這邊請避免使用到 alipay
            orderString = String.init(format: "%@&sign=%@", orderInfoEncoded,signString)
            
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: appScheme, callback: { (resultDic) in
                print(resultDic)
            });
        }

    }


}

