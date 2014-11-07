
//
//  Created by Bernd Plontsch on 20/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class MessageCenter: NSObject {
    
    let logSwitch:Bool = true
    
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
            println("[Message] Add view")
        } else {
            println("[Message] Setup no box?")
        }
        resetQueue()
    }
    
    func addMessage(message:Message) {
        Logger.log(logSwitch, logMessage: "[Message] Adding (\(message.simpleDescription())))")
        messageQueue.addObject(message)
        simpleDescription()
    }
    
    func show() {
        println("[Message] Show Next (\(messageQueue.count))")
        simpleDescription()
        var nextMessage:Message? = messageQueue.firstObject as? Message
        if nextMessage != nil {
            if messageBox?.activeMessage == false || messageBox?.activeMessage == nil {
                println("[Message] Show (\(nextMessage!.simpleDescription()))")
                messageBox?.showMessage(nextMessage!)
            } else {
                println("[Message] Delayed (\(nextMessage!.simpleDescription()))")
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
