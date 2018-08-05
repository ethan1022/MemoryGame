//
//  MainViewController.swift
//  MemoryGame
//
//  Created by Ethan on 2018/8/5.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var cardCollectionView: UICollectionView!
    @IBOutlet weak private var timerLabel: UILabel!
    private var timer = Timer()
    private var seconds = 0
    
    let cellIdentifier = "CardCollectionViewCell"
    
    // Data Source
    var cardDataSource: [String] = ["a", "a", "b", "b", "c", "c",
                                    "d", "d", "e", "e", "f", "f",
                                    "g", "g", "h", "h"]
    var selectedCardIndexArray: [Int] = []
    var taskSolvedCount: Int = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentView.layer.cornerRadius = 10
        self.cardDataSource = self.cardDataSource.shuffled()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.runTimer()
    }
    
    // MARK: - Private Methods
    func allSolvedAlert() {
        let alertController = UIAlertController(title: "All tasks have been solved",
                                                message: "Your Score is \(self.timerLabel.text ?? "") !\nDo you want to play again?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.taskSolvedCount = 0
            self.seconds = 0
            self.cardDataSource = self.cardDataSource.shuffled()
            for element in 0..<17 {
                let indexPath = IndexPath.init(item: element, section: 0)
                let item = self.cardCollectionView.cellForItem(at: indexPath)
                item?.isHidden = false
            }
            self.cardCollectionView.reloadData()
            self.runTimer()
        }
        let cancelAction = UIAlertAction(title: "No, I don't want", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func onClickQuitButton(_ sender: Any) {
        self.timer.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Timer
    func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeString), userInfo: nil, repeats: true)
    }
    
    func timeStringWithTimerInterval(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @objc func updateTimeString() {
        self.seconds += 1
        self.timerLabel.text = self.timeStringWithTimerInterval(TimeInterval(self.seconds))
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cardDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! CardCollectionViewCell
        cell.setCardLabel(self.cardDataSource[indexPath.row])
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)  as! CardCollectionViewCell
        self.selectedCardIndexArray.append(indexPath.row)
        cell.showCard(true)
        if self.selectedCardIndexArray.count == 2 {
            let firstCard = self.cardDataSource[self.selectedCardIndexArray[0]]
            let secondCard = self.cardDataSource[self.selectedCardIndexArray[1]]
            let firstCell = collectionView.cellForItem(at: IndexPath.init(item: self.selectedCardIndexArray[0], section: 0))  as! CardCollectionViewCell
            let SecondCell = collectionView.cellForItem(at: IndexPath.init(item: self.selectedCardIndexArray[1], section: 0))  as! CardCollectionViewCell
            collectionView.isUserInteractionEnabled = false
            if firstCard == secondCard {
                self.taskSolvedCount += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    firstCell.isHidden = true
                    SecondCell.isHidden = true
                    collectionView.isUserInteractionEnabled = true
                    if self.taskSolvedCount == 8 {
                        self.timer.invalidate()
                        self.allSolvedAlert()
                    }
                }
                self.selectedCardIndexArray.removeAll()
            } else {
                self.selectedCardIndexArray.removeAll()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    firstCell.showCard(false)
                    SecondCell.showCard(false)
                    collectionView.isUserInteractionEnabled = true
                }
            }
        }
    }
}
