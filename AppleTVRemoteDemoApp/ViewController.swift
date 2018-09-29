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
  
  @IBOutlet weak var longPressLabel: UILabel!
  
  @IBOutlet weak var userAccelerationLabel: UILabel!
  @IBOutlet weak var gravityLabel: UILabel!
  
  @IBOutlet weak var panViewConstraintCenterX: NSLayoutConstraint!
  @IBOutlet weak var panViewConstraintCenterY: NSLayoutConstraint!
  
  var originalPanViewCenter: CGPoint?

  
  var controller : GCController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    originalPanViewCenter = CGPoint(x: panViewConstraintCenterX.constant, y: panViewConstraintCenterY.constant)
    addGestureRecognizerWithType(pressType: .select, selector: #selector(selectAction))
    addGestureRecognizerWithType(pressType: .menu, selector: #selector(menu))
    addGestureRecognizerWithType(pressType: .playPause, selector: #selector(playPause))
    addGestureRecognizerWithType(pressType: .upArrow, selector: #selector(upArrow))
    addGestureRecognizerWithType(pressType: .downArrow, selector: #selector(downArrow))
    addGestureRecognizerWithType(pressType: .leftArrow, selector: #selector(leftArrow))
    addGestureRecognizerWithType(pressType: .rightArrow, selector: #selector(ViewController.rightArrow))
    
    // Since the swipe and pan gesture recognizers interfere with each other
    // change this to try either the pan or the swipe
    let setupSwipeInsteadOfPanGestureRecognizer = true

    if (setupSwipeInsteadOfPanGestureRecognizer) {
        addSwipeGestureRecognizerWithType(direction: .right, selector: #selector(swipedRight))
        addSwipeGestureRecognizerWithType(direction: .left, selector: #selector(swipedLeft))
        addSwipeGestureRecognizerWithType(direction: .up, selector: #selector(swipedUp))
        addSwipeGestureRecognizerWithType(direction: .down, selector: #selector(swipedDown))
    } else {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userPanned(panGestureRecognizer:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(controllerDidConnect(note:)),
      name: NSNotification.Name.GCControllerDidConnect,
      object: nil)
    
    let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(longPressGestureRecognizer:)))
    view.addGestureRecognizer(longPressGestureRecognizer)
  }

  // MARK: UILongPressGestureRecognizer

    @objc func longPress(longPressGestureRecognizer : UILongPressGestureRecognizer) {
    switch (longPressGestureRecognizer.state) {
    case .began:
        longPressLabel.textColor = UIColor.red
      break
      
    case .ended:
        longPressLabel.textColor = UIColor.black
      break
      
      default: 
      break
      
    }
  }
  
  // MARK: UIPanGestureRecognizer
  
    @objc func userPanned(panGestureRecognizer : UIPanGestureRecognizer) {
    let translation = panGestureRecognizer.translation(in: self.view)
    print(translation)
    guard let originalCenter = originalPanViewCenter else { return }
    panViewConstraintCenterX.constant = originalCenter.x
    panViewConstraintCenterY.constant = originalCenter.y
    
    if (panGestureRecognizer.state == .changed) {
      panViewConstraintCenterX.constant += translation.x
      panViewConstraintCenterY.constant += translation.y
    }
  }
  
  // MARK: Remote events setup
  
    @objc func controllerDidConnect(note : NSNotification) {
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
  
    @objc func selectAction() {
    flashLabel(label: selectLabel)
  }
  
    @objc func playPause(){
    flashLabel(label: playPauseLabel)
  }
  
    @objc func menu(){
    flashLabel(label: menuLabel)
  }
  
    @objc func upArrow(){
    flashLabel(label: upArrowLabel)
  }
  
    @objc func downArrow(){
    flashLabel(label: downArrowLabel)
  }
  
    @objc func leftArrow(){
    flashLabel(label: leftArrowLabel)
  }
  
    @objc func rightArrow(){
    flashLabel(label: rightArrowLabel)
  }
  
    @objc func swipedRight() {
    flashLabel(label: rightSwipeLabel)
  }
  
    @objc func swipedLeft() {
    flashLabel(label: leftSwipeLabel)
  }
  
    @objc func swipedUp() {
    flashLabel(label: upSwipeLabel)
  }
  
    @objc func swipedDown() {
    flashLabel(label: downSwipeLabel)
  }
  
  //MARK: Helpers
  
  func flashLabel(label : UILabel) {
    UIView.transition(with: label, duration: 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
        label.textColor = UIColor.red
      }) {(completed : Bool) -> Void in
        label.textColor = UIColor.black
    }
  }
  
  func addGestureRecognizerWithType(pressType : UIPress.PressType, selector : Selector) {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: selector)
    tapGestureRecognizer.allowedPressTypes = [NSNumber(value: pressType.rawValue)]
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func addSwipeGestureRecognizerWithType(direction : UISwipeGestureRecognizer.Direction, selector : Selector) {
    let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: selector)
    swipeGestureRecognizer.direction = direction
    view.addGestureRecognizer(swipeGestureRecognizer)
  }

}

