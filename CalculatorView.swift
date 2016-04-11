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
    
    var outputBGView: UIView = UIView()
    var timeLabel:UILabel = UILabel()
    var tallyIcon: UIImageView = UIImageView()
    var tallyTitle: UILabel = UILabel()
    var displayView: UILabel = UILabel()
    var inputBGView: UIView = UIView()

    // MARK: Init
    override init(frame: CGRect) {
        //调用父类初始化方法
        super.init(frame: frame)
        //获取基本尺寸
        let width = frame.size.width
        let height = frame.size.height
        let unitWidth = (width - 3) / 4.0
        let unitHeight = (height - 3 - TimeLabelHeight / 2) / 5.0
        
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
        outputBGView.addSubview(displayView)
        
        //输入板块的背景view
        inputBGView.frame = CGRect(x: 0, y: outputBGView.frame.size.height + outputBGView.frame.origin.y, width: width, height: height - (outputBGView.frame.size.height + outputBGView.frame.origin.y))
        inputBGView.backgroundColor = UIColor.whiteColor()
        self.addSubview(inputBGView)
        
        //建立1-9这9个数字键
        for i in 0...8 {
            let digitalButton:UIButton = UIButton.init(type: UIButtonType.Custom)
            digitalButton.frame = CGRect(x: (CGFloat(i % 3) * (unitWidth + 1)), y: CGFloat(i / 3) * (unitHeight + 1), width: unitWidth, height: unitHeight)
            digitalButton.backgroundColor = Tool.colorwithHexString("ebebeb")
            digitalButton.tag = i + 1
            digitalButton.setTitle("\(i + 1)", forState: UIControlState.Normal)
            digitalButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
            digitalButton.titleLabel?.font = UIFont.systemFontOfSize(26)
            digitalButton.titleLabel?.textAlignment = NSTextAlignment.Center
            inputBGView.addSubview(digitalButton)
        }
        
        //分别计算最后一列的宽度和最后一行的高度
        let lastColoumnWidth = width - 3 * (unitWidth + 1)
        let lastRowHeight = inputBGView.frame.size.height - 3 * (unitHeight + 1)
        
        //收支转换按键
        let attributedString = NSMutableAttributedString(string: "支/收")
        attributedString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20), NSForegroundColorAttributeName: Tool.colorwithHexString("cfd299")], range:NSMakeRange(0, 1))
        attributedString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(20), NSForegroundColorAttributeName: Tool.colorwithHexString("bababa")], range: NSMakeRange(1, 1))
        attributedString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(16), NSForegroundColorAttributeName: Tool.colorwithHexString("e8cd8a")], range: NSMakeRange(2, 1))
        let switchButton: UIButton = UIButton()
        switchButton.backgroundColor = Tool.colorwithHexString("ebebeb")
        switchButton.frame = CGRect(x: width - lastColoumnWidth, y: 0, width: lastColoumnWidth, height: unitHeight)
        switchButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
        inputBGView.addSubview(switchButton)

        //“加”按键
        let addButton: UIButton = UIButton()
        addButton.backgroundColor = Tool.colorwithHexString("ebebeb")
        addButton.frame = CGRect(x: switchButton.frame.origin.x, y: unitHeight + 1, width: lastColoumnWidth, height: unitHeight)
        addButton.setTitle("+", forState: UIControlState.Normal)
        addButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
        addButton.titleLabel?.textAlignment = NSTextAlignment.Center
        addButton.titleLabel?.font = UIFont.systemFontOfSize(26)
        inputBGView.addSubview(addButton)
        
        //"确定"按键
        let okButton: UIButton = UIButton()
        okButton.backgroundColor = Tool.colorwithHexString("ebebeb")
        okButton.frame = CGRect(x: switchButton.frame.origin.x, y: 2 * (unitHeight + 1), width: lastColoumnWidth, height: lastRowHeight + unitHeight + 1)
        okButton.setTitle("OK", forState: UIControlState.Normal)
        okButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
        okButton.titleLabel?.textAlignment = NSTextAlignment.Center
        okButton.titleLabel?.font = UIFont.systemFontOfSize(22)
        inputBGView.addSubview(okButton)
        
        //清零按键
        let clearButton: UIButton = UIButton()
        clearButton.backgroundColor = Tool.colorwithHexString("ebebeb")
        clearButton.frame = CGRect(x: 0, y: inputBGView.frame.size.height - lastRowHeight, width: unitWidth, height: lastRowHeight)
        clearButton.setTitle("清零", forState: UIControlState.Normal)
        clearButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
        clearButton.titleLabel?.textAlignment = NSTextAlignment.Center
        clearButton.titleLabel?.font = UIFont.systemFontOfSize(20)
        inputBGView.addSubview(clearButton)
        
        //数字“0”按键
        let zeroButton: UIButton = UIButton()
        zeroButton.backgroundColor = Tool.colorwithHexString("ebebeb")
        zeroButton.frame = CGRect(x: unitWidth + 1, y: clearButton.frame.origin.y, width: unitWidth, height: lastRowHeight)
        zeroButton.setTitle("0", forState: UIControlState.Normal)
        zeroButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
        zeroButton.titleLabel?.textAlignment = NSTextAlignment.Center
        zeroButton.titleLabel?.font = UIFont.systemFontOfSize(26)
        inputBGView.addSubview(zeroButton)
        
        //小数点按键
        let dotButton: UIButton = UIButton()
        dotButton.backgroundColor = Tool.colorwithHexString("ebebeb")
        dotButton.frame = CGRect(x: (unitWidth + 1) * 2, y: clearButton.frame.origin.y, width: unitWidth, height: lastRowHeight)
        dotButton.setTitle(".", forState: UIControlState.Normal)
        dotButton.setTitleColor(Tool.colorwithHexString("494949"), forState: UIControlState.Normal)
        dotButton.titleLabel?.textAlignment = NSTextAlignment.Center
        dotButton.titleLabel?.font = UIFont.systemFontOfSize(26)
        inputBGView.addSubview(dotButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
