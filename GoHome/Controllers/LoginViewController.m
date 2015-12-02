//
//  ViewController.m
//  GoHome
//
//  Created by jajeo on 11/27/15.
//  Copyright (c) 2015 jajeo. All rights reserved.
//

#import "LoginViewController.h"
#import "VCDataModels.h"
#import "PVDataModels.h"
#import "CommonUtils.h"
#import "NetUtils.h"
#import "UIViewController+Notify.h"

@interface LoginViewController ()<UIGestureRecognizerDelegate>{
    __weak IBOutlet UIImageView     *_verifyCodeImgView;
    __weak IBOutlet UITextField     *_unameTF;
    __weak IBOutlet UITextField     *_passwordTF;
    
    NSString                        *_usernameStr;
    NSString                        *_passwordStr;
    NSMutableArray                  *_verifyCodeArr;
    NSString                        *_codeStr;
}

- (IBAction)doLogin:(id)sender;
- (void)tapImageAction:(UIButton*)btn;
- (IBAction)refreshVerifyCode:(id)sender;


@end

@implementation LoginViewController

#pragma mark - view life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self  _requestInitPages];
    [self _initUIs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  - private method

- (void)_requestInitPages{
    [ [NetUtils sharedInstance].manager GET:USER_LOGIN_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id retObj) {
        [self refreshVerifyCode:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            [self notifyUserWithTitle:@"请求登录页发生错误" withSubTitle:error.localizedDescription duration:1 type:TSMessageNotificationTypeError];
        }
    }];
    
}



- (void)_initUIs{
    [self.navigationItem hidesBackButton];
    _verifyCodeArr = [NSMutableArray array];
    
    CGRect frame = _verifyCodeImgView.frame;
    CGFloat width = frame.size.width / 4;
    CGFloat height = (frame.size.height - 50) / 2;
    CGFloat xPos = width, yPos =  height;
    
    for (int i = 0; i < 8; i++) {
        CGRect frame = CGRectMake(xPos * (i%4), 40 + (yPos + 5) * (i/4), width, height);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 2015 + i;
        btn.frame = frame;
        [btn setImage:[UIImage imageNamed:@"login_btn_selected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(tapImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [_verifyCodeImgView addSubview:btn];
    }
}

- (BOOL)_checkLoginParams{
    _usernameStr = _unameTF.text;
    _passwordStr = _passwordTF.text;
    
    if (!_usernameStr || _usernameStr.length == 0) {
        return NO;
    }
    
    if (!_passwordStr || _passwordStr.length == 0) {
        return NO;
    }
    
    return YES;
}

- (NSString *)_concatVerifyCode{
    [_verifyCodeArr removeAllObjects];
    for (UIButton *btn in _verifyCodeImgView.subviews) {
        if (btn.selected) {
            CGPoint p = btn.center;
            NSString *pStr = [NSString stringWithFormat:@"%d,%d", (int)p.x, (int)p.y];
            [_verifyCodeArr addObject:pStr];
        }
    }
    return [_verifyCodeArr componentsJoinedByString:@","];
}

- (void)_verifyPassword{
    NSDictionary *params = @{@"loginUserDTO.user_name":_usernameStr,@"userDTO.password":_passwordStr,@"randCode":_codeStr};
    [[NetUtils sharedInstance].manager POST:VERIFY_PASS_URI parameters:params success:^(AFHTTPRequestOperation *operation, id ret) {
        NSDictionary *retDic = [NSJSONSerialization JSONObjectWithData:ret options:0 error:nil];
        PVPassVerify *code = [[PVPassVerify alloc] initWithDictionary:retDic];
        if ([code.data.loginCheck isEqualToString:@"Y"]) {
            [self notifyUserWithTitle:@"登录成功" withSubTitle:@"进入订票" duration:1 type:TSMessageNotificationTypeSuccess];
            self.view.userInteractionEnabled = YES;
            [self _saveUserCookie];
            [self performSegueWithIdentifier:@"OrderViewController" sender:self];
        } else {
            [self notifyUserWithTitle:@"效验密码发生错误" withSubTitle:code.data.otherMsg duration:0.5 type:TSMessageNotificationTypeError];
            [self refreshVerifyCode:nil];
            self.view.userInteractionEnabled = YES;
        }
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [self refreshVerifyCode:nil];
        [self notifyUserWithTitle:@"效验密码发生错误" withSubTitle:error.localizedDescription duration:1 type:TSMessageNotificationTypeError];
        
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)_saveUserCookie{
    //设置cookie
    NSMutableArray *cookies = [NSMutableArray array];
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies addObjectsFromArray:storage.cookies];
    for (NSHTTPCookie *cookie in storage.cookies) {
        [cookieDic setObject:cookie.properties forKey:cookie.name];
    }
    NSDictionary *tempDic = @{@"_jc_save_fromStation":@"深圳,SZQ",
                              @"_jc_save_showIns":@"true",
                              @"_jc_save_toStation":@"fI,WHN",
                              @"_jc_save_wfdc_flag":@"dc",
                              @"_jc_save_fromDate":@"2015-12-13",
                              @"_jc_save_toDate":@"2015-12-02"};
    
    for (NSString *key in tempDic) {
        NSString *value = tempDic[key];
        NSDictionary *properties = @{NSHTTPCookieDomain: @"kyfw.12306.cn",
                                     NSHTTPCookiePath: @"/",
                                     NSHTTPCookieName:key ,
                                     NSHTTPCookieValue:value,
                                     NSHTTPCookieMaximumAge:@"0"};
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
        [cookies addObject:cookie];
        [cookieDic setObject:properties forKey:key];
    }
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    [storage setCookies:cookies forURL:baseURL mainDocumentURL:baseURL];
#ifdef DEBUG
    NSLog(@"%@", cookieDic);
#endif
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSUserDefaults standardUserDefaults] setObject:cookieDic forKey:COOKIE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

- (void)_clearBtnSelectStatus{
    for (UIButton *btn in _verifyCodeImgView.subviews) {
        btn.selected = NO;
    }
}

- (void)_loadFailedRefreshUI{
    [self notifyUserWithTitle:@"悲鸟个催！" withSubTitle:@"请求登录验证码图片出错了..." duration:1.0 type:TSMessageNotificationTypeError];
    [_verifyCodeImgView setImage:[UIImage imageNamed:@"login_loading_failed"]];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - target Actions

- (IBAction)refreshVerifyCode:(id)sender{
    _verifyCodeImgView.image = [UIImage imageNamed:@"login_loading_image"];
    [self _clearBtnSelectStatus];
    
    NSString *randomStr = [CommonUtils generateRandomWithLength:17
                                                  containNumber:YES
                                               containUpperChar:NO
                                               containLowerChar:NO
                                             containSepcialChar:NO];
    NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@", USER_LOGIN_VERIFY_CODE_IMG_URL, randomStr];
    [[NetUtils sharedInstance].manager GET:imgUrlStr parameters:nil success:^(AFHTTPRequestOperation *op, NSData *retData) {
        if (!retData || retData.length == 0) {
            [self _loadFailedRefreshUI];
        }
        UIImage *image = [UIImage imageWithData:retData];
        [_verifyCodeImgView setImage:image];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [self _loadFailedRefreshUI];
    }];
}




- (IBAction)doLogin:(id)sender{
    self.view.userInteractionEnabled = NO;
    BOOL flag = [self _checkLoginParams];
    if(flag){
        //1.验证码组合
        _codeStr = [self _concatVerifyCode];
        NSDictionary *codeParams = @{@"rand":@"sjrand", @"randCode": _codeStr};
        
        [[NetUtils sharedInstance].manager POST:VERIFY_CODE_URI parameters:codeParams success:^(AFHTTPRequestOperation *operation, id retObj) {
            id retDic = [NSJSONSerialization JSONObjectWithData:retObj options:0 error:nil];
            VCVerifyCode *code = [[VCVerifyCode alloc] initWithDictionary:retDic];
            if ([code.data.result isEqualToString:@"1"]) {
                [self notifyUserWithTitle:@"效验验证码成功"
                              withSubTitle:@"准备效验密码"
                                  duration:0.5
                                      type:TSMessageNotificationTypeSuccess];
                [self _verifyPassword];

            } else {
                [self notifyUserWithTitle:@"效验验证码发生错误"
                              withSubTitle:code.data.msg
                                  duration:0.5
                                      type:TSMessageNotificationTypeWarning];
                
                [self refreshVerifyCode:nil];
                self.view.userInteractionEnabled = YES;
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (error) {
                [self notifyUserWithTitle:@"效验验证码发生错误"
                              withSubTitle:error.localizedDescription
                                  duration:0.5
                                      type:TSMessageNotificationTypeWarning];
                [self refreshVerifyCode:nil];
                self.view.userInteractionEnabled = YES;
            }
        }];
    }
}


- (void)tapImageAction:(UIButton*)btn{
    btn.selected = !btn.selected;
}

- (IBAction)tapViewAction:(UITapGestureRecognizer*)ges{
    [_unameTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}

@end
