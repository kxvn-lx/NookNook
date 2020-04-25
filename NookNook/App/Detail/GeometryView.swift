//
//  GeometryView.swift
//  NookNook
//
//  Created by Kevin Laminto on 25/4/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

class GeometryView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
    }

    override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let h = size.height * 0.85      // adjust the multiplier to taste

        // calculate the 5 points of the pentagon
        let p1 = self.bounds.origin
        let p2 = CGPoint(x:p1.x + size.width, y:p1.y)
        let p3 = CGPoint(x:p2.x, y:p2.y + h)
        let p4 = CGPoint(x:size.width/2, y:size.height)
        let p5 = CGPoint(x:p1.x, y:h)

        // create the path
        let path = UIBezierPath()
        path.move(to: p1)
        path.addLine(to: p2)
        path.addLine(to: p3)
        path.addLine(to: p4)
        path.addLine(to: p5)
        path.close()

        // fill the path
        UIColor(named: ColourUtil.grass2.rawValue)!.withAlphaComponent(1).set()
        path.fill()
    }

}
