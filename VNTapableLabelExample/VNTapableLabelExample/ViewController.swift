//
//  ViewController.swift
//  VNTapableLabelExample
//
//  Created by Varun Naharia on 02/08/19.
//  Copyright © 2019 Technaharia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblText: VNTapableLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
            lblText.enableTap(delegate: self)
    }


}

extension ViewController:VNTapableLabelDelegate
{
    func didTapOn(word: String) {
        print("You Tapped On: \(word)")
    }
}
