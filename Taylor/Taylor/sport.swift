//
//  sport.swift
//  Taylor
//
//  Created by mac on 2023/6/20.
//

import UIKit
import AVFoundation
import SQLite3


class sport: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    @IBOutlet weak var minutesPicker: UIPickerView!
    
    @IBOutlet weak var secondsPicker: UIPickerView!
    
    @IBOutlet weak var startPauseButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var chooseButton: UIButton!
    
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    
    
    
    
    
    // 分钟和秒钟的数组
    var minutes = [Int](0...59)
    var seconds = [Int](0...59)
    
    // 初始选择的分钟和秒钟
    var initialMinutes = 0
    var initialSeconds = 0

    // 计时器剩余的总秒数
    var totalSeconds = 0

    // 计时器
    var timer = Timer()

    // 表示计时器是否正在运行的布尔值
    var isRunning = false

    var audioPlayer: AVAudioPlayer?

    
    // SQLite数据库
    var dbFilePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/sport.db")
    
    var db: OpaquePointer?

    override func viewDidLoad() {
       super.viewDidLoad()
        
        
       
       // 初始化滑动条的值
       distanceSlider.minimumValue = 0
       distanceSlider.maximumValue = 100
       distanceSlider.value = 0
       distanceLabel.text = ""
       
       
       // 设置分钟和秒钟选择器的dataSource和delegate为self
       minutesPicker.dataSource = self
       minutesPicker.delegate = self
       secondsPicker.dataSource = self
       secondsPicker.delegate = self
       
       // 设置初始的计时器剩余时间
       totalSeconds = minutes[minutesPicker.selectedRow(inComponent: 0)]*60 + seconds[secondsPicker.selectedRow(inComponent: 0)]
       timerLabel.text = String(totalSeconds)
       
       chooseButton.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
       
       
        // 打开数据库连接
        if sqlite3_open(dbFilePath, &db) != SQLITE_OK {
            print("无法打开数据库")
        } else {
            // 创建运动会话表
            let createTableQuery = "CREATE TABLE IF NOT EXISTS sport_sessions (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, image BLOB, distance REAL, time INTEGER)"
            if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
                print("无法创建运动会话表")
            }
        }
       
    }
    
    deinit {
         // 关闭数据库连接
         sqlite3_close(db)
     }
    
    
    // 保存运动会话
    func saveSportSession(date: String, image: Data, distance: Float, time: Int) {
        // 插入数据的SQL语句
        let insertQuery = "INSERT INTO sport_sessions (date, image, distance, time) VALUES (?, ?, ?, ?)"
        
        var statement: OpaquePointer? = nil
        
        // 编译SQL语句
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("准备插入语句错误：\(errmsg)")
            return
        }
        
        // 绑定参数
        sqlite3_bind_text(statement, 1, (date as NSString).utf8String, -1, nil)
        sqlite3_bind_blob(statement, 2, (image as NSData).bytes, Int32(image.count), nil)
        sqlite3_bind_double(statement, 3, Double(distance))
        sqlite3_bind_int(statement, 4, Int32(time))
        
        // 执行插入语句
        if sqlite3_step(statement) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("插入数据错误：\(errmsg)")
        }
        
        print("保存的运动会话：")
        print("日期：\(date)")
        print("图片：\(image)")
        print("距离：\(distance)")
        print("时间：\(time)")
        
        

        
        sqlite3_finalize(statement)
        
        // 发送一个通知，通知运动会话列表刷新数据
        NotificationCenter.default.post(name: NSNotification.Name("newSportSessionSaved"), object: nil)
        
    }

    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        print("滑动条距离变为 \(currentValue)千米")
        
        let text = "\(currentValue)千米"
        let attributedString = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.green,
            .font: UIFont.systemFont(ofSize: 19)
        ]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: text.count))
        distanceLabel.attributedText = attributedString

    }


       // UIPickerViewDataSource方法

       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           // 我们只有一个组件在每个pickerView
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           // 返回分钟和秒钟的数组长度
           if pickerView == minutesPicker {
               return minutes.count
           } else {
               return seconds.count
           }
       }

       // UIPickerViewDelegate方法

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           // 返回分钟和秒钟的字符串
           if pickerView == minutesPicker {
               return "\(minutes[row]) 分钟"
           } else {
               return "\(seconds[row]) 秒"
           }
       }

       // 处理开始/暂停按钮的点击事件

       @IBAction func startPauseTapped(_ sender: Any) {
           if !isRunning {
               
               // 记录初始选择的时间
                initialMinutes = minutes[minutesPicker.selectedRow(inComponent: 0)]
                initialSeconds = seconds[secondsPicker.selectedRow(inComponent: 0)]
                           
                // 获取选中的分钟和秒钟，计算总秒数
               // 设置总秒数为初始选择的时间
                           totalSeconds = initialMinutes * 60 + initialSeconds
                if totalSeconds > 0 {
                    // 开始计时器
                    isRunning = true
                    let attributedString = NSAttributedString(string: "暂停", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30), NSAttributedString.Key.foregroundColor : UIColor.green])
                    startPauseButton.setAttributedTitle(attributedString, for: .normal)
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
                }
            } else {
                // 暂停计时器
                isRunning = false
                timer.invalidate()
                let attributedString = NSAttributedString(string: "开始", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30), NSAttributedString.Key.foregroundColor : UIColor.black])
                startPauseButton.setAttributedTitle(attributedString, for: .normal)
            }
           
       }

    // 更新计时器

    @objc func updateTimer() {
        if totalSeconds > 0 {
            // 减少剩余的总秒数
            totalSeconds -= 1
            timerLabel.text = String(totalSeconds)
            
            // 计算剩余的分钟和秒钟，更新pickerView
            let minutesRow = totalSeconds / 60
            let secondsRow = totalSeconds % 60
            minutesPicker.selectRow(minutesRow, inComponent: 0, animated: true)
            secondsPicker.selectRow(secondsRow, inComponent: 0, animated: true)
        } else {
            // 计时器到达0，停止计时器
            
            timer.invalidate()
            isRunning = false
            let attributedString = NSAttributedString(string: "开始", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30), NSAttributedString.Key.foregroundColor : UIColor.black])
            startPauseButton.setAttributedTitle(attributedString, for: .normal)

            // 保存运动会话数据到数据库
            let date = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
            let imageData = imageView.image?.jpegData(compressionQuality: 1.0) ?? Data()
            let distance = distanceSlider.value
            let time = initialMinutes * 60 + initialSeconds // 使用初始选择的时间
            saveSportSession(date: date, image: imageData, distance: distance, time: time)

            
            // 播放音频
            if let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.play()
                } catch {
                    print("无法加载音频文件")
                }
            }
        }
    }


   
    
    
    
    @objc func chooseImage() {
        let alertController = UIAlertController(title: "选择图片", message: "请选择一个选项", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "拍摄照片", style: .default) { _ in
            self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "选择本地照片", style: .default) { _ in
            self.openPhotoLibrary()
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("此设备不支持相机")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }

    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("无法访问相册")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }

    
    }
            
            
            
               
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



