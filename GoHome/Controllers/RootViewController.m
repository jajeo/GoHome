//
//  ViewController.m
//  GoHome
//
//  Created by jajeo on 11/27/15.
//  Copyright (c) 2015 jajeo. All rights reserved.
//

#import "RootViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "LoginViewController.h"
#import "BookInfoViewController.h"
#import "CLDataModels.h"
#import "TSMessage.h"


@interface RootViewController ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

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
    NSDictionary *cookieDic = [[NSUserDefaults standardUserDefaults] objectForKey:COOKIE_KEY];
    if (!cookieDic) {
        [self _navLoginViewController];
        return;
    }
#ifdef DEBUG
    NSLog(@"%@", cookieDic);
#endif
    NSDictionary *params = @{@"_json_att":@""};
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableArray *cookieArr = [NSMutableArray array];
    for (NSString *key in cookieDic) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDic[key]];
        [cookieArr addObject:cookie];
    }
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    [cookieStorage setCookies:cookieArr forURL:baseURL mainDocumentURL:baseURL];
    
    [self.manager POST:CHECK_USER_LOGIN parameters:params success:^(AFHTTPRequestOperation *op, id ret) {
        NSDictionary *retDic = [NSJSONSerialization JSONObjectWithData:ret options:0 error:nil];
        CLCheckLogin *login = [[CLCheckLogin alloc] initWithDictionary:retDic];
        if (login.data.flag) {
            [self _navOrderViewController];
        } else{
            [self _navLoginViewController];
        }
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [TSMessage showNotificationInViewController:self.navigationController title:@"检查用户登录状态出错" subtitle:error.localizedDescription type:TSMessageNotificationTypeError duration:1];
    }];
}

- (void)_navOrderViewController{
    [self performSegueWithIdentifier:@"OrderViewController" sender:self];
}

- (void)_navLoginViewController{
    LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:loginVC animated:NO];
}


#pragma mark - getters  &  setters

- (AFHTTPRequestOperationManager*)manager{
    if (!_manager) {
        NSURL *baseURL = [NSURL URLWithString:BASE_URL];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        [securityPolicy setValidatesDomainName:NO];
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        _manager.securityPolicy = securityPolicy;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:38.0) Gecko/20100101 Firefox/38.0" forHTTPHeaderField:@"User-Agent"];
        [_manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    }
    return _manager;
}



#pragma mark - target Actions


@end
