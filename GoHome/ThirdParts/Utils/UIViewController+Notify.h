//
//  UIViewController+Notify.h
//  
//
//  Created by jajeo on 12/2/15.
//
//

#import <UIKit/UIKit.h>
#import "TSMessage.h"

@interface UIViewController (Notify)

- (void)notifyUserWithTitle:(NSString*)title
               withSubTitle:(NSString*)subTitle
                   duration:(NSTimeInterval)duration
                       type:(TSMessageNotificationType)type;


@end
