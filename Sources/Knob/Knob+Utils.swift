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

    public var circleCenter: CGPoint {
        return CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }

    public var circleSize: CGFloat {
        return min(self.bounds.width, self.bounds.height)
    }

    public var circleRadius: CGFloat {
        return circleSize * 0.5
    }

    public var thumbRadius: CGFloat {
        guard let thumb = thumbView else {
            return .zero
        }
        return min(thumb.frame.width, thumb.frame.height) * 0.5
    }
}

// MARK: - Geometry Utils

public func radians(from degree: Float) -> CGFloat {
    return radians(from: CGFloat(degree))
}

public func radians(from degree: CGFloat) -> CGFloat {
    return degree * .pi / 180
}

public func degrees(from radian: CGFloat) -> Float {
    return degrees(from: Float(radian))
}

public func degrees(from radian: Float) -> Float {
    return radian * (180 / Float.pi)
}

public func degree(for location: CGPoint, in rect: CGRect) -> Float {
    return degrees(from: radians(for: location, in: rect))
}

public func radians(for location: CGPoint, in rect: CGRect) -> CGFloat {
    let dx = location.x - (rect.size.width * 0.5)
    let dy = location.y - (rect.size.height * 0.5)

    return atan2(dy, dx)
}

public func normalize(degrees orientation: Float) -> Float {
    var orientation = orientation.truncatingRemainder(dividingBy: 360.0)
    if orientation < 0 {
        orientation += 360.0
    }
    return orientation
}

public func normalize(radians orientation: CGFloat) -> CGFloat {
    var orientation = orientation.truncatingRemainder(dividingBy: 2 * .pi)
    if orientation < 0 {
        orientation += 2 * .pi
    }
    return orientation
}

public func limit(degrees angle: Float, from startAngle: Float, endAngle: Float) -> Float {
    return degrees(from: limit(radians: radians(from: angle),
                                   from: radians(from: startAngle),
                                   to: radians(from: endAngle)))
}

public func limit(radians angle: CGFloat, from startAngle: CGFloat, to endAngle: CGFloat) -> CGFloat {
    guard normalize(radians: startAngle) != normalize(radians: endAngle) else {
        return angle
    }

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

public func percentage(degree angle: Float, from startAngle: Float, to endAngle: Float) -> Float {
    var angle = normalize(degrees: angle)

    if endAngle > startAngle {
        return (angle - startAngle) / (endAngle - startAngle)
    } else {
        if angle < startAngle {
            angle += 360
        }
        return (angle - startAngle) / (360 - (startAngle - endAngle))
    }
}

public func degrees(for percentage: Float, from startAngle: Float, to endAngle: Float) -> Float {
    if endAngle > startAngle {
        return startAngle + (endAngle - startAngle) * percentage
    } else {
        return startAngle + (360.0 + endAngle - startAngle) * percentage
    }
}

public func radians(for percentage: CGFloat, from startAngle: CGFloat, to endAngle: CGFloat) -> CGFloat {
    if endAngle > startAngle {
        return startAngle + (endAngle - startAngle) * percentage
    } else {
        return startAngle + (2 * .pi + endAngle - startAngle) * percentage
    }
}

#endif
