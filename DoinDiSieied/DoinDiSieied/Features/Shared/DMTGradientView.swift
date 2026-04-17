import UIKit

final class DMTGradientView: UIView {
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    private var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }

    init(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) {
        super.init(frame: .zero)
        update(colors: colors, startPoint: startPoint, endPoint: endPoint)
    }

    required init?(coder: NSCoder) {
        nil
    }

    func update(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        gradientLayer.colors = colors.map(\.cgColor)
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }
}
