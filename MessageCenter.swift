
//
//  Created by Bernd Plontsch on 20/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class MessageCenter: NSObject {
    
    let logSwitch:Bool = false
    
    var messageQueue:NSMutableArray = NSMutableArray()
    var messageBox:MessageBox?
    var backgroundView:UIView?
    
    class var shared : MessageCenter {
        struct Singleton {
            static let instance = MessageCenter()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        Logger.log(logSwitch, logMessage: "[MessageQueue] Init")
    }
    
    func setup (backgroundView:UIView) {
        self.backgroundView = backgroundView
        var story:UIStoryboard = UIStoryboard(name: "MessageBoxStoryboard", bundle: nil)
        messageBox = story.instantiateViewControllerWithIdentifier("MessageBox") as? MessageBox
        if messageBox != nil {
            backgroundView.addSubview(messageBox!.view)
            //backgroundView.sendSubviewToBack(messageBox!.view)
            backgroundView.bringSubviewToFront(backgroundView.viewWithTag(9999)!)
            Logger.log(logSwitch, logMessage: "[Message] Add view")
        } else {
            Logger.log(logSwitch, logMessage: "[Message] Setup no box?")
        }
        resetQueue()
    }
    
    func addMessage(message:Message) {
        Logger.log(logSwitch, logMessage: "[Message] Adding (\(message.simpleDescription())))")
        if isSameMessageInQueueAlready(message) == false {
            messageQueue.addObject(message)
        }
        simpleDescription()
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
        Logger.log(logSwitch, logMessage: "[Message] Show Next (\(messageQueue.count))")
        simpleDescription()
        var nextMessage:Message? = messageQueue.firstObject as? Message
        if nextMessage != nil {
            if messageBox?.activeMessage == false || messageBox?.activeMessage == nil {
                Logger.log(logSwitch, logMessage: "[Message] Show (\(nextMessage!.simpleDescription()))")
                messageBox?.showMessage(nextMessage!)
            } else {
                Logger.log(logSwitch, logMessage: "[Message] Delayed (\(nextMessage!.simpleDescription()))")
            }
        }
    }
    
    func resetQueue() {
        messageQueue.removeAllObjects()
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
