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
    func didTapTile(_ tile: Int) -> GameView
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
        for _ in (0 ..< 9){
            let tile = UIButton(type: UIButtonType.custom)
            tile.addTarget(self, action: #selector(GameView.tileTapped(_:)), for: UIControlEvents.touchUpInside)
            tile.setTitleColor(UIColor.gray, for: UIControlState())
            temp.append(tile)
            self.addSubview(tile)
        }
        
        horizontalBar1 = UIView()
        horizontalBar1.backgroundColor = UIColor.black
        horizontalBar2 = UIView()
        horizontalBar2.backgroundColor = UIColor.black
        verticalBar1 = UIView()
        verticalBar1.backgroundColor = UIColor.black
        verticalBar2 = UIView()
        verticalBar2.backgroundColor = UIColor.black
        
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
        
        for i in (0 ..< tiles.count) {
            let tile = tiles[i]
            tile!.frame = CGRect(x: tileWidth * CGFloat((i % 3)), y: tileWidth * CGFloat(i / 3), width: tileWidth, height: tileWidth)
        }
        
        horizontalBar1.frame = CGRect(x: 0, y: tileWidth, width: self.bounds.size.width, height: 3)
        horizontalBar2.frame = CGRect(x: 0, y: tileWidth * 2, width: self.bounds.size.width, height: 3)
        verticalBar1.frame = CGRect(x: tileWidth, y: 0, width: 3, height: self.bounds.size.width)
        verticalBar2.frame = CGRect(x: tileWidth * 2, y: 0, width: 3, height: self.bounds.size.width)
        
    }
    
    func drawGameState(_ gameState:GameState){
        for i in (0 ..< gameState.state.count) {
            if gameState.state[i] != nil{
                let playOnTile = gameState.state[i]
                tiles[i]?.setTitle(playOnTile?.letter, for: UIControlState())
            }
        }
    }
    
    func reset(){
        for i in (0 ..< tiles.count) {
            tiles[i]!.setTitle("", for: UIControlState())
        }
    }
    
    
    func tileTapped(_ sender:UIButton){
        _ = index(ofAccessibilityElement: sender)
        
    }
    
    
    
}
