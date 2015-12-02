//
//  UIViewController+Notify.m
//  
//
//  Created by jajeo on 12/2/15.
//
//

#import "UIViewController+Notify.h"

@implementation UIViewController (Notify)

- (void)notifyUserWithTitle:(NSString*)title
               withSubTitle:(NSString*)subTitle
                   duration:(NSTimeInterval)duration
                       type:(TSMessageNotificationType)type{
    [TSMessage showNotificationInViewController:self.navigationController
                                          title:title
                                       subtitle:subTitle
                                           type:type
                                       duration:duration];
}

@end
