//
//  sport.swift
//  Taylor
//
//  Created by mac on 2023/6/20.
//

import UIKit

class sport: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {

    
    @IBOutlet weak var minutesPicker: UIPickerView!
    
    @IBOutlet weak var secondsPicker: UIPickerView!
    
    @IBOutlet weak var startPauseButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    
    // 分钟和秒钟的数组
       var minutes = [Int](0...59)
       var seconds = [Int](0...59)
       
       // 计时器剩余的总秒数
       var totalSeconds = 0
       
       // 计时器
       var timer = Timer()
       
       // 表示计时器是否正在运行的布尔值
       var isRunning = false

       override func viewDidLoad() {
           super.viewDidLoad()
           
           // 设置分钟和秒钟选择器的dataSource和delegate为self
           minutesPicker.dataSource = self
           minutesPicker.delegate = self
           secondsPicker.dataSource = self
           secondsPicker.delegate = self
           
           // 设置初始的计时器剩余时间
           totalSeconds = minutes[minutesPicker.selectedRow(inComponent: 0)]*60 + seconds[secondsPicker.selectedRow(inComponent: 0)]
           timerLabel.text = String(totalSeconds)
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
               // 获取选中的分钟和秒钟，计算总秒数
               totalSeconds = minutes[minutesPicker.selectedRow(inComponent: 0)]*60 + seconds[secondsPicker.selectedRow(inComponent: 0)]
               if totalSeconds > 0 {
                   // 开始计时器
                   isRunning = true
                   startPauseButton.setTitle("暂停", for: .normal)
                   timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
               }
           } else {
               // 暂停计时器
               isRunning = false
               timer.invalidate()
               startPauseButton.setTitle("开始", for: .normal)
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
                        startPauseButton.setTitle("开始", for: .normal)
                    }
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



