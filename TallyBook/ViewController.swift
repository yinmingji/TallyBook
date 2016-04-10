//
//  ViewController.swift
//  TallyBook
//
//  Created by QianluFan on 3/12/16.
//  Copyright © 2016 YinmingJi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollview
        self.view.backgroundColor = UIColor.whiteColor()
        let calculatorView: CalculatorView = CalculatorView.init(frame: CGRect(x: 0, y: APPH - APPW * 3 / 4, width: APPW, height: APPW * 3 / 4))
        self.view.addSubview(calculatorView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

