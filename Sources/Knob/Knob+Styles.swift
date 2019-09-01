//
//  File.swift
//  
//
//  Created by Max Rozdobudko on 8/31/19.
//

#if canImport(UIKit)

import UIKit

extension Knob {

    public struct LayerStyle {
        public var colors: [CGColor]
        public let locations: [NSNumber]?
        public let start: CGPoint
        public let end: CGPoint
        public let lineCap: CAShapeLayerLineCap
        public let lineJoin: CAShapeLayerLineJoin
    }
}

extension Knob.LayerStyle {

    public static func gradient(colors: [UIColor],
                                locations: [Float]? = nil,
                                start: CGPoint = .zero,
                                end: CGPoint = CGPoint(x: 1.0, y: 0.0),
                                lineCap: CAShapeLayerLineCap = .round,
                                lineJoin: CAShapeLayerLineJoin = .round) -> Self {

        return Knob.LayerStyle(colors: colors.map { $0.cgColor } ,
                               locations: locations?.map { NSNumber(value: $0) },
                               start: start,
                               end: end,
                               lineCap: lineCap,
                               lineJoin: lineJoin)
    }

    public static func solid(color: UIColor, lineCap: CAShapeLayerLineCap = .round, lineJoin: CAShapeLayerLineJoin = .round) -> Self {
        return gradient(colors: [color, color], lineCap: lineCap, lineJoin: lineJoin)
    }

    mutating func change(color: UIColor) {
        self.colors = [color.cgColor, color.cgColor]
    }
    
}

extension Knob {

    public enum LayerStyle2 {

        case gradient(colors: [UIColor],
            locations: [Float]? = nil,
            start: CGPoint = .zero,
            end: CGPoint = CGPoint(x: 1.0, y: 0.0),
            lineCap: CAShapeLayerLineCap = .butt,
            lineJoin: CAShapeLayerLineJoin = .miter)

        case solid(color: UIColor,
            lineCap: CAShapeLayerLineCap = .butt,
            lineJoin: CAShapeLayerLineJoin = .miter)
    }
    
}

extension Knob.LayerStyle2 {

    var colors: [CGColor] {
        switch self {
        case .gradient(let style):
            return style.colors.map { $0.cgColor }
        case .solid(let style):
            return [style.color.cgColor, style.color.cgColor]
        }
    }

    var locations: [NSNumber]? {
        switch self {
        case .gradient(let style):
            return style.locations?.map { NSNumber(value: $0) }
        default:
            return nil
        }
    }

    var start: CGPoint {
        switch self {
        case .gradient(let style):
            return style.start
        default:
            return .zero
        }
    }

    var end: CGPoint {
        switch self {
        case .gradient(let style):
            return style.end
        default:
            return CGPoint(x: 1.0, y: 0.0)
        }
    }

    var lineCap: CAShapeLayerLineCap {
        switch self {
        case .gradient(let style):
            return style.lineCap
        case .solid(let style):
        return style.lineCap
        }
    }

    var lineJoin: CAShapeLayerLineJoin {
        switch self {
        case .gradient(let style):
            return style.lineJoin
        case .solid(let style):
            return style.lineJoin
        }
    }

}

#endif
