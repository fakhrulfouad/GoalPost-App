//
//  ViewController.swift
//  GoalPost
//
//  Created by Muhammad Fakhrulghazi bin Mohd Fouad on 22/11/2020.
//

import UIKit
import CoreData

//make app delegate accessible for all view controllers as in has core data things
let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var goals: [Goal] = []
    /*{
        didSet {
            tableView.reloadData()
        }
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*set tableview delegate and source so that it knows what its delegate its datasource is from otherwise it does not know where its getting information from*/
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
    }
    
    //need to think about when should we fetch the data. viewdidlaod only called once when the view is originally load. after we presented goalvc, creategoalvc on the top and dismiss them, viewdidload is not called bcs were just presenting a view on top of it and dismissing it.
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
}
    
    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }
    
    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(identifier: "CreateGoalVC") else {
            return }
            presentDetail(createGoalVC)
        }
    }

extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell else { return UITableViewCell() }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.961445272, green: 0.650790751, blue: 0.1328578591, alpha: 1)
        
        return [deleteAction, addAction]
    }
}

        extension GoalsVC {
            func setProgress(atIndexPath indexPath: IndexPath) {
                guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }

                let chosenGoal = goals[indexPath.row]
                
                if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
                    chosenGoal.goalProgress = chosenGoal.goalProgress + 1
                } else {
                    return
                }
                
                do {
                    try managedContext.save()
                    print("Successfully set progress!")
                } catch {
                    debugPrint("Could not set progress: \(error.localizedDescription)")
                }
            }
            
            func removeGoal(atIndexPath indexPath: IndexPath) {
                guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
                
                managedContext.delete(goals[indexPath.row])
                
                do {
                    try managedContext.save()
                    print("Successfully removed goal!")
                } catch {
                    debugPrint("Could not remove: \(error.localizedDescription)")
                }
            }
            
            func fetch(completion: (_ complete: Bool) -> ()) {
                guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
                
                let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
                
                do {
                    goals = try managedContext.fetch(fetchRequest)
                    print("Successfully fetched data.")
                    completion(true)
                } catch {
                    debugPrint("Could not fetch: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
