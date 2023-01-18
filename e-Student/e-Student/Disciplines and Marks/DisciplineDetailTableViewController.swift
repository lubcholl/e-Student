//
//  DisciplineDetailTableViewController.swift
//  e-Student
//
//  Created by Lyubomir on 7.05.22.
//

import UIKit

class DisciplineDetailTableViewController: UITableViewController {
  
    var discipline: DisciplineAndMarks?

    @IBOutlet weak var discNameLabel: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var teacerLabel: UILabel!
    @IBOutlet weak var planNumberLabel: UILabel!
    @IBOutlet weak var protocolNumerLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if discipline?.mark == 0.0 {
            markLabel.text = "Няма нанесена"
        } else {
            markLabel.text = String(discipline!.mark)
        }
        discNameLabel.text = discipline?.discname
        teacerLabel.text = discipline?.titul
        protocolNumerLabel.text = discipline?.protnumb
        planNumberLabel.text = discipline?.nplan
    }
    
    init?(coder: NSCoder, discipline: DisciplineAndMarks?) {
        self.discipline = discipline
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func containsSingleEmoji(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count == 1 else {
            return false
        }
        
        let isEmoji = text.unicodeScalars.first?.properties.isEmojiPresentation ?? false
        
        return isEmoji
    }
}
