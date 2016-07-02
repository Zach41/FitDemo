//
//  ViewController.swift
//  FitDemo
//
//  Created by ZachZhang on 16/7/2.
//  Copyright © 2016年 ZachZhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var labelVIew: SlideLabelView!
    
    @IBOutlet weak var percentabgeLabel: UILabel!
    
    private var tween : Tween!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        labelVIew.text = "Hello, this is a animated label view, try to click animate button, it will animate again"
        
        tween = Tween(object: percentabgeLabel, key: "text", from: 0, to: 75, duration: 0.5)
        tween.mapper = { value in
            if value == 0 {
                return ""
            } else {
                return String(format: "%0.f%%", value)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        labelVIew.animate(0)
    }

    @IBAction func typingAction(sender: UIButton) {
        labelVIew.animate(0)
        tween.start()
    }

}

