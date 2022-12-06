//
//  RightCornerView.swift
//  Woopons
//
//  Created by harsh on 24/11/22.
//

import UIKit

public class RightCornerView: UIView {

    private let bottomRightCircle = UIView(frame: .zero)
    private let topRightCircle = UIView(frame: .zero)

    public var circleY: CGFloat = 0
    public var circleRadius: CGFloat = 0

    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(bottomRightCircle)
        addSubview(topRightCircle)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
        addSubview(bottomRightCircle)
        addSubview(topRightCircle)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        bottomRightCircle.backgroundColor = superview?.backgroundColor
        bottomRightCircle.frame = CGRect(x: bounds.width - circleRadius, y: bounds.height - circleRadius * 2,
                                  width: circleRadius * 2 , height: circleRadius * 2)
        bottomRightCircle.layer.masksToBounds = true
        bottomRightCircle.layer.cornerRadius = circleRadius

        topRightCircle.backgroundColor = superview?.backgroundColor
        topRightCircle.frame = CGRect(x: bounds.width - circleRadius, y: circleY,
                                   width: circleRadius * 2 , height: circleRadius * 2)
        topRightCircle.layer.masksToBounds = true
        topRightCircle.layer.cornerRadius = circleRadius
    }
}
