//
//  CustomMarkersViewController.swift
//  Demo
//
//  Created by Max Rozdobudko on 9/1/19.
//  Copyright © 2019 Max Rozdobudko. All rights reserved.
//

import UIKit
import Knob

class CustomMarkersViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var knob: Knob!

    // MARK: Data

    fileprivate let labels = ["250°", "300°", "350°", "400°", "450°",]

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        knob.dataSource = self

        knob.markerCount = labels.count
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - KnobDelegate

extension CustomMarkersViewController: KnobDataSource {

    func knob(_ knob: Knob, viewForMarkerAt index: Int) -> UIView {
        let label = UILabel()
        label.text = labels[index]
        label.sizeToFit()
        return label
    }

    func knob(_ knob: Knob, transformForMarkerAt index: Int) -> CGAffineTransform {
        return .identity
    }

    func knob(_ knob: Knob, offsetForMarkerAt index: Int) -> CGFloat {
        return 24.0
    }
}
