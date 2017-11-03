//
//  Global.swift
//  Fleck
//
//  Created by macuser1 on 23/10/2017.
//  Copyright © 2017 Neptune. All rights reserved.
//

import UIKit
import Firebase

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

struct Theme {
    static let chatBubbleOutgoing : UIColor = UIColor(r: 0, g: 136, b: 249)
    static let chatBubbleIncoming : UIColor = UIColor(r: 240, g: 240, b: 240)
    static let loginBackgroundColor : UIColor = UIColor(r: 61, g: 91, b: 151)
    static let UploadImage : UIImage? = UIImage(named: "camera")
}



