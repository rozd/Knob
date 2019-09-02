//
//  ViewController.swift
//  Demo
//
//  Created by Max Rozdobudko on 8/30/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var knob: DemoKnob!
    @IBOutlet weak var knobWidth: NSLayoutConstraint!
    @IBOutlet weak var progressLabel: UILabel!

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        knob.markerCount = 5
    }

    @IBAction func handleValueChanged(_ sender: Any) {
        progressLabel.text = "\(Int(knob.progress * 100))"
    }
}

