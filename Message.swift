
//
//  Created by Bernd Plontsch on 20/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var messageText:NSAttributedString = NSAttributedString()
    
    convenience init(messageText:NSAttributedString) {
        self.init()
        self.messageText = messageText
    }
    
    func simpleDescription()->NSString{
        return ("\t [Message] \(messageText)")
    }
        
}
