//
//  File.swift
//  
//
//  Created by Max Rozdobudko on 9/1/19.
//

#if canImport(UIKit)

import UIKit

// MARK: - KnobControl protocol

@objc public protocol KnobControl: class {

    @objc
    optional func update(_ knob: Knob, progress: Float)

    @objc
    optional func update(_ knob: Knob, startAngle: Float, endAngle: Float)

}

// MARK: Knob Dial default implementation

open class DefaultKnobDial: UIView {

}

extension DefaultKnobDial: KnobControl {

    open func update(_ knob: Knob, progress: Float) {
    }

    open func update(_ knob: Knob, startAngle: Float, endAngle: Float) {
    }
}

#endif
