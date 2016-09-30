//
//  RootViewController.swift
//  BAU AI TicTacToe
//
//  Created by cambaz on 14/11/15.
//  Copyright © 2015 Adnan Gümüş. All rights reserved.
//

import Foundation
import UIKit

class RootViewController : UITableViewController, GameCellDelegate {
    var cellIdentifier = "GameCell"
    
    init(){
        super.init(nibName:nil, bundle:nil)
        self.tableView.bounces = false
        self.tableView.isPagingEnabled = true
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = App.SCREEN_HEIGHT
        self.tableView.register(GameCell.self, forCellReuseIdentifier:cellIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Games.collection.games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! GameCell
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        cell.choices = Games.collection.games[String((indexPath as NSIndexPath).row)]!
        cell.delegate = self
        cell.setupGame()
        return cell
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func changePlayer(){
        let cell:GameCell = self.tableView.visibleCells[0] as! GameCell
        cell.runRobot(-1)
    }
    
    
    func enableInteraction() {
        self.tableView.isUserInteractionEnabled = true
    }
    
    func turnPlayed(){
        
    }
    
    func newGame() {
        self.tableView.reloadData()
        self.tableView.isUserInteractionEnabled = false
//        self.tableView.scrollToRowAtIndexPath(NSIndexPath(index: Games.collection.games.count - 1), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scaleCells(scrollView)
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scaleCells(scrollView)
    }
    
    func scaleCells(_ scrollView:UIScrollView){
        let scrollY = scrollView.contentOffset.y
        
        for cell in self.tableView.visibleCells{
            let row = (self.tableView.indexPath(for: cell) as NSIndexPath?)?.row
            
            let cellY = CGFloat(row!) * App.SCREEN_HEIGHT
            if scrollY - cellY >= -App.SCREEN_HEIGHT && scrollY - cellY < 0{
                let percent = (scrollY - cellY) / -App.SCREEN_HEIGHT
                let scale = 1.0 - (percent / 2.0)
                let offset = percent * -(App.SCREEN_HEIGHT/2.0)
                
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset, 0)
                cell.layer.transform = CATransform3DScale(transform, scale, scale, scale)
                cell.alpha = 1.0 - percent
            }
            

            
            if scrollY - cellY <= App.SCREEN_HEIGHT && scrollY - cellY > 0 {
                let percent = (scrollY - cellY) / App.SCREEN_HEIGHT
                let scale = 1.0 - (percent / 2.0)
                let offset = percent * (App.SCREEN_HEIGHT/2.0)
                
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, offset, 0);
                cell.layer.transform = CATransform3DScale(transform, scale, scale, scale);
                cell.alpha = 1.0 - percent;
            }
            
            if scrollY - cellY == 0{
                let scale:CGFloat = 1.0
                
                let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, 0);
                cell.layer.transform = CATransform3DScale(transform, scale, scale, scale);
                cell.alpha = 1.0;
            }
        }
        
    }
    
}
