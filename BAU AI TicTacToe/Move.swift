//
//  Move.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 15/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation
import UIKit

open class Move{
    
    open func animateView(_ obj:UIView, props:NSDictionary, block: (() -> Void)?){
        
        let duration = props.object(forKey: "duration") != nil ? (props.object(forKey: "duration") as AnyObject).doubleValue : 0.0
        let delay = props.object(forKey: "delay") != nil ? (props.object(forKey: "delay") as AnyObject).doubleValue : 0.0
        let alpha = props.object(forKey: "alpha") != nil ? (props.object(forKey: "alpha") as AnyObject).floatValue : Float(obj.alpha)
        let height = props.object(forKey: "height") != nil ? (props.object(forKey: "height") as AnyObject).floatValue : Float(obj.frame.size.height)
        let width = props.object(forKey: "width") != nil ? (props.object(forKey: "width") as AnyObject).floatValue : Float(obj.frame.size.width)
        
        let x = props.object(forKey: "x") != nil ? (props.object(forKey: "x") as AnyObject).floatValue : Float(obj.frame.origin.x)
        let y = props.object(forKey: "y") != nil ? (props.object(forKey: "y") as AnyObject).floatValue : Float(obj.frame.origin.y)
        let r = props.object(forKey: "remove") != nil ? (props.object(forKey: "remove") as AnyObject).boolValue : false
        let animation =  props.object(forKey: "animation") != nil ? UInt(((props.object(forKey: "animation") as AnyObject).int32Value)!) : UIViewAnimationOptions().rawValue
        
        UIView.animate(withDuration: duration!, delay: delay!, options: UIViewAnimationOptions(rawValue: animation) , animations: {
            obj.frame = CGRect(x: CGFloat(x!),y: CGFloat(y!),width: CGFloat(width!),height: CGFloat(height!))
            obj.alpha = CGFloat(alpha!)
            }, completion: {(value: Bool) in
                if block != nil {
                   //block(obj)
                }
                if (r != nil){
                   obj.removeFromSuperview()
                }
        })
    }
}
