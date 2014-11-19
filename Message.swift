
//
//  Created by Bernd Plontsch on 20/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var messageText:NSAttributedString = NSAttributedString()
    var extraTimeInSeconds:Double?
    
    convenience init(messageText:NSAttributedString) {
        self.init()
        self.messageText = messageText
    }

    convenience init(messageString:NSString) {
        self.init()
        self.messageText = NSAttributedString(string: messageString)
    }

    convenience init(messageString:NSString, extraTimeInSeconds:Double) {
        self.init()
        self.messageText = NSAttributedString(string: messageString)
        self.extraTimeInSeconds = extraTimeInSeconds
    }
    
    func simpleDescription()->NSString{
        return ("\t [Message] \(messageText)")
    }
        
}
