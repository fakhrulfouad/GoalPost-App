//
//  GoalCell.swift
//  GoalPost
//
//  Created by Muhammad Fakhrulghazi bin Mohd Fouad on 22/11/2020.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalDescriptionLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    @IBOutlet weak var goalProgressLbl: UILabel!
    @IBOutlet weak var completionView: UIView!

    /* write a function so that when we are instantiating these goal cells we are passing in proper data*/
    
    func configureCell(goal: Goal) {
        /*configure iboutlet now using self*/
        self.goalDescriptionLbl.text = goal.goalDescription
        self.goalTypeLbl.text = goal.goalType
        self.goalProgressLbl.text = String(describing: goal.goalProgress)
        
        if goal.goalProgress == goal.goalCompletionValue {
            self.completionView.isHidden = false
        } else {
            self.completionView.isHidden = true
        }
    }
    
}
