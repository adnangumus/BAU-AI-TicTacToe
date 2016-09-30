//
//  PlayerAI.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 12/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation

public class PlayerAI : Player{
    
    override init(letter:String){
        super.init(letter: letter)
    }
    
    func bestMoveForGameState(state:GameState) -> GameState{
        if state.isNewGame{
            let i = Int(arc4random_uniform(9))
            state.index = i
            return state.performMove(i)
        }
        
        var bestMove:GameState = GameState()
        var bestRank = -99
        
        for (index,move) in state.moves {
            let rank = self.minMaxForGameState(move)
            if rank > bestRank{
                bestMove = move
                bestRank = rank
                bestMove.index = index
            }
        }
        
        return bestMove
    }
    
    func minMaxForGameState(state:GameState) -> Int{
        if state.status != GameStateStatus.InPlay{
            return self.rankForGameState(state)
        }
        
        var ranks = [Int]()
        
        for (_,move) in state.moves {
            let rank = self.minMaxForGameState(move)
            ranks.append(rank)
        }
        
        var bestRank = ranks.first
        for rank in ranks{
            let currentRank = rank
            if self === state.currentPlayer{
                if currentRank > bestRank{
                    bestRank = currentRank
                }
            }
            else{
                if currentRank < bestRank{
                    bestRank = currentRank
                }
            }
        }
        return bestRank!
    }
    
    func rankForGameState(state:GameState) -> Int{
        switch (state.status){
        case GameStateStatus.Draw:
            return 0
        case GameStateStatus.PlayerXWon:
            return self === state.playerX ? 10 : -10
        case GameStateStatus.PlayerOWon:
            return self === state.playerO ? 10 : -10
        default :
            return 0
        }
    }
    
}