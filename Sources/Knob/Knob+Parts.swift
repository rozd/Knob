//
//  File.swift
//  
//
//  Created by Max Rozdobudko on 8/31/19.
//

#if canImport(UIKit)

import UIKit

// MARK: - Common

extension Knob {

    public func updateControlsIfExist() {

        for case let view as KnobControl in subviews {
            view.update?(self, progress: progress, startAngle: startAngle, endAngle: endAngle)
        }

        for case let layer as KnobControl in layer.sublayers ?? [] {
            layer.update?(self, progress: progress, startAngle: startAngle, endAngle: endAngle)
        }

    }

}

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

// MARK: - Dial View

extension Knob {

    internal func createDefaultDialView() -> DefaultKnobDial {
        let dial = DefaultKnobDial()
        dial.isUserInteractionEnabled = false
        return dial
    }

    internal func updateDialView() {
        refreshMarkersIfNeeded()
    }

    internal func layoutDialView() {
        layoutMarkersIfNeeded()
    }

}

// MARK: - Markers

extension Knob {

    internal func createMarker(at index: Int) -> UIView {
        return self.dataSource?.knob?(self, viewForMarkerAt: index) ?? createDefaultMarker(at: index)
    }

    internal func createDefaultMarker(at index: Int) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.frame = CGRect(origin: .zero, size: CGSize(width: Default.markerSize, height: Default.markerSize))
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = Default.markerSize / 2
        return view
    }

    internal func refreshMarkersIfNeeded() {
        guard let dial = dialView as? DefaultKnobDial else {
            return
        }

        guard dial.subviews.count != markerCount else {
            return
        }

        for index in 0..<markerCount {
            let marker = createMarker(at: index)
            dial.insertSubview(marker, at: index)
        }
    }

    internal func layoutMarkersIfNeeded() {
        guard let dial = dialView as? DefaultKnobDial else {
            return
        }

        for (index, marker) in dial.subviews.enumerated() {
            let angle = radians(from: self.angle(for: marker, at: index))

            let x = cos(angle)
            let y = sin(angle)

            marker.transform = .identity

            var rect = marker.frame

            let markerOffset = self.offset(for: marker, at: index)

            let radius = (circleRadius - max(trackThikness, fillThikness) / 2) + markerOffset

            let newX = CGFloat(x) * radius + circleCenter.x
            let newY = CGFloat(y) * radius + circleCenter.y

            rect.origin.x = newX - marker.frame.width / 2
            rect.origin.y = newY - marker.frame.height / 2

            marker.frame = rect

            marker.transform = transform(for: marker, at: index, positionedBy: angle)
        }
    }

    internal func offset(for marker: UIView, at index: Int) -> CGFloat {
        return self.dataSource?.knob?(self, offsetForMarkerAt: index) ?? markerOffset
    }

    internal func angle(for marker: UIView, at index: Int) -> Float {
        let percentage: Float = ((100.0 / Float(markerCount - 1)) * Float(index)) / 100.0

        return startAngle + (endAngle - startAngle) * percentage
    }

    internal func transform(for marker: UIView, at index: Int, positionedBy angle: CGFloat) -> CGAffineTransform {
        return self.dataSource?.knob?(self, transformForMarkerAt: index) ?? CGAffineTransform(rotationAngle: angle)
    }
}

#endif
