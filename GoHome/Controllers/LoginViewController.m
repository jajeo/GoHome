//
//  ViewController.m
//  GoHome
//
//  Created by jajeo on 11/27/15.
//  Copyright (c) 2015 jajeo. All rights reserved.
//

#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperationManager.h"
#import "TSMessage.h"
#import "StringUtil.h"
#import "VCDataModels.h"
#import "PVDataModels.h"
#import "CommonUtils.h"

@interface LoginViewController ()<UIGestureRecognizerDelegate>{
    __weak IBOutlet UIImageView     *_verifyCodeImgView;
    __weak IBOutlet UITextField     *_unameTF;
    __weak IBOutlet UITextField     *_passwordTF;
    
    NSString                        *_usernameStr;
    NSString                        *_passwordStr;
    NSMutableArray                  *_verifyCodeArr;
    NSString                        *_codeStr;
}

@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

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
    [self.manager GET:USER_LOGIN_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id retObj) {
        [self refreshVerifyCode:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
            [TSMessage showNotificationWithTitle:@"请求登录页发生错误"
                                        subtitle:error.localizedDescription
                                            type:TSMessageNotificationTypeError];
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
    
    if ([StringUtil stringIsEmptyOrIsNull:_usernameStr]) {
        return NO;
    }
    
    if ([StringUtil stringIsEmptyOrIsNull:_passwordStr]) {
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
    [self.manager POST:VERIFY_PASS_URI parameters:params success:^(AFHTTPRequestOperation *operation, id ret) {
        NSDictionary *retDic = [NSJSONSerialization JSONObjectWithData:ret options:0 error:nil];
        PVPassVerify *code = [[PVPassVerify alloc] initWithDictionary:retDic];
        if ([code.data.loginCheck isEqualToString:@"Y"]) {
            [self _notifyUserWithTitle:@"登录成功" withSubTitle:@"进入订票" duration:1 type:TSMessageNotificationTypeSuccess];
            self.view.userInteractionEnabled = YES;
            [self _saveUserCookie];
            [self performSegueWithIdentifier:@"OrderViewController" sender:self];
        } else {
            [self _notifyUserWithTitle:@"效验密码发生错误" withSubTitle:code.data.otherMsg duration:0.5 type:TSMessageNotificationTypeError];
            [self refreshVerifyCode:nil];
            self.view.userInteractionEnabled = YES;
        }
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [self refreshVerifyCode:nil];
        [self _notifyUserWithTitle:@"效验密码发生错误" withSubTitle:error.localizedDescription duration:1 type:TSMessageNotificationTypeError];
        
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)_notifyUserWithTitle:(NSString*)title  withSubTitle:(NSString*)subTitle duration:(NSTimeInterval)duration type:(TSMessageNotificationType)type{
    [TSMessage showNotificationInViewController:self.navigationController title:title subtitle:subTitle type:type duration:duration];
}

- (void)_saveUserCookie{
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        
        [cookieDic setObject:cookie.properties forKey:cookie.name];
    }
#ifdef DEBUG
    NSLog(@"%@", cookieDic);
#endif
    
    [NSUserDefaults standardUserDefaults];
    
    [[NSUserDefaults standardUserDefaults] setObject:cookieDic forKey:COOKIE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)_clearBtnSelectStatus{
    for (UIButton *btn in _verifyCodeImgView.subviews) {
        btn.selected = NO;
    }
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

- (IBAction)refreshVerifyCode:(id)sender{
    [self _clearBtnSelectStatus];
    
    NSString *randomStr = [CommonUtils generateRandomWithLength:17
                                                  containNumber:YES
                                               containUpperChar:NO
                                               containLowerChar:NO
                                             containSepcialChar:NO];
    NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL, USER_LOGIN_VERIFY_CODE_IMG_URL, randomStr];
    NSURL *imgUrl = [NSURL URLWithString:imgUrlStr];
    SDWebImageOptions options = SDWebImageAllowInvalidSSLCertificates|SDWebImageRefreshCached|SDWebImageHandleCookies;
    [_verifyCodeImgView sd_setImageWithURL:imgUrl placeholderImage:nil options:options];
}

- (IBAction)doLogin:(id)sender{
    self.view.userInteractionEnabled = NO;
    BOOL flag = [self _checkLoginParams];
    if(flag){
        //1.验证码组合
        _codeStr = [self _concatVerifyCode];
        NSDictionary *codeParams = @{@"rand":@"sjrand", @"randCode": _codeStr};
        
        [self.manager POST:VERIFY_CODE_URI parameters:codeParams success:^(AFHTTPRequestOperation *operation, id retObj) {
            id retDic = [NSJSONSerialization JSONObjectWithData:retObj options:0 error:nil];
            VCVerifyCode *code = [[VCVerifyCode alloc] initWithDictionary:retDic];
            if ([code.data.result isEqualToString:@"1"]) {
                [self _notifyUserWithTitle:@"效验验证码成功"
                              withSubTitle:@"准备效验密码"
                                  duration:0.5
                                      type:TSMessageNotificationTypeSuccess];
                [self _verifyPassword];

            } else {
                [self _notifyUserWithTitle:@"效验验证码发生错误"
                              withSubTitle:code.data.msg
                                  duration:0.5
                                      type:TSMessageNotificationTypeWarning];
                
                [self refreshVerifyCode:nil];
                self.view.userInteractionEnabled = YES;
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (error) {
                [self _notifyUserWithTitle:@"效验验证码发生错误"
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
