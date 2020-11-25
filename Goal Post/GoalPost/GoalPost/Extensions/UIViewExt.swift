//
//  UIViewExt.swift
//  GoalPost
//
//  Created by Muhammad Fakhrulghazi bin Mohd Fouad on 22/11/2020.
//

import UIKit

extension UIView {
    /*add an observer thats going to observe the notification thats sent when the keyboard changes frame. its a default notification ios fires everytime keyboard opens*/
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    /*animate the frame of whatever object we bind the keyboard to so that it moves up with the keyboard in the exact same way*/
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        /*pull out 5 properties from the notification itself; whatever object we bind this to, we gonna pull out some information about the keyboard*/
        /*userinfo is a dictionary and it has bunch of information about the notification that we can access, but its an optional so we have unwrap it and then access the keys*/
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        /* every animation has a curve like ease in or ease out*/
        let curve = notification.userInfo! [UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        /*capture the frame of keyboard below of the screen before it goes up*/
        /*nsvalue is a container for a single c or obj c data item. so we have converted this frame into raw data. and from that raw data we can type .cgrectvalue to convert it into a rectangle*/
        /*cgrect captures it as a rectangle*/
        let StartingFrame = (notification.userInfo! [UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        /*capture the ending frame so that we know how far its gonna go so that we can move up whatever object we want the size of the keyboard*/
        let endingFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        /*subtract how much it moves up in the y-axis*/
        let deltaY = endingFrame.origin.y - StartingFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: KeyframeAnimationOptions.init(rawValue: curve), animations: {self.frame.origin.y += deltaY}, completion: nil)
    }
}
