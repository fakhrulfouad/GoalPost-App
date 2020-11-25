//
//  UIViewControllerExt.swift
//  GoalPost
//
//  Created by Muhammad Fakhrulghazi bin Mohd Fouad on 22/11/2020.
//

import UIKit

extension UIViewController {
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        /*subtype telling it where to come from*/
        transition.subtype = CATransitionSubtype.fromRight
        /*set the layer of whatever VC we are dealing with to have the transition yang kita dah add. Key use key yang catransition bagi, an identifier that represents a transition animation */
        self.view.window?.layer.add(transition, forKey: kCATransition)
        /*animated must be false because otherwise dia pop up from bottom like default animation. Completion is nil bcs we dont care when its finished*/
        //present(viewControllerToPresent, animated: false, completion: nil)
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewControllerToPresent)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: false, completion: nil)
    }
    
    func presentSecondaryDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        
        guard let presentedViewController = presentedViewController else { return }
        //dismiss current vc and present the new one
        presentedViewController.dismiss(animated: false) {
            self.view.window?.layer.add(transition, forKey: kCATransition)
            //self.present(viewControllerToPresent, animated: false, completion: nil)
            let navigationController: UINavigationController = UINavigationController(rootViewController: viewControllerToPresent)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: false, completion: nil)
        }
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
}

