//
//  LeftCornerView.swift
//  Woopons
//
//  Created by harsh on 24/11/22.
//

import UIKit

public class LeftCornerView: UIView {

    private let bottomLeftCircle = UIView(frame: .zero)
    private let topLeftCircle = UIView(frame: .zero)

    public var circleY: CGFloat = 0
    public var circleX: CGFloat = 0
    public var circleRadius: CGFloat = 0

    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(bottomLeftCircle)
        addSubview(topLeftCircle)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        clipsToBounds = true
        addSubview(bottomLeftCircle)
        addSubview(topLeftCircle)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        bottomLeftCircle.backgroundColor = superview?.backgroundColor
        bottomLeftCircle.frame = CGRect(x: circleX, y: bounds.height - circleRadius * 2,
                                  width: circleRadius * 2 , height: circleRadius * 2)
        bottomLeftCircle.layer.masksToBounds = true
        bottomLeftCircle.layer.cornerRadius = circleRadius

        topLeftCircle.backgroundColor = superview?.backgroundColor
        topLeftCircle.frame = CGRect(x: circleX, y: circleY,
                                   width: circleRadius * 2 , height: circleRadius * 2)
        topLeftCircle.layer.masksToBounds = true
        topLeftCircle.layer.cornerRadius = circleRadius
    }
}
