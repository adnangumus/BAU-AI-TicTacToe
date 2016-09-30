//
//  GameView.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 12/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation
import UIKit

private protocol GameViewDelegate {
    func didTapTile(tile: Int) -> GameView
}

class GameView: UIView {
    var tiles = Dictionary<Int,UIButton>()
    var horizontalBar1 : UIView!
    var horizontalBar2 : UIView!
    var verticalBar1 : UIView!
    var verticalBar2 : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var temp = Array<UIButton>()
        for var i=0;i<9;++i{
            let tile = UIButton(type: UIButtonType.Custom)
            tile.addTarget(self, action: "tileTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            tile.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            temp.append(tile)
            self.addSubview(tile)
        }
        
        horizontalBar1 = UIView()
        horizontalBar1.backgroundColor = UIColor.blackColor()
        horizontalBar2 = UIView()
        horizontalBar2.backgroundColor = UIColor.blackColor()
        verticalBar1 = UIView()
        verticalBar1.backgroundColor = UIColor.blackColor()
        verticalBar2 = UIView()
        verticalBar2.backgroundColor = UIColor.blackColor()
        
        self.addSubview(horizontalBar1)
        self.addSubview(horizontalBar2)
        self.addSubview(verticalBar1)
        self.addSubview(verticalBar2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let tileWidth = self.bounds.size.width / 3
        
        for var i = 0;i<tiles.count;++i {
            let tile = tiles[i]
            tile!.frame = CGRectMake(tileWidth * CGFloat((i % 3)), tileWidth * CGFloat(i / 3), tileWidth, tileWidth)
        }
        
        horizontalBar1.frame = CGRectMake(0, tileWidth, self.bounds.size.width, 3)
        horizontalBar2.frame = CGRectMake(0, tileWidth * 2, self.bounds.size.width, 3)
        verticalBar1.frame = CGRectMake(tileWidth, 0, 3, self.bounds.size.width)
        verticalBar2.frame = CGRectMake(tileWidth * 2, 0, 3, self.bounds.size.width)
        
    }
    
    func drawGameState(gameState:GameState){
        for var i = 0;i<gameState.state.count;++i {
            if gameState.state[i] != nil{
                let playOnTile = gameState.state[i]
                tiles[i]?.setTitle(playOnTile.letter, forState: UIControlState.Normal)
            }
        }
    }
    
    func reset(){
        for var i = 0;i<tiles.count;++i {
            tiles[i]!.setTitle("", forState: UIControlState.Normal)
        }
    }
    
    
    func tileTapped(sender:UIButton){
        _ = indexOfAccessibilityElement(sender)
        
    }
    
    
    
}