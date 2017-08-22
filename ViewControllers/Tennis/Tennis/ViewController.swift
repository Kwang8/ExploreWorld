//
//  ViewController.swift
//  Tennis
//
//  Created by Kevin W on 8/19/17.
//  Copyright © 2017 Kevin W. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var a = 0
    var b = 0
    var c = 0
    var d = 0
    var e = 0
    var f = 0
    var g = 0
    var h = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var button2: UIButton!
    @IBOutlet var button1: UIButton!
    @IBAction func Button1(_ sender: Any) {

        button1.setTitle("\(a+1)", for:  .normal)
        a=a+1
    }
    @IBAction func button2(_ sender: Any) {
        
        button2.setTitle("\(b+1)", for:  .normal)
        b=b+1
    }
    @IBOutlet var button3: UIButton!
    @IBAction func button3(_ sender: Any) {
        
        button3.setTitle("\(c+1)", for:  .normal)
        c=c+1
    }

    @IBOutlet var button5: UIButton!
    @IBOutlet var button4: UIButton!
    @IBAction func button4(_ sender: Any) {
        
        button4.setTitle("\(d+1)", for:  .normal)
        d=d+1
    }
    @IBAction func button5(_ sender: Any) {
        
        button5.setTitle("\(e+1)", for:  .normal)
        e=e+1
    }
    @IBOutlet var button7: UIButton!
    @IBOutlet var button6: UIButton!
    @IBAction func button6(_ sender: Any) {
        
        button6.setTitle("\(f+1)", for:  .normal)
        f=f+1
    }
    @IBAction func button7(_ sender: Any) {
        
        button7.setTitle("\(g+1)", for:  .normal)
        g=g+1
    }
    @IBAction func button8(_ sender: Any) {
        
        button8.setTitle("\(h+1)", for:  .normal)
        h=h+1
    }
    @IBOutlet var button8: UIButton!
}

