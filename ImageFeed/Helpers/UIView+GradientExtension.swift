import UIKit


extension UIView {
    
    enum GradientPosition: String {
        case top, center, bottom
    }
    
    func configureGragient(gradient: CAGradientLayer, cornerRadius: CGFloat, size: CGSize, position: GradientPosition) {
        var yOffset = CGFloat()
        switch position {
        case .top:
            yOffset = 0
        case .center:
            yOffset = (self.frame.height - size.height)/2
        case .bottom:
            yOffset = self.frame.height - size.height
        }
        gradient.frame = CGRect(origin: CGPoint(x: 0, y: yOffset), size: size)
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = cornerRadius
        gradient.masksToBounds = true
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locations chgange")
        self.layer.addSublayer(gradient)
    }
    
    
    func removeGradient(gradient: CAGradientLayer){
        gradient.removeFromSuperlayer()
    }
}
