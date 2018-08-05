//
//  CardCollectionViewCell.swift
//  MemoryGame
//
//  Created by Ethan on 2018/8/5.
//  Copyright © 2018年 Ethan. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak private var cardLabel: UILabel!
    @IBOutlet weak private var labelHideView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.borderColor = UIColor.darkText.cgColor
        self.contentView.layer.borderWidth = 0.5
        self.contentView.layer.cornerRadius = 3
        self.contentView.clipsToBounds = true
        
        self.labelHideView.isHidden = false
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.labelHideView.isHidden = false
    }
    
    func setCardLabel(_ text: String) {
        self.cardLabel.text = text
    }
    
    func showCard(_ hidden: Bool) {
        self.labelHideView.isHidden = hidden
    }
    
    
    
}
