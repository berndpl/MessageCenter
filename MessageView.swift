//
//  MessageView.swift
//  Packtag
//
//  Created by Bernd Plontsch on 16/11/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class MessageView: UIView {

    let logSwitch:Bool = false
    
    var backgroundView:UIView!
    var messageTextView:UITextView = UITextView()
    
    var hideBoxTimer:NSTimer?
    var activeMessage:Bool = false
    func tapMessageBox(sender: AnyObject) {
        Logger.log(logSwitch, logMessage: "tap")
        hideMessageBoxWithDuration(duration: 0.2)
    }
    
    var tapGesture:UITapGestureRecognizer?
    
    func hideMessageBox() {
        hideMessageBoxWithDuration()
    }
    
    func hideMessageBoxWithDuration(duration:Double=0.8) {
        hideBoxTimer?.invalidate()
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            Logger.log(self.logSwitch, logMessage: "[Message Box] Animate out ...")
            self.alpha = 0.0
            }) { (complete) -> Void in
                Logger.log(self.logSwitch, logMessage: "[Message Box] Complete \n")
                self.activeMessage = false
                MessageCenter.shared.show()
        }
    }
    
    func showMessage(message:Message) {
        Logger.log(logSwitch, logMessage: "=======SHOW MESSAGE \(message.simpleDescription()) ")
        
        var characterPerSecond:Double = 0.08 //Standard 0.05
        
        let stringToCount = message.messageText.string as String
        var stringCount:Int = countElements(stringToCount)
        var timeToShow:Double = Double(stringCount) * Double(characterPerSecond)
        
        if timeToShow < 3.0 {
            timeToShow = 3.0
        }
        
        if message.extraTimeInSeconds != nil {
            timeToShow += message.extraTimeInSeconds!
        }
        
        Logger.log(logSwitch, logMessage: "stringCount \(stringCount)")
        Logger.log(logSwitch, logMessage: "Calculated Time \(timeToShow)")
        
        messageTextView.text = message.messageText.string
        MessageCenter.shared.removeMessageFromQueue(message)
        activeMessage = true
        self.alpha = 0.0
        self.hidden = false
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            Logger.log(self.logSwitch, logMessage: "[Message Box] Animate in ...")
            self.alpha = 1.0
            }) { (complete) -> Void in
                Logger.log(self.logSwitch, logMessage: "[Message Box] Show complete \n")
        }
        
        hideBoxTimer?.invalidate()
        hideBoxTimer = NSTimer.scheduledTimerWithTimeInterval(timeToShow, target: self, selector: "hideMessageBox", userInfo: nil, repeats: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(backgroundView:UIView) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        tapGesture = UITapGestureRecognizer(target: self, action: "tapMessageBox:")
        addGestureRecognizer(self.tapGesture!)
        
        backgroundColor = UIColor.clearColor()
        messageTextView.backgroundColor = UIColor.clearColor()
        
        setTranslatesAutoresizingMaskIntoConstraints(false)
        
        backgroundView.addSubview(self)
        backgroundView.bringSubviewToFront(self)
        
        backgroundView.addConstraint(NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterX,
            relatedBy: NSLayoutRelation.Equal,
            toItem: backgroundView,
            attribute: NSLayoutAttribute.CenterX,
            multiplier: 1,
            constant: 0))
        
        backgroundView.addConstraint(NSLayoutConstraint(item: self,
            attribute: NSLayoutAttribute.CenterY,
            relatedBy: NSLayoutRelation.Equal,
            toItem: backgroundView,
            attribute: NSLayoutAttribute.CenterY,
            multiplier: 1,
            constant: 0))
        
        var viewsDictionary:NSDictionary  = ["messageView":self]
        backgroundView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[messageView]-0-|", options: nil, metrics: nil, views: viewsDictionary))
        backgroundView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[messageView]-0-|", options: nil, metrics: nil, views: viewsDictionary))
        
        setupLabel()
        
    }
    
    func setupLabel() {
        messageTextView.textAlignment = NSTextAlignment.Center
        messageTextView.editable = false
        messageTextView.font = MessageCenterDefaults.messageFont(20.0)
        messageTextView.textColor = MessageCenterDefaults.lightColor()
        messageTextView.text = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat."
        messageTextView.backgroundColor = UIColor.clearColor()
        addSubview(messageTextView)
        
        messageTextView.setTranslatesAutoresizingMaskIntoConstraints(false)
        var viewsDictionary:NSDictionary  = ["label":messageTextView]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[label]-20-|", options: nil, metrics: nil, views: viewsDictionary))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[label]-20-|", options: nil, metrics: nil, views: viewsDictionary))
    }
    
    func willEnterForeground() {
        Logger.log(logSwitch, logMessage: "=======[Box] FOREGROUND=======")
        hidden = true
    }
    
    func didEnterBackground() {
        Logger.log(logSwitch, logMessage: "=======[Box] BACKGROUND=======")
        hidden = true
    }

}
