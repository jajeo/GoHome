//
//  ViewController.m
//  GoHome
//
//  Created by jajeo on 11/27/15.
//  Copyright (c) 2015 jajeo. All rights reserved.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "BookInfoViewController.h"
#import "CLDataModels.h"
#import "NetUtils.h"
#import "UIViewController+Notify.h"


@interface RootViewController (){
    __weak IBOutlet UILabel                  *_messageLB;
    __weak IBOutlet UIActivityIndicatorView  *_activityIndicatorView;
}



@end

@implementation RootViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _checkCookieIsValid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  - private method

- (void)_checkCookieIsValid{
    NSDictionary *cookDic = [[NSUserDefaults standardUserDefaults] objectForKey:COOKIE_KEY];
    if (!cookDic) {
        [self _navLoginViewController];
        return;
    }
#ifdef DEBUG
    NSLog(@"%@", cookDic);
#endif
    NSDictionary *params = @{@"_json_att":@""};
    [[NetUtils sharedInstance].manager POST:CHECK_USER_LOGIN parameters:params success:^(AFHTTPRequestOperation *op, id ret) {
        NSDictionary *retDic = [NSJSONSerialization JSONObjectWithData:ret options:0 error:nil];
        CLCheckLogin *login = [[CLCheckLogin alloc] initWithDictionary:retDic];
        if (login.data.flag) {
            [self _navOrderViewController];
        } else{
            [self _navLoginViewController];
        }
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [self notifyUserWithTitle:@"检查用户登录状态出错" withSubTitle:error.localizedDescription duration:1 type:TSMessageNotificationTypeError];
    }];
}

- (void)_navOrderViewController{
    [self performSegueWithIdentifier:@"OrderViewController" sender:self];
}

- (void)_navLoginViewController{
    LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVC animated:YES];
}


#pragma mark - target Actions


@end
