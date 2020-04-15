//
//  XKTimerButton.swift
//  Pods-XKTimerButtonSwift_Example
//
//  Created by Nicholas on 2020/4/8.
//

import Foundation
import UIKit

public class XKTimerButton: UIButton {
    
    private var _xkTimerCounting: ((_ leftInterval: Int, _ button: XKTimerButton) -> Void)?
    private var timer: DispatchSourceTimer?
    private var originalTitle: String?
    ///原始设置的时间间隔
    private var settingInterval = 0
    ///当前
    private var timerInterval  = 0
    
    ///倒数时的前缀,默认为 重新获取
    public var countingPrefix: String = "重新获取"
    ///倒数时的后缀,默认为 @""
    public var countingSuffix: String = ""
    ///倒计时状态下文字的颜色 默认为313131 50%
    public var countingTextColor: UIColor = UIColor(red: 49.0/255.0, green: 49.0/255.0, blue: 49.0/255.0, alpha: 1.0)
    ///倒计时状态下背景的颜色 默认为dedede
    public var countingBackgroundColor: UIColor = UIColor(red: 222.0/255.0, green: 222.0/255.0, blue: 222.0/255.0, alpha: 1.0)
    ///倒计时状态下文字的颜色
    public var normalTextColor: UIColor = UIColor.black {
        
        didSet {
            setTitleColor(self.normalTextColor, for: .normal)
        }
    }
    ///倒计时状态下背景的颜色
    public var normalBackgroundColor: UIColor = UIColor.white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initMethod()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initMethod()
    }
    
    ///初始化
    func initMethod() {
        
        xk_setTimerInterval()
        
        if currentTitle == nil || currentTitle! == "Button" || currentTitle! == "button" {
            setTitle("获取验证码", for: .normal)
        }
    }
    
    ///设置时间间隔，默认60秒
    public func xk_setTimerInterval(timerInterval interval: Int = 60) {
        timerInterval   = interval
        settingInterval = interval
    }
    ///倒计时回调
    public func xk_timerCounting(callBack: @escaping (_ leftInterval: Int, _ button: XKTimerButton) -> Void) {
        _xkTimerCounting = callBack
    }
    ///开始倒计时
    public func xk_starCounting() {
        
        originalTitle   = currentTitle
        normalTextColor = currentTitleColor
        if backgroundColor != nil {
            normalBackgroundColor = backgroundColor!
        }
        
        buttonMethod()
    }
    ///按钮方法
    func buttonMethod() {
        guard _xkTimerCounting != nil else {
            return;
        }
        
        resumeTimer()
        setTitleColor(countingTextColor, for: .normal)
        backgroundColor = countingBackgroundColor
        isUserInteractionEnabled = false
    }
    ///开启计时器
    func resumeTimer() {
        
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer?.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.seconds(0))
        timer?.setEventHandler(handler: { [weak self] in
            
            guard let currentSelf = self else {return}
            
            currentSelf.timerMethod()
        })
        timer?.resume()
    }
    ///计时器执行
    func timerMethod() {
        guard _xkTimerCounting != nil else {
            return
        }
        timerInterval -= 1
        
        if timerInterval <= 0 {
            
            _xkTimerCounting!(0, self)
            
            timerInterval = settingInterval
            
            timer?.cancel()
            timer = nil
            
            DispatchQueue.main.async {
                self.setTitle(self.originalTitle, for: .normal)
                self.setTitleColor(self.normalTextColor, for: .normal)
                self.backgroundColor          = self.normalBackgroundColor
                self.isUserInteractionEnabled = true
            }
            
            return
        }
        
        _xkTimerCounting!(timerInterval, self)
        
        DispatchQueue.main.async {
            self.setTitle(self.countingPrefix + "\(String(format: "%02d", self.timerInterval))" + self.countingSuffix, for: .normal)
        }
    }
    
}
