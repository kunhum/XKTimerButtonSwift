//
//  ViewController.swift
//  XKTimerButtonSwift
//
//  Created by kunhum on 04/15/2020.
//  Copyright (c) 2020 kunhum. All rights reserved.
//

import UIKit
import XKTimerButtonSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let _ = XKTimerButton(type: .custom)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

