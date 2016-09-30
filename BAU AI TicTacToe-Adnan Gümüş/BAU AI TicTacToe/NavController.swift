//
//  NavController.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 14/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation
import UIKit
import Accelerate

class NavController : UINavigationController {
    var lock:UIView!
    var nav:UIView!
    var stats:UIButton!
    var player:UIButton!
    var statsOpen:Bool
    var rVC : RootViewController!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.statsOpen = false
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init (rootViewController:UIViewController){
        statsOpen = false
        super.init(rootViewController: rootViewController)
        self.navigationBar.translucent = true
        self.navigationBarHidden = true
        statsOpen = false
        rVC = rootViewController as! RootViewController
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nav = UIView(frame: CGRectMake(0, 0, App.SCREEN_WIDTH, 60))
        self.view.addSubview(nav)
        player = UIButton(frame: CGRectMake(App.SCREEN_WIDTH - 50, 10, 40, 40))
        player.setBackgroundImage(UIImage(named: "robot"), forState: UIControlState.Normal)
        player.layer.cornerRadius = 20
        player.addTarget(self, action: Selector("changePlayer"), forControlEvents: UIControlEvents.TouchUpInside)
        nav.addSubview(player)
        stats = UIButton(frame: CGRectMake(10, 10, 40, 40))
        stats.setBackgroundImage(UIImage(named: "stats"), forState: UIControlState.Normal)
        stats.layer.cornerRadius = 20
        stats.addTarget(self, action: Selector("showStats"), forControlEvents: UIControlEvents.TouchUpInside)
        nav.addSubview(stats)

    }
    
    func changePlayer(){
        Games.collection.changePlayer()
        
        if Games.collection.isPlayer == PlayerType.Person{
            player.setBackgroundImage(UIImage(named: "person"), forState: UIControlState.Normal)
        }
        else{
            player.setBackgroundImage(UIImage(named: "robot"), forState: UIControlState.Normal)
            rVC.changePlayer()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showStats(){
        if (statsOpen == true) {
            statsOpen = false
            lock.removeFromSuperview()
            return
        }
        
        statsOpen = true
        lock = UIView(frame: CGRectMake(0, 0, App.SCREEN_WIDTH, App.SCREEN_HEIGHT))
        self.view.addSubview(lock)
        
        let statsBar = UIView(frame: CGRectMake(0, 0, App.SCREEN_WIDTH, App.SCREEN_HEIGHT))
        statsBar.clipsToBounds = true
        
        let background = UIImageView(frame: CGRectMake(0, 0, App.SCREEN_WIDTH, App.SCREEN_HEIGHT))
        background.image = self.blurView()
        statsBar.addSubview(background)
        lock.addSubview(statsBar)

        let label = UILabel(frame: CGRectMake(20, (App.SCREEN_HEIGHT / 4) - 25, App.SCREEN_WIDTH - 40, 50))
        label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 50)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor(white: 0.0, alpha: 0.8)
        label.text = "STATS"
        statsBar.addSubview(label)
        
        var red_wins = 0
        var green_wins = 0
        var stalemates = 0
        
        var games:Dictionary<String,Int> = Games.collection.games["0"]!
        if games.count > 9{
            if games["winner"]! == 0{
                red_wins++
            }
            if games["winner"] == 1{
                green_wins++
            }
            if games["winner"] == 2{
                stalemates++
            }
        }

        
        // greens label
        let greens = UILabel(frame: CGRectMake((App.SCREEN_WIDTH - 260) / 2, (App.SCREEN_HEIGHT - 80) / 2, 80, 80))
        
        greens.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        greens.adjustsFontSizeToFitWidth = true
        greens.textAlignment = NSTextAlignment.Center
        greens.textColor = UIColor.whiteColor()
        greens.backgroundColor = App.GREEN_COLOR
        greens.text = String(green_wins)
        greens.layer.cornerRadius = 40
        greens.clipsToBounds = true
        statsBar.addSubview(greens)
        
        // reds label
        let reds = UILabel(frame: CGRectMake((App.SCREEN_WIDTH - 80) / 2, (App.SCREEN_HEIGHT - 80) / 2, 80, 80))
        
        reds.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        reds.adjustsFontSizeToFitWidth = true
        reds.textAlignment = NSTextAlignment.Center
        reds.textColor = UIColor.whiteColor()
        reds.backgroundColor = App.RED_COLOR
        reds.text = String(red_wins)
        reds.layer.cornerRadius = 40
        reds.clipsToBounds = true
        statsBar.addSubview(reds)
        
        
        // ties label
        let ties = UILabel(frame: CGRectMake((App.SCREEN_WIDTH + 100) / 2, (App.SCREEN_HEIGHT - 80) / 2, 80, 80))
        
        ties.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        ties.adjustsFontSizeToFitWidth = true
        ties.textAlignment = NSTextAlignment.Center
        ties.textColor = UIColor.whiteColor()
        ties.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        ties.text = String(stalemates)
        ties.layer.cornerRadius = 40
        ties.clipsToBounds = true
        statsBar.addSubview(ties)
        
        // play again button
        
        let closeStats = UIButton(frame: CGRectMake(10, 10, 40, 40))
        closeStats.addTarget(self, action: Selector("closeStats"), forControlEvents: UIControlEvents.TouchUpInside)
        closeStats.setBackgroundImage(UIImage(named: "close"), forState: UIControlState.Normal)
        closeStats.titleLabel!.font = UIFont(name: "HelveticaNeue-UltraLight", size: 50)
        closeStats.titleLabel!.textColor = UIColor(white: 0.0, alpha: 0.8)
        lock.addSubview(closeStats)
    }
    
    func closeStats(){
        lock.removeFromSuperview()
        statsOpen = false
    }
    
    func blurView()->UIImage{
        UIGraphicsBeginImageContext(self.view.bounds.size)
        
        let context = UIGraphicsGetCurrentContext()
        UIColor.whiteColor().set()
        CGContextFillRect(context, self.view.bounds)
        self.view.layer.renderInContext(context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        var inBuffer = vImage_Buffer(data:CGBitmapContextGetData(context),
            height:UInt(CGBitmapContextGetHeight(context)),
            width:UInt(CGBitmapContextGetWidth(context)),
            rowBytes:CGBitmapContextGetBytesPerRow(context))
        
        UIGraphicsBeginImageContext(self.view.bounds.size)
        let effectOutContext = UIGraphicsGetCurrentContext()
        var outBuffer = vImage_Buffer(data:CGBitmapContextGetData(effectOutContext),
            height:UInt(CGBitmapContextGetHeight(effectOutContext)),
            width:UInt(CGBitmapContextGetWidth(effectOutContext)),
            rowBytes:CGBitmapContextGetBytesPerRow(effectOutContext))
        
        
        let blurRadius:CGFloat = 10.0
        let inputRadius = blurRadius * UIScreen.mainScreen().scale
        var radius = UInt32(floor(inputRadius * CGFloat(3.0) * CGFloat(sqrt(2 * M_PI)) / 4 + 0.5))
        if radius % 2 != 1 {
            radius += 1
        }
        let imageEdgeExtendFlags = vImage_Flags(kvImageEdgeExtend)
        
        vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        vImageBoxConvolve_ARGB8888(&outBuffer, &inBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, nil, 0, 0, radius, radius, nil, imageEdgeExtendFlags)
        
        // add tint
        let tintColor = UIColor(white: 1.0, alpha: 0.7)

        CGContextSaveGState(context)
        CGContextSetFillColorWithColor(context, tintColor.CGColor)
        CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height))
        CGContextRestoreGState(context)
        
        
        let imageRef = CGBitmapContextCreateImage(context)
        let returnImage = UIImage(CGImage: imageRef!)
        
        UIGraphicsEndImageContext()
        UIGraphicsEndImageContext()
        
        
        return returnImage
    }
    
}