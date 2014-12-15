
//
//  Created by Bernd Plontsch on 20/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class MessageCenter: NSObject {
    
    let logSwitch:Bool = false
    
    var messageQueue:NSMutableArray = NSMutableArray()
    var backgroundView:UIView?
    var messageView:MessageView?
    
    var paused:Bool = false
    
    class var shared : MessageCenter {
        struct Singleton {
            static let instance = MessageCenter()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willEnterForeground", name: UIApplicationWillEnterForegroundNotification, object: nil)
        Logger.log(logSwitch, logMessage: "[MessageQueue] Init")
    }
    
    func willEnterForeground() {
        Logger.log(logSwitch, logMessage: "[MessageQueue] Foreground")
        resume()
    }
    
    func setup (backgroundView:UIView) {
        self.backgroundView = backgroundView
        
        messageView = MessageView(frame: CGRectMake(0, 0, 100, 100))
        messageView?.setup(backgroundView)
        
        reset()
    }
    
    func addMessage(message:Message) {
        Logger.log(logSwitch, logMessage: "[Message] Adding (\(message.simpleDescription())))")
        if isSameMessageInQueueAlready(message) == false {
            messageQueue.addObject(message)
        }
        simpleDescription()
    }
    
    func showMessage(message:Message) {
        addMessage(message)
        if paused == false {
            show()
        }
    }
    
    func resume() {
        paused = false
        Logger.log(logSwitch, logMessage: "[MessageQueue] Resume (Pause \(paused))")
        show()
    }
    
    
    func reset() {
        messageView?.hideMessageBoxWithDuration(duration: 0.1)
        messageQueue.removeAllObjects()
    }
    
    func pause() {
        paused = true
        Logger.log(logSwitch, logMessage: "[MessageQueue] Paused (Pause \(paused))")
    }
    
    func isSameMessageInQueueAlready(message:Message)->Bool {
        for item:AnyObject in messageQueue {
            let messageItem:Message = item as Message
            if messageItem.messageText.isEqualToAttributedString(message.messageText){
                return true
            }
        }
        return false
    }
    
    func show() {
        if messageView == nil {
            println("[MessageCenter] Missing View for Message Box")
        } else {
            Logger.log(logSwitch, logMessage: "[Message] Show Next (\(messageQueue.count))")
            simpleDescription()
            var nextMessage:Message? = messageQueue.firstObject as? Message
            if nextMessage != nil {
                if messageView?.activeMessage == false || messageView?.activeMessage == nil {
                    Logger.log(logSwitch, logMessage: "[Message] Show (\(nextMessage!.simpleDescription()))")
                    messageView?.showMessage(nextMessage!)
                } else {
                    Logger.log(logSwitch, logMessage: "[Message] Delayed (\(nextMessage!.simpleDescription()))")
                }
            }
        }
    }
    
    func removeMessageFromQueue(message:Message) {
        Logger.log(logSwitch, logMessage: "[Message] Remove (\(message.simpleDescription())))")
        simpleDescription()
        messageQueue.removeObject(message)
        simpleDescription()
    }
    
    //MARK: State
    
    func simpleDescription() {
        Logger.log(logSwitch, logMessage: "[Message] ======= Queue: \(messageQueue.count) =======")
    }
    
}
