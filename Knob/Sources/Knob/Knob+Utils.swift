//
//  File.swift
//  
//
//  Created by Max Rozdobudko on 8/31/19.
//

#if canImport(UIKit)

import UIKit

// MARK: - Layout Helpers

extension Knob {

    internal var circleCenter: CGPoint {
        return CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }

    internal var circleSize: CGFloat {
        return min(self.bounds.width, self.bounds.height)
    }

    internal var circleRadius: CGFloat {
        return circleSize * 0.5
    }

    internal var thumbRadius: CGFloat {
        guard let thumb = thumbView else {
            return .zero
        }
        return min(thumb.frame.width, thumb.frame.height) * 0.5
    }
}

// MARK: - Geometry Utils

extension Knob {

    internal func radians(from degree: Float) -> CGFloat {
        return radians(from: CGFloat(degree))
    }

    internal func radians(from degree: CGFloat) -> CGFloat {
        return degree * .pi / 180
    }

    internal func degrees(from radian: CGFloat) -> Float {
        return degrees(from: Float(radian))
    }

    internal func degrees(from radian: Float) -> Float {
        return radian * (180 / Float.pi)
    }

    internal func degree(for location: CGPoint, in rect: CGRect) -> Float {
        return degrees(from: radians(for: location, in: rect))
    }

    internal func radians(for location: CGPoint, in rect: CGRect) -> CGFloat {
        let dx = location.x - (rect.size.width * 0.5)
        let dy = location.y - (rect.size.height * 0.5)

        return atan2(dy, dx)
    }

    internal func normalize(degrees orientation: Float) -> Float {
        var orientation = orientation.truncatingRemainder(dividingBy: 360.0)
        if orientation < 0 {
            orientation += 360.0
        }
        return orientation
    }

    internal func normalize(radians orientation: CGFloat) -> CGFloat {
        var orientation = orientation.truncatingRemainder(dividingBy: 2 * .pi)
        if orientation < 0 {
            orientation += 2 * .pi
        }
        return orientation
    }

    internal func constrain(radians angle: CGFloat, from startAngle: CGFloat, to endAngle: CGFloat) -> CGFloat {
        func setToNearestLimit(_ angle: CGFloat) -> CGFloat {
            if abs(angle - startAngle) < abs(angle - endAngle) {
                return startAngle
            } else {
                return endAngle
            }
        }

        if startAngle > endAngle {
            if angle < startAngle && angle > endAngle {
                return setToNearestLimit(angle)
            }
        } else {
            if angle < startAngle || angle > endAngle {
                return setToNearestLimit(angle)
            }
        }

        return angle
    }

}

#endif
