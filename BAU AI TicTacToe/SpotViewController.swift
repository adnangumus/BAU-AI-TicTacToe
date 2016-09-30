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
    func tapSpot(_ spot:Int)
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
    
    override func viewDidAppear(_ animated: Bool) {
        if self.gamePlayed == false{
            self.view.frame = CGRect(x: position.x, y: position.y, width: 0, height: 0)
            
            UIView.animate(withDuration: 0.6, delay: App.RANDOM_01 * 0.5, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions().rawValue) , animations: {
                self.view.frame = CGRect(x: CGFloat((self.position.x - self.radius)),y: CGFloat((self.position.y - self.radius)),width: CGFloat(self.diameter),height: CGFloat(self.diameter))
                }, completion: {(value: Bool) in
            })
        } else {
            self.view.frame = CGRect(x: position.x - radius, y: position.y - radius, width: CGFloat(diameter), height: CGFloat(diameter));
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  self.tapped == true {
            return
        }
        self.view.backgroundColor = Games.collection.placeTurnWithSpot(self.spot)
        self.tapped = true
        self.delegate.tapSpot(self.spot)
    }
    
    func setChoice(_ color:UIColor){
        self.view.backgroundColor = color
    }
}
