import UIKit

final class DMTGlowButton: UIButton {
    private let glowLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(glowLayer, at: 0)
        layer.cornerRadius = DMTScale.r(22)
        clipsToBounds = true
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        setTitleColor(.white, for: .normal)
        glowLayer.colors = [DMTPalette.mango.cgColor, DMTPalette.sunrise.cgColor]
        glowLayer.startPoint = CGPoint(x: 0, y: 0.5)
        glowLayer.endPoint = CGPoint(x: 1, y: 0.5)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        glowLayer.frame = bounds
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.45
        }
    }
}
