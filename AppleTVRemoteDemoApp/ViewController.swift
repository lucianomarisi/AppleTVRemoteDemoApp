//
//  ViewController.swift
//  AppleTVRemoteDemoApp
//
//  Created by Luciano Marisi on 12/10/2015.
//  Copyright © 2015 TechBrewers LTD. All rights reserved.
//

import UIKit
import GameController

class ViewController: UIViewController {

  
  @IBOutlet weak var selectLabel: UILabel!
  @IBOutlet weak var menuLabel: UILabel!
  @IBOutlet weak var playPauseLabel: UILabel!

  @IBOutlet weak var upArrowLabel: UILabel!
  @IBOutlet weak var downArrowLabel: UILabel!
  @IBOutlet weak var leftArrowLabel: UILabel!
  @IBOutlet weak var rightArrowLabel: UILabel!

  @IBOutlet weak var upSwipeLabel: UILabel!
  @IBOutlet weak var downSwipeLabel: UILabel!
  @IBOutlet weak var leftSwipeLabel: UILabel!
  @IBOutlet weak var rightSwipeLabel: UILabel!
  
  @IBOutlet weak var userAccelerationLabel: UILabel!
  @IBOutlet weak var gravityLabel: UILabel!
  
  var controller : GCController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addGestureRecognizerWithType(UIPressType.Select, selector: "select");
    addGestureRecognizerWithType(UIPressType.Menu, selector: "menu");
    addGestureRecognizerWithType(UIPressType.PlayPause, selector: "playPause");
    addGestureRecognizerWithType(UIPressType.UpArrow, selector: "upArrow");
    addGestureRecognizerWithType(UIPressType.DownArrow, selector: "downArrow");
    addGestureRecognizerWithType(UIPressType.LeftArrow, selector: "leftArrow");
    addGestureRecognizerWithType(UIPressType.RightArrow, selector: "rightArrow");
    
    addSwipeGestureRecognizerWithType(.Right, selector: "swipedRight")
    addSwipeGestureRecognizerWithType(.Left, selector: "swipedLeft")
    addSwipeGestureRecognizerWithType(.Up, selector: "swipedUp")
    addSwipeGestureRecognizerWithType(.Down, selector: "swipedDown")
    
    NSNotificationCenter.defaultCenter().addObserver(
      self,
      selector: "controllerDidConnect:",
      name: GCControllerDidConnectNotification,
      object: nil)
  }
  
  // MARK: Remote events setup
  
  func controllerDidConnect(note : NSNotification) {
    controller = GCController.controllers().first
    controller?.motion?.valueChangedHandler = { (motion : GCMotion) -> () in
      
      let userAccelerationLabelXString = "X = \(String(format: "%.3f", motion.userAcceleration.x))\n"
      let userAccelerationLabelYString = "Y = \(String(format: "%.3f", motion.userAcceleration.y))\n"
      let userAccelerationLabelZString = "Z = \(String(format: "%.3f", motion.userAcceleration.z))"
      self.userAccelerationLabel.text = userAccelerationLabelXString + userAccelerationLabelYString + userAccelerationLabelZString
      
      let gravityXString = "X = \(String(format: "%.3f", motion.gravity.x))\n"
      let gravityYString = "Y = \(String(format: "%.3f", motion.gravity.y))\n"
      let gravityZString = "Z = \(String(format: "%.3f", motion.gravity.z))"
      self.gravityLabel.text = gravityXString + gravityYString + gravityZString
      
    }
  }
  
  // MARK: Tap events
  
  func select(){
    flashLabel(selectLabel)
  }
  
  func playPause(){
    flashLabel(playPauseLabel)
  }
  
  func menu(){
    flashLabel(menuLabel)
  }
  
  func upArrow(){
    flashLabel(upArrowLabel)
  }
  
  func downArrow(){
    flashLabel(downArrowLabel)
  }
  
  func leftArrow(){
    flashLabel(leftArrowLabel)
  }
  
  func rightArrow(){
    flashLabel(rightArrowLabel)
  }
  
  func swipedRight() {
    flashLabel(rightSwipeLabel)
  }
  
  func swipedLeft() {
    flashLabel(leftSwipeLabel)
  }
  
  func swipedUp() {
    flashLabel(upSwipeLabel)
  }
  
  func swipedDown() {
    flashLabel(downSwipeLabel)
  }
  
  //MARK: Helpers
  
  func flashLabel(label : UILabel) {
    UIView.transitionWithView(label, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
      label.textColor = UIColor.redColor()
      }) {(completed : Bool) -> Void in
      label.textColor = UIColor.blackColor()
    }
  }
  
  func addGestureRecognizerWithType(pressType : UIPressType, selector : Selector) {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
    tapGestureRecognizer.allowedPressTypes = [NSNumber(integer: pressType.rawValue)];
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func addSwipeGestureRecognizerWithType(direction : UISwipeGestureRecognizerDirection, selector : Selector) {
    let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: selector)
    swipeGestureRecognizer.direction = direction
    view.addGestureRecognizer(swipeGestureRecognizer)
  }

}

