#if canImport(UIKit)

import UIKit

@objc
public protocol KnobDataSource: class {

    @objc
    optional func knob(_ knob: Knob, viewForMarkerAt index: Int) -> UIView

    @objc
    optional func knob(_ knob: Knob, transformForMarkerAt index: Int) -> CGAffineTransform

    @objc
    optional func knob(_ knob: Knob, offsetForMarkerAt index: Int) -> CGFloat
}

@IBDesignable
open class Knob: UIControl {

    // MARK: - Appearance

    public var untouchableRadius: CGFloat?

    // MARK: Track

    @IBInspectable
    public var trackColor: UIColor? = .lightGray {
        didSet {
            trackLayerStyle.change(color: trackColor ?? Default.trackColor)
        }
    }

    @IBInspectable
    public var trackThikness: CGFloat = 3.0 {
        didSet {
            updateTrackLayer()
        }
    }

    public var trackLayerStyle: LayerStyle = .solid(color: Default.trackColor) {
        didSet {
            updateTrackLayer()
        }
    }

    // MARK: Fill

    @IBInspectable
    public var fillColor: UIColor? = .systemBlue {
        didSet {
            fillLayerStyle.change(color: fillColor ?? Default.fillColor)
        }
    }

    @IBInspectable
    public var fillThikness: CGFloat = 3.0 {
        didSet {
            updateFillLayer()
        }
    }

    public var fillLayerStyle: LayerStyle = .solid(color: Default.fillColor) {
        didSet {
            updateFillLayer()
        }
    }

    // MARK: Thumb

    @IBInspectable
    public var thumbColor: UIColor? = .white {
        didSet {
            updateThumbView()
        }
    }

    @IBInspectable
    public var thumbSize: CGSize = CGSize(width: 26.0, height: 26.0) {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Data

    @IBInspectable
    public var progress: Float = 0.0 {
        didSet {
            setNeedsLayout()
            updateControlsIfExist()
            sendActions(for: .valueChanged)
        }
    }

    @IBInspectable
    public var isContinuous: Bool = true

    @IBInspectable
    public var startAngle: Float = 120.0 {
        didSet {
            updateControlsIfExist()
        }
    }

    @IBInspectable
    public var endAngle: Float = 60.0 {
        didSet {
            updateControlsIfExist()
        }
    }

    @IBInspectable
    open var currentAngle: Float = 120.0 {
        didSet {
            self.progress = percentage(degree: currentAngle, from: startAngle, to: endAngle)
        }
    }

    // MARK: Markers

    @IBInspectable
    public var markerCount: Int = .zero {
        didSet {
            refreshMarkersIfNeeded()
        }
    }

    @IBInspectable
    public var markerOffset: CGFloat = .zero {
        didSet {
            layoutMarkersIfNeeded()
        }
    }

    // MARK: - Delegate

    public weak var dataSource: KnobDataSource?

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Interface Builder

    override public func prepareForInterfaceBuilder() {

    }

    // MARK: - Layers

    open private(set) lazy var trackLayer: CALayer! = {
        let track = createTrackLayer()
        layer.insertSublayer(track, at: 0)
        (track as? KnobControl)?.update?(self, progress: preorder, startAngle: startAngle, endAngle: endAngle)
        return track
    }()

    open private(set) lazy var fillLayer: CALayer! = {
        let fill = createFillLayer()
        layer.insertSublayer(fill, at: 1)
        (fill as? KnobControl)?.update?(self, progress: preorder, startAngle: startAngle, endAngle: endAngle)
        return fill
    }()

    // MARK: - Views

    open private(set) lazy var thumbView: UIView! = {
        let thumb = createThumbView()
        addSubview(thumb)
        (thumb as? KnobControl)?.update?(self, progress: preorder, startAngle: startAngle, endAngle: endAngle)
        return thumb
    }()

    open private(set) lazy var dialView: UIView = {
        let dial = createDialView()
        insertSubview(dial, at: 0)
        (dial as? KnobControl)?.update?(self, progress: preorder, startAngle: startAngle, endAngle: endAngle)
        return dial
    }()

    // MARK: - Layers & Views

    open func createTrackLayer() -> CALayer {
        return createDefaultTrackLayer()
    }

    open func createFillLayer() -> CALayer {
        return createDefaultFillLayer()
    }

    open func createThumbView() -> UIView {
        return createDefaultThumbView()
    }

    open func createDialView() -> UIView {
        return createDefaultDialView()
    }

    // MARK: - Layout

    override open func layoutSubviews() {
        super.layoutSubviews()

        layoutTrackLayer()
        updateTrackLayer()

        layoutFillLayer()
        updateFillLayer()

        layoutThumbView()
        updateThumbView()

        layoutDialView()
        updateDialView()
    }

    // MARK: - Sliding

    internal var _currentAngle: CGFloat = .zero

    open func canSlidingStart(at point: CGPoint) -> Bool {
        guard let untouchableRadius = untouchableRadius else {
            return self.bounds.contains(point) || thumbView?.frame.contains(point) ?? false
        }
        let point = point.applying(CGAffineTransform(translationX: -bounds.width / 2, y: -bounds.height / 2))
        let isPointInsideUntouchableArea = (point.x * point.x + point.y * point.y) < untouchableRadius * untouchableRadius
        return !isPointInsideUntouchableArea
    }

    open func slidingDidStart(at point: CGPoint) {
        _currentAngle = radians(for: point, in: self.bounds)
        if let thumb = thumbView as? UIControl {
            thumb.isHighlighted = true
        }
    }

    open func slidingDidAdvance(to point: CGPoint) -> Bool {

        let startAngle   = radians(from: self.startAngle)
        let endAngle     = radians(from: self.endAngle)

        var angle = radians(for: point, in: self.bounds)

        let originalAngle = degrees(from: angle)

        angle = limit(radians: radians(for: point, in: self.bounds), from: startAngle, to: endAngle)

        let theta = normalize(radians: angle - _currentAngle)

        let halfAngle = (startAngle - endAngle) / 2

        if _currentAngle == endAngle && theta < (.pi + halfAngle) {
            return true
        }

        if _currentAngle == startAngle && theta > (.pi - halfAngle) {
            return true
        }

        _currentAngle = angle

        self.currentAngle = degrees(from: _currentAngle)

        return true
    }

    open func slidingDidFinish(at point: CGPoint?) {
        _currentAngle = .zero
        if let thumb = thumbView as? UIControl {
            thumb.isHighlighted = false
        }
    }

    // MARK: - Touch Events

    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let point = touch.location(in: self)
        guard canSlidingStart(at: point) else {
            return false
        }
        slidingDidStart(at: point)
        return true
    }

    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        return slidingDidAdvance(to: touch.location(in: self))
    }

    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        slidingDidFinish(at: touch?.location(in: self))
    }

}

#endif
