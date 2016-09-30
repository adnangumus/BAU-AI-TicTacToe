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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.statsOpen = false
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init (rootViewController:UIViewController){
        statsOpen = false
        super.init(rootViewController: rootViewController)
        self.navigationBar.isTranslucent = true
        self.isNavigationBarHidden = true
        statsOpen = false
        rVC = rootViewController as! RootViewController
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nav = UIView(frame: CGRect(x: 0, y: 0, width: App.SCREEN_WIDTH, height: 60))
        self.view.addSubview(nav)
        player = UIButton(frame: CGRect(x: App.SCREEN_WIDTH - 50, y: 10, width: 40, height: 40))
        player.setBackgroundImage(UIImage(named: "robot"), for: UIControlState())
        player.layer.cornerRadius = 20
        player.addTarget(self, action: #selector(NavController.changePlayer), for: UIControlEvents.touchUpInside)
        nav.addSubview(player)
        stats = UIButton(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        stats.setBackgroundImage(UIImage(named: "stats"), for: UIControlState())
        stats.layer.cornerRadius = 20
        stats.addTarget(self, action: #selector(NavController.showStats), for: UIControlEvents.touchUpInside)
        nav.addSubview(stats)

    }
    
    func changePlayer(){
        Games.collection.changePlayer()
        
        if Games.collection.isPlayer == PlayerType.person{
            player.setBackgroundImage(UIImage(named: "person"), for: UIControlState())
        }
        else{
            player.setBackgroundImage(UIImage(named: "robot"), for: UIControlState())
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
        lock = UIView(frame: CGRect(x: 0, y: 0, width: App.SCREEN_WIDTH, height: App.SCREEN_HEIGHT))
        self.view.addSubview(lock)
        
        let statsBar = UIView(frame: CGRect(x: 0, y: 0, width: App.SCREEN_WIDTH, height: App.SCREEN_HEIGHT))
        statsBar.clipsToBounds = true
        
        let background = UIImageView(frame: CGRect(x: 0, y: 0, width: App.SCREEN_WIDTH, height: App.SCREEN_HEIGHT))
        background.image = self.blurView()
        statsBar.addSubview(background)
        lock.addSubview(statsBar)

        let label = UILabel(frame: CGRect(x: 20, y: (App.SCREEN_HEIGHT / 4) - 25, width: App.SCREEN_WIDTH - 40, height: 50))
        label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 50)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(white: 0.0, alpha: 0.8)
        label.text = "STATS"
        statsBar.addSubview(label)
        
        var red_wins = 0
        var green_wins = 0
        var stalemates = 0
        
        var games:Dictionary<String,Int> = Games.collection.games["0"]!
        if games.count > 9{
            if games["winner"]! == 0{
                red_wins += 1
            }
            if games["winner"] == 1{
                green_wins += 1
            }
            if games["winner"] == 2{
                stalemates += 1
            }
        }

        
        // greens label
        let greens = UILabel(frame: CGRect(x: (App.SCREEN_WIDTH - 260) / 2, y: (App.SCREEN_HEIGHT - 80) / 2, width: 80, height: 80))
        
        greens.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        greens.adjustsFontSizeToFitWidth = true
        greens.textAlignment = NSTextAlignment.center
        greens.textColor = UIColor.white
        greens.backgroundColor = App.GREEN_COLOR
        greens.text = String(green_wins)
        greens.layer.cornerRadius = 40
        greens.clipsToBounds = true
        statsBar.addSubview(greens)
        
        // reds label
        let reds = UILabel(frame: CGRect(x: (App.SCREEN_WIDTH - 80) / 2, y: (App.SCREEN_HEIGHT - 80) / 2, width: 80, height: 80))
        
        reds.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        reds.adjustsFontSizeToFitWidth = true
        reds.textAlignment = NSTextAlignment.center
        reds.textColor = UIColor.white
        reds.backgroundColor = App.RED_COLOR
        reds.text = String(red_wins)
        reds.layer.cornerRadius = 40
        reds.clipsToBounds = true
        statsBar.addSubview(reds)
        
        
        // ties label
        let ties = UILabel(frame: CGRect(x: (App.SCREEN_WIDTH + 100) / 2, y: (App.SCREEN_HEIGHT - 80) / 2, width: 80, height: 80))
        
        ties.font = UIFont(name: "HelveticaNeue-Thin", size: 30)
        ties.adjustsFontSizeToFitWidth = true
        ties.textAlignment = NSTextAlignment.center
        ties.textColor = UIColor.white
        ties.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        ties.text = String(stalemates)
        ties.layer.cornerRadius = 40
        ties.clipsToBounds = true
        statsBar.addSubview(ties)
        
        // play again button
        
        let closeStats = UIButton(frame: CGRect(x: 10, y: 10, width: 40, height: 40))
        closeStats.addTarget(self, action: #selector(NavController.closeStats), for: UIControlEvents.touchUpInside)
        closeStats.setBackgroundImage(UIImage(named: "close"), for: UIControlState())
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
        UIColor.white.set()
        context?.fill(self.view.bounds)
        self.view.layer.render(in: context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        var inBuffer = vImage_Buffer(data:context?.data,
            height:UInt((context?.height)!),
            width:UInt((context?.width)!),
            rowBytes:(context?.bytesPerRow)!)
        
        UIGraphicsBeginImageContext(self.view.bounds.size)
        let effectOutContext = UIGraphicsGetCurrentContext()
        var outBuffer = vImage_Buffer(data:effectOutContext?.data,
            height:UInt((effectOutContext?.height)!),
            width:UInt((effectOutContext?.width)!),
            rowBytes:(effectOutContext?.bytesPerRow)!)
        
        
        let blurRadius:CGFloat = 10.0
        let inputRadius = blurRadius * UIScreen.main.scale
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

        context?.saveGState()
        context?.setFillColor(tintColor.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!))
        context?.restoreGState()
        
        
        let imageRef = context?.makeImage()
        let returnImage = UIImage(cgImage: imageRef!)
        
        UIGraphicsEndImageContext()
        UIGraphicsEndImageContext()
        
        
        return returnImage
    }
    
}
