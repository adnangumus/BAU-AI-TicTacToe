//
//  Move.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 15/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation
import UIKit

public class Move{
    
    public func animateView(obj:UIView, props:NSDictionary, block: (() -> Void)?){
        
        let duration = props.objectForKey("duration") != nil ? props.objectForKey("duration")?.doubleValue : 0.0
        let delay = props.objectForKey("delay") != nil ? props.objectForKey("delay")?.doubleValue : 0.0
        let alpha = props.objectForKey("alpha") != nil ? props.objectForKey("alpha")?.floatValue : Float(obj.alpha)
        let height = props.objectForKey("height") != nil ? props.objectForKey("height")?.floatValue : Float(obj.frame.size.height)
        let width = props.objectForKey("width") != nil ? props.objectForKey("width")?.floatValue : Float(obj.frame.size.width)
        
        let x = props.objectForKey("x") != nil ? props.objectForKey("x")?.floatValue : Float(obj.frame.origin.x)
        let y = props.objectForKey("y") != nil ? props.objectForKey("y")?.floatValue : Float(obj.frame.origin.y)
        let r = props.objectForKey("remove") != nil ? props.objectForKey("remove")?.boolValue : false
        let animation =  props.objectForKey("animation") != nil ? UInt((props.objectForKey("animation")?.intValue)!) : UIViewAnimationOptions.CurveEaseInOut.rawValue
        
        UIView.animateWithDuration(duration!, delay: delay!, options: UIViewAnimationOptions(rawValue: animation) , animations: {
            obj.frame = CGRectMake(CGFloat(x!),CGFloat(y!),CGFloat(width!),CGFloat(height!))
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