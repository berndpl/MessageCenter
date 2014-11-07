
//
//  Created by Bernd Plontsch on 20/10/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class Message: NSObject {
    
    var messageText:NSString = ""
    
    convenience init(messageText:NSString) {
        self.init()
        self.messageText = messageText
    }
    
    func simpleDescription()->NSString{
        return ("\t [Message] \(messageText)")
    }
        
}
