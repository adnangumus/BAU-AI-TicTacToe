//
//  Games.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 15/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation
import UIKit

public enum CurrentTurn {
    case Red
    case Green
}

public enum PlayerType {
    case Robot
    case Person
}

public class Games{
    var allGames:Dictionary<String,Dictionary<String,Int>>!
    var turn:CurrentTurn!
    var lastTurn:CurrentTurn!
    var player:PlayerType!
    
    var gameTree:GameState!
    var currentState:GameState!
    
    init (){
       // allGames = Dictionary<String,Dictionary<String,Int>>()
    }
    
    class var collection: Games{
        struct Static{
            static var instance: Games?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token){
            Static.instance = Games()
        }
        return Static.instance!
    }
    
    public var games:Dictionary<String,Dictionary<String,Int>> {
        if allGames == nil {
            self.start()
        }
        return allGames
    }
    
    public func newGame(state:GameState){
//        if lastTurn == CurrentTurn.Red{
//            lastTurn = CurrentTurn.Green
//        }
//        else {
//         lastTurn = CurrentTurn.Red
//        }
        
        turn = CurrentTurn.Red
        allGames = ["0":["1":2,"2":2,"3":2,"4":2,"5":2,"6":2,"7":2,"8":2,"9":2]]
        gameTree = state
        currentState = state
    }
    
    public func playAI()->Int{
        //if currentState.status == GameStateStatus.InPlay{
            let playerAI = currentState.currentPlayer as! PlayerAI
            let bestMove = playerAI.bestMoveForGameState(self.currentState)
            self.currentState = bestMove
            displayNextState(bestMove)
            return bestMove.index
        //}
    }
    
    public func displayNextState(nextState:GameState){
        currentState = nextState
    }
    
    
    public var isTurn:CurrentTurn  {
        get{
            return turn
        }
    }
    
    public var isPlayer:PlayerType  {
        get{
            return player
        }
    }
    
    public func changePlayer(){
        if player == PlayerType.Person{
            player = PlayerType.Robot
        }
        else{
            player = PlayerType.Person
        }
    }
    
    public func placeTurnWithSpot(spot:Int)->UIColor{
        var turnColor:UIColor!
        if turn == CurrentTurn.Green{
            turnColor = App.GREEN_COLOR
        }
        else{
            turnColor = App.RED_COLOR
        }
        allGames["0"]![String(spot)] = turn.hashValue
        
        if turn == CurrentTurn.Red{
            turn = CurrentTurn.Green
        }
        else{
            turn = CurrentTurn.Red
        }
        
        return turnColor
    }
    
    func start(){
        allGames = Dictionary<String, Dictionary<String,Int>>()
        if player == nil{
            player = PlayerType.Robot
            lastTurn = CurrentTurn.Green
        }

        let playerX = PlayerAI(letter: "X")
        let player0 = PlayerAI(letter: "0")
        let state = GameState(playerX: playerX, playerO: player0)
        self.newGame(state)
    }
    
    func checkGame()->Bool{
        var gameFinished = true
        
        var game = allGames["0"]
 
        for key in (game?.keys)! {
            let num = game![key]
            if num == 2 {
                gameFinished = false
            }
        }
        
        //check rows
        if checkWinnerWithSpots([game!["1"]!,game!["2"]!,game!["3"]!]){
            gameFinished = true
        }
        
        if checkWinnerWithSpots([game!["4"]!,game!["5"]!,game!["6"]!]){
            gameFinished = true
        }
        
        if checkWinnerWithSpots([game!["7"]!,game!["8"]!,game!["9"]!]){
            gameFinished = true
        }
        
        //check columns
        if checkWinnerWithSpots([game!["1"]!,game!["4"]!,game!["7"]!]){
            gameFinished = true
        }
        
        if checkWinnerWithSpots([game!["2"]!,game!["5"]!,game!["8"]!]){
            gameFinished = true
        }
        
        if checkWinnerWithSpots([game!["3"]!,game!["6"]!,game!["9"]!]){
            gameFinished = true
        }
        
        //check diagonals
        
        if checkWinnerWithSpots([game!["1"]!,game!["5"]!,game!["9"]!]){
            gameFinished = true
        }
        
        if checkWinnerWithSpots([game!["7"]!,game!["5"]!,game!["3"]!]){
            gameFinished = true
        }
        
        if gameFinished && allGames["0"]!["winner"] == nil{
             allGames["0"]!["winner"] = 2
        }
        
        return gameFinished
    }
    
    func checkWinnerWithSpots(spots:[Int])->Bool{
        var winner = false
        
        if spots[0] == spots[1] && spots[1] == spots[2] && spots[0] != 2{
            winner = true
            allGames["0"]!["winner"] = spots[0]
        }
        return winner
    }

    
}