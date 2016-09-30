//
//  GameState.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 12/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation

public enum GameStateStatus {
    case inPlay
    case playerXWon
    case playerOWon
    case draw
}

open class GameState{
    var playerX : Player!
    var playerO : Player!
    var state : [Player?]
    var currentPlayer : Player!
    var status : GameStateStatus = GameStateStatus.inPlay
    var index:Int!
    init() {
        state = [Player]()
        for _ in (0 ..< 9){
            state.append(nil)
        }
    }
    
    init(playerX:Player,playerO:Player){
        self.currentPlayer = playerX
        self.playerO = playerO
        self.playerX = playerX
        state = [Player]()
        for _ in (0 ..< 9){
            state.append(nil)
        }
    }
    
    init(playerX:Player,playerO:Player,state:[Player?],currentPlayer:PlayerAI){
        self.currentPlayer = currentPlayer
        self.playerO = playerO
        self.playerX = playerX
        self.state = state
        self.status = self.GetStatus
    }
    
    func isPlayerWin(_ player:Player) -> Bool{
        //check Horizontal
        for i in (0 ..< 3) {
            if state[i * 3] === player && state[1 + i * 3] === player && state[2 + i * 3] === player {
                    return true
            }
        }
        //check Vertical
        for i in (0 ..< 3) {
            if state[i] === player && state[i+3] === player && state[i+6] === player {
                return true
            }
        }
        //check Diagonal
        if state[0] === player && state[4] === player && state[8] === player {
                return true
        } else if state[2] === player && state[4] === player && state[6] === player {
                return true
        }
        return false
    }
    
    var canStillMove : Bool{
        get{
            for i in (0 ..< 9) {
                if state[i] == nil  {
                    return true
                }
            }
            return false
        }
    }
    
    var moves: Dictionary<Int,GameState>{
        get{
            var temp = Dictionary<Int,GameState>()
            //if status == GameStateStatus.InPlay{
                for i in (0 ..< state.count){
                    if state[i] == nil  {
                        let nextPlayer = (currentPlayer === playerX ? playerO : playerX) as! PlayerAI
                        var nextState = state as [Player?]
                        nextState[i] = currentPlayer
                        let newState = GameState(playerX: playerX, playerO: playerO, state: nextState, currentPlayer: nextPlayer)
                        temp[i] = newState
                    }
                }
            //}
            return temp
        }
    }
    
    func performMove(_ move:Int) -> GameState{
        let s = self.moves[move]!
        s.index = move
        return s
    }
    
    var isNewGame:Bool {
        get{
            return self.moves.count == 9
        }
        
    }
    
    var GetStatus : GameStateStatus{
        get{
            if isPlayerWin(playerX){
                return GameStateStatus.playerXWon
            }
            else if isPlayerWin(playerO){
                return GameStateStatus.playerOWon
            }
            else if self.canStillMove{
                return GameStateStatus.inPlay
            }
            else{
                return GameStateStatus.draw
            }
        }
    }
}
