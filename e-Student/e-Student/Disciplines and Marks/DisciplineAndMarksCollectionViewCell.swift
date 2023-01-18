//
//  DisciplineAndMarksCollectionViewCell.swift
//  e-Student
//
//  Created by Lyubomir on 7.05.22.
//


import UIKit

class DisciplineAndMAarksCollectionViewCell: UICollectionViewCell {

    @IBOutlet var symbolLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(with discipline: DisciplineAndMarks) {
        if discipline.mark == 0.0 {
            symbolLabel.text = "-"
        } else {
            symbolLabel.text = String(discipline.mark)
        }
        
        nameLabel.text = discipline.discname
        descriptionLabel.text = discipline.titul
    }

}
