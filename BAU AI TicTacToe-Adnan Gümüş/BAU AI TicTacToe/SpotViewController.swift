//
//  SpotViewController.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 14/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation
import UIKit

public protocol SpotViewControllerDelegate {
    func tapSpot(spot:Int)
}

class SpotViewController: UIViewController {
    var position : CGPoint!
    var diameter : Int!
    var radius : CGFloat!
    var tapped : Bool!
    var gamePlayed : Bool = false
    var spot : Int!
    var delegate : SpotViewControllerDelegate!
    init (point:CGPoint) {
        super.init(nibName:nil, bundle:nil)
        diameter = 80
        radius = 40.0
        
        self.view.backgroundColor = App.TAN_COLOR
        self.view.alpha = 0.9
        self.view.layer.cornerRadius = radius
        self.gamePlayed = false
        self.tapped = false
        
        position = point
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.gamePlayed == false{
            self.view.frame = CGRectMake(position.x, position.y, 0, 0)
            
            UIView.animateWithDuration(0.6, delay: App.RANDOM_01 * 0.5, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.CurveEaseInOut.rawValue) , animations: {
                self.view.frame = CGRectMake(CGFloat((self.position.x - self.radius)),CGFloat((self.position.y - self.radius)),CGFloat(self.diameter),CGFloat(self.diameter))
                }, completion: {(value: Bool) in
            })
        } else {
            self.view.frame = CGRectMake(position.x - radius, position.y - radius, CGFloat(diameter), CGFloat(diameter));
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if  self.tapped == true {
            return
        }
        self.view.backgroundColor = Games.collection.placeTurnWithSpot(self.spot)
        self.tapped = true
        self.delegate.tapSpot(self.spot)
    }
    
    func setChoice(color:UIColor){
        self.view.backgroundColor = color
    }
}