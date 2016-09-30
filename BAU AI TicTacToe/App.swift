//
//  Constants.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 15/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation
import UIKit

struct App {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let TAN_COLOR = UIColor(red: 248/255.0, green: 248/255.0, blue: 240/255.0, alpha: 1.0)
    static let RED_COLOR = UIColor(red: 255/255.0, green: 8/255.0, blue: 79/255.0, alpha: 1.0)
    static let GREEN_COLOR = UIColor(red: 7/255.0, green: 224/255.0, blue: 156/255.0, alpha: 1.0)
    static let RANDOM_01 = (Double(arc4random()) / 0x100000000)

    static let TAN_TRANSPARENT = UIColor(red: 248/255.0, green: 248/255.0, blue: 240/255.0, alpha: 0.7)
    static let RED_TRANSPARENT = UIColor(red: 255/255.0, green: 8/255.0, blue: 79/255.0, alpha: 0.7)
    static let GREEN_TRANSPARENT = UIColor(red: 7/255.0, green: 224/255.0, blue: 156/255.0, alpha: 0.7)
    
    
}
