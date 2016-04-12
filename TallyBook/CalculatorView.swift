//
//  CalculatorView.swift
//  SwiftTest
//
//  Created by yinmingji on 16/4/8.
//  Copyright © 2016年 yinmingji. All rights reserved.
//

import UIKit

class CalculatorView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    // MARK: Properties
    let TimeLabelHeight:CGFloat = 18
    
    //收支转换的属性字符串
    let expenseString = NSMutableAttributedString(string: "支/收")
    let incomeString = NSMutableAttributedString(string: "收/支")
    
    var outputBGView: UIView = UIView()
    var timeLabel:UILabel = UILabel()
    var tallyIcon: UIImageView = UIImageView()
    var tallyTitle: UILabel = UILabel()
    var displayView: UILabel = UILabel()
    var inputBGView: UIView = UIView()
    var okButton: UIButton = UIButton()
    
    var unitWidth: CGFloat = 0.0
    var unitHeight: CGFloat = 0.0
    
    
    var showNumber: UInt64 = 0
    var isTapDot: Bool = false
    var decimalPlaces: UInt = 0
    var isTapAdd: Bool = false
    var addedNumber: UInt64 = 0
    var isTapEqual: Bool = false

    // MARK: Init
    override init(frame: CGRect) {
        //调用父类初始化方法
        super.init(frame: frame)
        //获取基本尺寸
        let width = frame.size.width
        let height = frame.size.height
        unitWidth = (width - 3) / 4.0
        unitHeight = (height - 3 - TimeLabelHeight / 2) / 5.0
        
        //设置view本身的一些基本属性
        self.backgroundColor = UIColor.whiteColor()
        
        //输出显示栏背景View
        outputBGView.frame = CGRect(x: 0, y: TimeLabelHeight / 2, width: width, height: unitHeight)
        outputBGView.backgroundColor = UIColor.whiteColor()
        self.addSubview(outputBGView)
        
        //计算器顶部的一条线
        let topLine: UIView = UIView()
        topLine.frame = CGRect(x: 0, y: TimeLabelHeight / 2, width: width, height: 1)
        topLine.backgroundColor = Tool.colorwithHexString("eaeaea")
        self.addSubview(topLine)
        
        //计算器顶部的时间label
        let currentDate: NSDate = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyyy年MM月dd日"
        let currentTime = timeFormatter.stringFromDate(currentDate) as String
        timeLabel.text = currentTime
        timeLabel.frame = CGRect(x: 0, y: 0, width: unitWidth + TimeLabelHeight, height: TimeLabelHeight)
        timeLabel.center = CGPoint(x: self.center.x, y: timeLabel.center.y)
        timeLabel.font = UIFont.systemFontOfSize(14)
        timeLabel.textAlignment = NSTextAlignment.Center
        timeLabel.textColor = Tool.colorwithHexString("ababab")
        timeLabel.backgroundColor = UIColor.whiteColor()
        timeLabel.layer.borderWidth = 1;
        timeLabel.layer.borderColor = Tool.colorwithHexString("eaeaea").CGColor
        timeLabel.layer.cornerRadius = TimeLabelHeight / 2
        self.addSubview(timeLabel)
        
        //记账类型图标
        tallyIcon.frame = CGRect(x: 0, y: 0, width: unitWidth * 0.5, height: unitHeight)
        let iconCenter: CGPoint = tallyIcon.center
        let iconWidth: CGFloat = (tallyIcon.frame.size.width < tallyIcon.frame.size.height ? tallyIcon.frame.size.width : tallyIcon.frame.size.height) - 16
        tallyIcon.frame = CGRect(x: 0, y: 0, width: iconWidth, height: iconWidth)
        tallyIcon.center = iconCenter
        tallyIcon.image = UIImage(named: "Meal01")
        tallyIcon.layer.cornerRadius = tallyIcon.frame.size.height / 2
        tallyIcon.layer.masksToBounds = true
        outputBGView.addSubview(tallyIcon)
        
        //记账类型标题
        tallyTitle.frame = CGRect(x: unitWidth * 0.5, y: 0, width: unitWidth, height: unitHeight)
        tallyTitle.textColor = UIColor.blackColor()
        tallyTitle.text = "一般"
        tallyTitle.font = UIFont.systemFontOfSize(16);
        tallyTitle.textAlignment = NSTextAlignment.Left
        outputBGView.addSubview(tallyTitle)
        
        //实时显示数字的label
        displayView.frame = CGRect(x: unitWidth * 1.5, y: 0, width: unitWidth * 2.5, height: unitHeight)
        displayView.text = "￥0.00"
        displayView.font = UIFont.systemFontOfSize(32)
        displayView.textColor = UIColor.blackColor()
        displayView.textAlignment = NSTextAlignment.Right
        displayView.backgroundColor = UIColor.clearColor()
        outputBGView.addSubview(displayView)
        
        //输入板块的背景view
        inputBGView.frame = CGRect(x: 0, y: outputBGView.frame.size.height + outputBGView.frame.origin.y, width: width, height: height - (outputBGView.frame.size.height + outputBGView.frame.origin.y))
        inputBGView.backgroundColor = UIColor.whiteColor()
        self.addSubview(inputBGView)
        
        //建立1-9这9个数字键
        for i in 0...8 {
            let digitalButton:UIButton = UIButton.init(type: UIButtonType.Custom)
            digitalButton.frame = CGRect(x: (CGFloat(i % 3) * (unitWidth + 1)), y: CGFloat(i / 3) * (unitHeight + 1), width: unitWidth, height: unitHeight)
            digitalButton.setBackgroundImage(Tool.createImageWithColor("ebebeb"), forState: .Normal)
            digitalButton.setBackgroundImage(Tool.createImageWithColor("e2e2e2"), forState: .Highlighted)
            digitalButton.tag = i + 1
            digitalButton.setTitle("\(i + 1)", forState: UIControlState.Normal)
            digitalButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
            digitalButton.titleLabel?.font = UIFont.systemFontOfSize(26)
            digitalButton.titleLabel?.textAlignment = NSTextAlignment.Center
            digitalButton.addTarget(self, action: #selector(tapNumber(_:)), forControlEvents: .TouchUpInside)
            inputBGView.addSubview(digitalButton)
        }
        
        //分别计算最后一列的宽度和最后一行的高度
        let lastColoumnWidth = width - 3 * (unitWidth + 1)
        let lastRowHeight = inputBGView.frame.size.height - 3 * (unitHeight + 1)
        
        //收支转换按键
        expenseString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20), NSForegroundColorAttributeName: Tool.colorwithHexString("cfd299")], range:NSMakeRange(0, 1))
        expenseString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20), NSForegroundColorAttributeName: Tool.colorwithHexString("bababa")], range: NSMakeRange(1, 1))
        expenseString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14), NSForegroundColorAttributeName: Tool.colorwithHexString("e8cd8a")], range: NSMakeRange(2, 1))
        incomeString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20), NSForegroundColorAttributeName: Tool.colorwithHexString("e8cd8a")], range:NSMakeRange(0, 1))
        incomeString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20), NSForegroundColorAttributeName: Tool.colorwithHexString("bababa")], range: NSMakeRange(1, 1))
        incomeString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(14), NSForegroundColorAttributeName: Tool.colorwithHexString("cfd299")], range: NSMakeRange(2, 1))
        let switchButton: UIButton = UIButton()
        switchButton.setBackgroundImage(Tool.createImageWithColor("ebebeb"), forState: .Normal)
        switchButton.setBackgroundImage(Tool.createImageWithColor("e2e2e2"), forState: .Highlighted)
        switchButton.frame = CGRect(x: width - lastColoumnWidth, y: 0, width: lastColoumnWidth, height: unitHeight)
        switchButton.setAttributedTitle(expenseString, forState: UIControlState.Normal)
        switchButton.addTarget(self, action: #selector(tapSwitchButton(_:)), forControlEvents: .TouchUpInside)
        inputBGView.addSubview(switchButton)

        //“加”按键
        let addButton: UIButton = UIButton()
        addButton.setBackgroundImage(Tool.createImageWithColor("ebebeb"), forState: .Normal)
        addButton.setBackgroundImage(Tool.createImageWithColor("e2e2e2"), forState: .Highlighted)
        addButton.frame = CGRect(x: switchButton.frame.origin.x, y: unitHeight + 1, width: lastColoumnWidth, height: unitHeight)
        addButton.setTitle("+", forState: UIControlState.Normal)
        addButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
        addButton.titleLabel?.textAlignment = NSTextAlignment.Center
        addButton.titleLabel?.font = UIFont.systemFontOfSize(26)
        addButton.addTarget(self, action: #selector(tapAdd), forControlEvents: .TouchUpInside)
        inputBGView.addSubview(addButton)
        
        //"确定"按键
        okButton.setBackgroundImage(Tool.createImageWithColor("ebebeb"), forState: .Normal)
        okButton.setBackgroundImage(Tool.createImageWithColor("e2e2e2"), forState: .Highlighted)
        okButton.frame = CGRect(x: switchButton.frame.origin.x, y: 2 * (unitHeight + 1), width: lastColoumnWidth, height: lastRowHeight + unitHeight + 1)
        okButton.setTitle("OK", forState: UIControlState.Normal)
        okButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
        okButton.titleLabel?.textAlignment = NSTextAlignment.Center
        okButton.titleLabel?.font = UIFont.systemFontOfSize(22)
        okButton.addTarget(self, action: #selector(tapOK), forControlEvents: .TouchUpInside)
        inputBGView.addSubview(okButton)
        
        //清零按键
        let clearButton: UIButton = UIButton()
        clearButton.setBackgroundImage(Tool.createImageWithColor("ebebeb"), forState: .Normal)
        clearButton.setBackgroundImage(Tool.createImageWithColor("e2e2e2"), forState: .Highlighted)
        clearButton.frame = CGRect(x: 0, y: inputBGView.frame.size.height - lastRowHeight, width: unitWidth, height: lastRowHeight)
        clearButton.setTitle("清零", forState: UIControlState.Normal)
        clearButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
        clearButton.titleLabel?.textAlignment = NSTextAlignment.Center
        clearButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        clearButton.addTarget(self, action: #selector(clearNumber), forControlEvents: .TouchUpInside)
        inputBGView.addSubview(clearButton)
        
        //数字“0”按键
        let zeroButton: UIButton = UIButton()
        zeroButton.setBackgroundImage(Tool.createImageWithColor("ebebeb"), forState: .Normal)
        zeroButton.setBackgroundImage(Tool.createImageWithColor("e2e2e2"), forState: .Highlighted)
        zeroButton.frame = CGRect(x: unitWidth + 1, y: clearButton.frame.origin.y, width: unitWidth, height: lastRowHeight)
        zeroButton.setTitle("0", forState: UIControlState.Normal)
        zeroButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
        zeroButton.titleLabel?.textAlignment = NSTextAlignment.Center
        zeroButton.titleLabel?.font = UIFont.systemFontOfSize(26)
        zeroButton.tag = 0
        zeroButton.addTarget(self, action: #selector(tapNumber(_:)), forControlEvents: .TouchUpInside)
        inputBGView.addSubview(zeroButton)
        
        //小数点按键
        let dotButton: UIButton = UIButton()
        dotButton.setBackgroundImage(Tool.createImageWithColor("ebebeb"), forState: .Normal)
        dotButton.setBackgroundImage(Tool.createImageWithColor("e2e2e2"), forState: .Highlighted)
        dotButton.frame = CGRect(x: (unitWidth + 1) * 2, y: clearButton.frame.origin.y, width: unitWidth, height: lastRowHeight)
        dotButton.setTitle(".", forState: UIControlState.Normal)
        dotButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
        dotButton.titleLabel?.textAlignment = NSTextAlignment.Center
        dotButton.titleLabel?.font = UIFont.systemFontOfSize(26)
        dotButton.addTarget(self, action: #selector(tapDot), forControlEvents: .TouchUpInside)
        inputBGView.addSubview(dotButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK Private method
    func tapNumber(button: UIButton) {
        if isTapEqual {
            isTapEqual = false
            showNumber = 0
        }
        if showNumber > UInt64(UINT32_MAX / 100) {
            self.showDigitalNumber()
            return
        }
        
        if isTapDot {
            if decimalPlaces < 2 {
                decimalPlaces += 1
                showNumber = UInt64(button.tag) * UInt64(Tool.expOperation(10, exponent: 2 - decimalPlaces)) + showNumber
            } else {
                unChangedAnimation()
            }
        } else {
            showNumber = UInt64(button.tag) * 100 + showNumber * 10
        }
        self.showDigitalNumber()
    }
    
    func tapDot() {
        isTapDot = true
    }
    
    func showDigitalNumber() {
        let integerNumber: UInt64 = showNumber / 100
        let decimalNumber: UInt64 = showNumber - integerNumber * 100
        
        let showString: String = String(format: "￥%d.%02d", integerNumber, decimalNumber)
        if showString == displayView.text && decimalPlaces == 0 {
            unChangedAnimation()
            return
        }
        
        displayView.text = String(format: "￥%d.%02d", integerNumber, decimalNumber)
    }
    
    func clearNumber() {
        displayView.text = "￥0.00"
        showNumber = 0
        isTapDot = false
        decimalPlaces = 0
        isTapAdd = false
        addedNumber = 0
        okButton.setTitle("OK", forState: .Normal)
    }
    
    func tapSwitchButton(button: UIButton) {
        if button.titleLabel?.attributedText == expenseString {
            button.setAttributedTitle(incomeString, forState: .Normal)
        } else {
            button.setAttributedTitle(expenseString, forState: .Normal)
        }
    }
    
    func tapAdd() {
        isTapAdd = true
        isTapDot = false
        isTapEqual = false
        decimalPlaces = 0
        addedNumber = showNumber
        showNumber = 0
        okButton.setTitle("=", forState: .Normal)
    }
    
    func tapOK() {
        if okButton.titleLabel?.text == "=" {
            isTapAdd = false
            isTapDot = false
            isTapEqual = true
            decimalPlaces = 0
            if showNumber > 0 {
                showNumber += addedNumber
            } else {
                showNumber = addedNumber
            }
            showDigitalNumber()
            addedNumber = 0
            okButton.setTitle("OK", forState: .Normal)
        } else {
            
        }
    }
    
    func unChangedAnimation() {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.3
        animation.delegate = self
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        let animationArray: NSMutableArray = NSMutableArray()
        animationArray.addObject(NSValue.init(CATransform3D: CATransform3DMakeTranslation(0, 0, 0)))
        animationArray.addObject(NSValue.init(CATransform3D: CATransform3DMakeTranslation(-0.1 * unitWidth, 0, 0)))
        animationArray.addObject(NSValue.init(CATransform3D: CATransform3DMakeTranslation(0, 0, 0)))
        animationArray.addObject(NSValue.init(CATransform3D: CATransform3DMakeTranslation(4, 0, 0)))
        animationArray.addObject(NSValue.init(CATransform3D: CATransform3DMakeTranslation(0, 0, 0)))
        animation.values = animationArray as [AnyObject]
        self.displayView.layer.addAnimation(animation, forKey: "transform")
    }
}
