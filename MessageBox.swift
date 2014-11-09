
//
//  Created by Bernd Plontsch on 26/09/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class MessageBox: UIViewController, UIGestureRecognizerDelegate {

    let logSwitch:Bool = false
    
    var hideBoxTimer:NSTimer?
    @IBOutlet var messageLabel: UILabel!
    var activeMessage:Bool = false
    
    func tapMessageBox(sender: AnyObject) {
        Logger.log(logSwitch, logMessage: "tap")
        hideMessageBoxWithDuration(duration: 0.2)
    }
    
    var tapGesture:UITapGestureRecognizer?    
    //var message:NSString?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didEnterBackground", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: "tapMessageBox:")
        self.view.addGestureRecognizer(self.tapGesture!)

        messageLabel?.font = UIFont.defaultFontWithSize(DefaultStyle.styleCalculatedLineSize(18.0, referenceView: view))
        //messageLabel?.font = UIFont.defaultFontWithSize(18.0)
        messageLabel?.textColor = UIColor.nextsLightHighlightColor()
        view.backgroundColor = UIColor.clearColor()
        self.view.hidden = true
        Logger.log(logSwitch, logMessage: "Box view did load")
    }
    
    func resetTimer() {
        hideBoxTimer?.invalidate()
        hideBoxTimer = NSTimer.scheduledTimerWithTimeInterval(DefaultStyle.animationHideDelay(), target: self, selector: "hideMessageBox", userInfo: nil, repeats: false)
    }
    
    func willEnterForeground() {
        Logger.log(logSwitch, logMessage: "=======[Box] FOREGROUND=======")
        self.view.hidden = true
    }
    
    func didEnterBackground() {
        Logger.log(logSwitch, logMessage: "=======[Box] BACKGROUND=======")
        self.view.hidden = true
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
        
        Logger.log(logSwitch, logMessage: "stringCount \(stringCount)")
        
        Logger.log(logSwitch, logMessage: "Calculated Time \(timeToShow)")
        
        messageLabel.attributedText = message.messageText
        MessageCenter.shared.removeMessageFromQueue(message)
        activeMessage = true
        self.view.alpha = 0.0
        self.view.hidden = false
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            Logger.log(self.logSwitch, logMessage: "[Message Box] Animate in ...")
            self.view.alpha = 1.0
            }) { (complete) -> Void in
                Logger.log(self.logSwitch, logMessage: "[Message Box] Show complete \n")
        }

        hideBoxTimer?.invalidate()
        hideBoxTimer = NSTimer.scheduledTimerWithTimeInterval(timeToShow, target: self, selector: "hideMessageBox", userInfo: nil, repeats: false)
    }
    
    func hideMessageBox() {
        hideMessageBoxWithDuration()
    }
    
    func hideMessageBoxWithDuration(duration:Double=0.8) {
        hideBoxTimer?.invalidate()
        UIView.animateWithDuration(duration, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            Logger.log(self.logSwitch, logMessage: "[Message Box] Animate out ...")
            self.view.alpha = 0.0
            }) { (complete) -> Void in
                Logger.log(self.logSwitch, logMessage: "[Message Box] Complete \n")
                self.activeMessage = false
                MessageCenter.shared.show()
        }
    }

}
