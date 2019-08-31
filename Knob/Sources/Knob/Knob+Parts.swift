//
//  File.swift
//  
//
//  Created by Max Rozdobudko on 8/31/19.
//

#if canImport(UIKit)

import UIKit

// MARK: - Track

extension Knob {

    internal func createDefaultTrackLayer() -> CALayer {
        let layer = CAGradientLayer()
        layer.anchorPoint = .zero
        layer.startPoint = trackLayerStyle.start
        layer.endPoint = trackLayerStyle.end
        layer.colors = trackLayerStyle.colors
        layer.locations = trackLayerStyle.locations
        let mask = CAShapeLayer()
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.red.cgColor
        layer.mask = mask
        return layer
    }

    internal func updateTrackLayer() {
        guard let layer = trackLayer as? CAGradientLayer, let mask = trackLayer.mask as? CAShapeLayer else {
            return
        }

        layer.colors = trackLayerStyle.colors
        layer.locations = trackLayerStyle.locations

        mask.lineCap = trackLayerStyle.lineCap
        mask.lineJoin = trackLayerStyle.lineJoin
        mask.lineWidth = trackThikness
    }

    internal func layoutTrackLayer() {
        guard let layer = trackLayer as? CAGradientLayer, let mask = trackLayer.mask as? CAShapeLayer else {
            return
        }

        layer.frame = bounds

        let startAngle = radians(from: self.startAngle)
        let endAngle = radians(from: self.endAngle)
        let path = UIBezierPath(arcCenter: circleCenter, radius: circleRadius - trackThikness / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        mask.path = path.cgPath
    }

}

// MARK: - Fill

extension Knob {

    internal func createDefaultFillLayer() -> CALayer {
        let layer = CAGradientLayer()
        layer.anchorPoint = .zero
        layer.startPoint = fillLayerStyle.start
        layer.endPoint = fillLayerStyle.end
        layer.colors = fillLayerStyle.colors
        layer.locations = fillLayerStyle.locations
        let mask = CAShapeLayer()
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.red.cgColor
        layer.mask = mask
        return layer
    }

    internal func updateFillLayer() {
        guard let layer = fillLayer as? CAGradientLayer, let mask = fillLayer.mask as? CAShapeLayer else {
            return
        }

        layer.colors = fillLayerStyle.colors
        layer.locations = fillLayerStyle.locations

        mask.lineCap = fillLayerStyle.lineCap
        mask.lineJoin = fillLayerStyle.lineJoin
        mask.lineWidth = fillThikness
    }

    internal func layoutFillLayer() {
        guard let layer = fillLayer as? CAGradientLayer, let mask = fillLayer.mask as? CAShapeLayer else {
            return
        }

        layer.frame = bounds

        let startAngle = radians(from: self.startAngle)
        let endAngle = radians(from: self.currentAngle)
        let path = UIBezierPath(arcCenter: circleCenter, radius: circleRadius - fillThikness / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        mask.path = path.cgPath
    }

}

// MARK: - Thumb View

extension Knob {

    internal func createDefaultThumbView() -> UIView {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.frame = CGRect(origin: .zero, size: thumbSize)
        button.backgroundColor = thumbColor
        button.layer.cornerRadius = min(thumbSize.width, thumbSize.height) / 2
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 3.0
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        return button
    }

    internal func updateThumbView() {
        if let color = thumbColor {
            thumbView?.backgroundColor = color
        }
    }

    internal func layoutThumbView() {
        let angle = radians(from: currentAngle)

        let x = cos(angle)
        let y = sin(angle)

        var rect = thumbView.frame

        let radius = (circleRadius - max(trackThikness, fillThikness) / 2)

        let newX = CGFloat(x) * radius + circleCenter.x
        let newY = CGFloat(y) * radius + circleCenter.y

        rect.origin.x = newX - thumbRadius
        rect.origin.y = newY - thumbRadius

        thumbView.frame = rect
    }

}
#endif
