//
//  login_VC.swift
//  Taylor
//
//  Created by mac on 2023/6/19.
//


import UIKit

class login_VC: UIViewController {
    @IBOutlet weak var error_label: UILabel!
    
    @IBOutlet weak var password_text: UITextField!
    @IBOutlet weak var username_text: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //print(error_label.text)
        print("登陆喽")
        error_label.text=""


        // 加载Gif图片, 并且转成Data类型
        guard let path = Bundle.main.path(forResource: "run", ofType: "gif") else { return }
        guard let data = NSData(contentsOfFile: path) else { return }
        
        // 从data中读取数据: 将data转成CGImageSource对象
        guard let imageSource = CGImageSourceCreateWithData(data, nil) else { return }
        let imageCount = CGImageSourceGetCount(imageSource)
        
        // 便利所有的图片
        var images = [UIImage]()
        var totalDuration : TimeInterval = 0
        for i in 0..<imageCount {
            // 取出图片
            guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else { continue }
            let image = UIImage(cgImage: cgImage)
            if i == 0 {
                imageView.image = image
            }
            images.append(image)
            
            // 取出持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil) else { continue }
            guard let gifDict = (properties as NSDictionary)[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let frameDuration = gifDict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += frameDuration.doubleValue
        }
        
        // 设置imageView的属性
        imageView.animationImages = images
        imageView.animationDuration = totalDuration
        imageView.animationRepeatCount = 0
        
        // 开始播放
        imageView.startAnimating()
    

        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "success"{
            if let destination = segue.destination as?success_VC{
                destination.text = "登录成功"
                 
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
            if identifier == "success" {
                if let username = username_text.text, !username.isEmpty,
                   let password = password_text.text, !password.isEmpty {
                    if UserManager.shared.login(username: username, password: password) {
                        // 当登录成功后，将用户名保存到UserDefaults
                        UserDefaults.standard.set(username, forKey: "currentUsername")
                        return true
                    } else {
                        error_label.text = "用户名或密码错误"
                        return false
                    }
                } else {
                    error_label.text = "请输入用户名和密码"
                    return false
                }
            }
            error_label.text = ""
            
            return true
        }

}
