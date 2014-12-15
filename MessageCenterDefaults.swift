
//
//  Created by Bernd Plontsch on 07/07/14.
//  Copyright (c) 2014 Bernd Plontsch. All rights reserved.
//

import UIKit

class MessageCenterDefaults: NSObject {
    
    class func styleCalculatedLineSize(lineWidth:CGFloat,referenceView:UIView)->CGFloat {
        var availableWidth:CGFloat
        if referenceView.bounds.size.width > referenceView.bounds.size.height {
            availableWidth = referenceView.bounds.size.height
        } else {
            availableWidth = referenceView.bounds.size.width
        }
        return lineWidth * availableWidth / 288
    }

    class func messageFont(size:CGFloat)->UIFont {
        return UIFont(name: "HelveticaNeue-Medium", size: size)!
    }
    
    class func messageFontSize()->CGFloat {
        return 20.0
    }
    
    class func lightColor()->UIColor {
        return UIColor.whiteColor()
    }

}
