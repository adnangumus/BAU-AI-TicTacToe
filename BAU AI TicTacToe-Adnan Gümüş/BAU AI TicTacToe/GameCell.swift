//
//  GameCell.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 14/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation
import Accelerate
import UIKit

public protocol GameCellDelegate {
    func turnPlayed()
    func newGame()
    func enableInteraction()
}

public class GameCell : UITableViewCell, SpotViewControllerDelegate {
    var spots : Array<SpotViewController> = Array<SpotViewController>()
    var turn : UILabel!
    var choices : Dictionary<String,Int> = Dictionary<String,Int>()
    var delegate : GameCellDelegate!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = UITableViewCellAccessoryType.None
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupGame(){
        self.frame = CGRectMake(0, 0, App.SCREEN_WIDTH, App.SCREEN_HEIGHT);
        let rows = [[1,2,3],[4,5,6],[7,8,9]]
        let cols = [[1,4,7],[2,5,8],[3,6,9]]
        if spots.count > 0{
            spots.removeAll()
        }
        for (var i = 1; i < 10; i++) {
            var row = 0
            var col = 0
            for r in rows{
                if r.contains(i){
                    row = rows.indexOf({$0 == r})!
                }
            }
            
            for c in cols{
                if c.contains(i){
                    col = cols.indexOf({$0 == c})!
                }
            }
            
            var point = CGPoint(x: 0.0, y: 0.0)
            
            point.x = (App.SCREEN_WIDTH / 2.0) + ((CGFloat(col) - 1.0) * 90.0)
            point.y = (App.SCREEN_HEIGHT / 2.0) + ((CGFloat(row) - 1.0) * 90.0)
            
            let spotVC = SpotViewController(point: point)
            spotVC.spot = i
            spotVC.delegate = self
            spots.append(spotVC)
            let choice = self.choices[i.description]
            
            if choice == 0{
                spotVC.setChoice(UIColor.redColor())
            }
            
            if choice == 1{
                spotVC.setChoice(UIColor.greenColor())
            }
            
            spotVC.gamePlayed = self.gameStarted
            self.contentView.addSubview(spotVC.view)
        }
        
        self.delegate.enableInteraction()
        turn = UILabel(frame: CGRectMake(0, (App.SCREEN_HEIGHT / 2) - 180, App.SCREEN_WIDTH, 30))
        turn.font = UIFont(name: "HelveticaNeue-UltraLight", size: 30)
        turn.adjustsFontSizeToFitWidth = true
        turn.textAlignment = NSTextAlignment.Center
        self.contentView.addSubview(turn)
        if self.choices["winner"] != nil{
            let lock = UIView(frame: CGRectMake(0, 0, App.SCREEN_WIDTH, App.SCREEN_HEIGHT))
            self.contentView.addSubview(lock)
            let winner_num = self.choices["winner"]
            if winner_num == 0{
                turn.text = "RED WON!"
                turn.textColor = App.RED_COLOR
            }
            if winner_num == 1{
                turn.text = "GREEN WON!"
                turn.textColor = App.GREEN_COLOR
            }
            if winner_num == 2{
                turn.text = "STALEMATE"
                turn.textColor = UIColor(white: 0.0, alpha: 0.8)
            }
            
            if self.choices == Games.collection.games["0"]!{
                self.addNew()
            }
        }
        else{
            self.setTurn()
            self.runRobot(-1)
        }
  
        turn.alpha = 0
        
        UIView.animateWithDuration(0.4, delay: 0.2, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.CurveEaseInOut.rawValue) , animations: {
            self.turn.alpha = 1
            }, completion: {(value: Bool) in
        })
    }
    public func runRobot(spot:Int){
        if Games.collection.isPlayer == PlayerType.Robot && Games.collection.isTurn == CurrentTurn.Green{
            
            let lock = UIView(frame: CGRectMake(0, 0, App.SCREEN_WIDTH, App.SCREEN_HEIGHT))
            self.contentView.addSubview(lock)
            
            let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            spinner.backgroundColor = App.GREEN_COLOR
            spinner.frame = CGRectMake((App.SCREEN_WIDTH - 40) / 2, 10, 40, 40)
            spinner.layer.cornerRadius = 20
            spinner.startAnimating()
            lock.addSubview(spinner)
            
            UIView.animateWithDuration(0.4, delay: App.RANDOM_01, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.CurveEaseInOut.rawValue) , animations: {
                lock.alpha = 0
                let choice = Games.collection.playAI()
                let spot = self.spots[choice]
                
                spot.view.backgroundColor = Games.collection.placeTurnWithSpot(choice+1)
                spot.tapped = true
                lock.removeFromSuperview()
                self.tapSpot(choice)
                }, completion: {(value: Bool) in
            })
        }
    }
    
    public func addNew(){
        let button = UIButton(frame: CGRectMake((App.SCREEN_WIDTH - 80) / 2, App.SCREEN_HEIGHT - 100, 80, 80))
        button.setTitle("NEW", forState: UIControlState.Normal)
        button.setTitleColor(UIColor(white: 1.0, alpha: 0.8), forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("newGame"), forControlEvents: UIControlEvents.TouchUpInside)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)
        button.titleLabel?.textColor = UIColor(white: 1.0, alpha: 0.8)
        button.backgroundColor = App.GREEN_COLOR
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        self.contentView.addSubview(button)
    }
    
    public func tapSpot(spot: Int) {
        if Games.collection.checkGame(){
            turn.text=""
            let winner_num = Games.collection.games["0"]!["winner"]
            let lock = UIView(frame: CGRectMake(0, 0, App.SCREEN_WIDTH, App.SCREEN_HEIGHT))
            self.contentView.addSubview(lock)
            let gameBar = UIView(frame: CGRectMake(0, (App.SCREEN_HEIGHT - 200) / 2, App.SCREEN_WIDTH, 200))
            gameBar.clipsToBounds = true
            gameBar.alpha = 0
            let background = UIImageView(frame: CGRectMake(0, (App.SCREEN_HEIGHT - 200) / -2, App.SCREEN_WIDTH, App.SCREEN_HEIGHT))
            background.image = self.blurView()
            gameBar.addSubview(background)
            self.contentView.addSubview(gameBar)
            
            let winner = UILabel(frame: CGRectMake(20, 75, App.SCREEN_WIDTH - 40, 50))
            winner.font = UIFont(name: "HelveticaNeue-UltraLight", size: 50)
            winner.adjustsFontSizeToFitWidth = true
            winner.textAlignment = NSTextAlignment.Center
            winner.textColor = UIColor(white: 1.0, alpha: 0.8)
            gameBar.addSubview(winner)
            self.addNew()
            
            if winner_num == 0{
                winner.text = "RED WINS!"
            }
            
            if winner_num == 1{
                winner.text = "GREEN WINS"
            }
            
            if winner_num == 2{
                winner.text = "DRAW"
                winner.textColor = UIColor(white: 0.0, alpha: 0.8)
            }
            
            UIView.animateWithDuration(0.4, delay: App.RANDOM_01 * 0.5, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.CurveEaseInOut.rawValue) , animations: {
                gameBar.frame = CGRectMake(gameBar.frame.origin.x,gameBar.frame.origin.y,gameBar.frame.size.width,gameBar.frame.size.height)
                gameBar.alpha = 1
                }, completion: {(value: Bool) in
            })
        }
        else{
            if Games.collection.isPlayer == PlayerType.Robot && Games.collection.isTurn == CurrentTurn.Green && spot != -1{
                let nextState = Games.collection.currentState.performMove(spot-1)
                Games.collection.displayNextState(nextState)
            }

            self.setTurn()
            turn.alpha = 0
            UIView.animateWithDuration(0.2, delay: App.RANDOM_01 * 0.5, options: UIViewAnimationOptions(rawValue: UIViewAnimationOptions.CurveEaseInOut.rawValue) , animations: {
                self.turn.frame = CGRectMake(self.turn.frame.origin.x,self.turn.frame.origin.y,self.turn.frame.size.width,self.turn.frame.size.height)
                self.turn.alpha = 1
                }, completion: {(value: Bool) in
            })
            self.runRobot(spot)
        }
        
        self.delegate.turnPlayed()
    }
    
    public var gameStarted:Bool {
        get{
            var gameStarted = false
            
            for key in self.choices.keys{
                let num = self.choices[key]
                if num != 2 {
                    gameStarted = true
                }
            }
            
            return gameStarted;
        }
    }
    
    public func setTurn(){
        if Games.collection.isTurn == CurrentTurn.Red{
            turn.text = "RED'S TURN"
            turn.textColor = App.RED_COLOR
        }
        else{
            turn.text = "GREEN'S TURN!"
            turn.textColor = App.GREEN_COLOR
        }
    }
    
    
    public func newGame(){
        
        //let playerX = PlayerAI(letter: "X")
        //let player0 = PlayerAI(letter: "Y")
        //let state = GameState(playerX: playerX, playerO: player0)
        Games.collection.start()//(state)
        self.delegate.newGame()
    }
    
    func blurView()->UIImage{
        UIGraphicsBeginImageContext(self.bounds.size)
        
        let context = UIGraphicsGetCurrentContext()
        UIColor.whiteColor().set()
        CGContextFillRect(context, self.bounds)
        self.layer.renderInContext(context!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        var inBuffer = vImage_Buffer(data:CGBitmapContextGetData(context),
            height:UInt(CGBitmapContextGetHeight(context)),
            width:UInt(CGBitmapContextGetWidth(context)),
            rowBytes:CGBitmapContextGetBytesPerRow(context))
        
        UIGraphicsBeginImageContext(self.bounds.size)
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
        
        let winner_num = Games.collection.games["0"]!["winner"]
        
        // add tint
        var tintColor = UIColor(white: 1.0, alpha: 0.7)
        if winner_num == 0 {
            tintColor = App.RED_TRANSPARENT
        }
        if winner_num == 1 {
            tintColor = App.GREEN_TRANSPARENT
        }
        
        
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
