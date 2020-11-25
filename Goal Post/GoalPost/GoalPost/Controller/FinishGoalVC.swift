//
//  FinishedGoalVC.swift
//  GoalPost
//
//  Created by Muhammad Fakhrulghazi bin Mohd Fouad on 23/11/2020.
//

import UIKit
import CoreData

class FinishGoalVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    
    var goalDescription: String!
    var goalType: GoalType!
    
    func initData(description: String, type: GoalType) {
        self.goalDescription = description
        self.goalType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pointsTextField.delegate = self
        createGoalBtn.bindToKeyboard()

    }

    @IBAction func createGoalBtnWasPressed(_ sender: Any) {
        //Pass data into core data goal model
        if pointsTextField.text != "" {
            self.save {
                (complete) in
                if complete {
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
    //setup a model
    func save(completion: (_ finished: Bool)-> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        /*accessing core data properties*/
        let goal = Goal(context: managedContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTextField.text!)!
        goal.goalProgress = Int32(0)
        
        //using save in order to commit unsaved changes to the context parents store
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Could not save \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pointsTextField.text = ""
    }
}
