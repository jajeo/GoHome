//
//  OrderViewController.m
//  
//
//  Created by jajeo on 11/30/15.
//
//

#import "BookInfoViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "TSMessage.h"
#import "UIImageView+WebCache.h"
#import "CommonUtils.h"

@interface BookInfoViewController (){
    __weak IBOutlet UITextField     *_dateTF;
    __weak IBOutlet UITextField     *_fromTF;
    __weak IBOutlet UITextField     *_toTF;
    __weak IBOutlet UIImageView     *_verifyCodeImgView;
    
    NSString                        *_tokenStr;
    NSMutableArray                  *_verifyCodeArr;
}

- (IBAction)_beginSelectTrainNo:(id)sender;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

@end

@implementation BookInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查询车次";
    
    //1.构造剩余所需cookie信息
    [self _requestSubmitToken];
    //2.https://kyfw.12306.cn/otn/confirmPassenger/initDc post 获取 REPEAT_SUBMIT_TOKEN
    //3.https://kyfw.12306.cn/otn/confirmPassenger/getPassengerDTOs 获取乘客信息
    //3.https://kyfw.12306.cn/otn/passcodeNew/getPassCodeNew?module=passenger&rand=randp&0.6895102937921469 获取验证码信息
    //4.https://kyfw.12306.cn/otn/passcodeNew/checkRandCodeAnsyn 效验验证码信息
    //5.https://kyfw.12306.cn/otn/confirmPassenger/checkOrderInfo 初步提交订单
    //6.
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
//        NSString *cookieStr = [self _constructCookieString];
//        [_manager.requestSerializer setValue:cookieStr forHTTPHeaderField:@"Cookie"];
        [_manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:38.0) Gecko/20100101 Firefox/38.0" forHTTPHeaderField:@"User-Agent"];
        [_manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
        [self _setGlobalCookieInfo];
        
    }
    return _manager;
}

#pragma mark - private method

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


- (NSURLRequest *)_constructRestCookieInfo{
    NSURL *theURL = [NSURL URLWithString:@"https://kyfw.12306.cn/otn/confirmPassenger/initDc"];
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:theURL];
    theRequest.HTTPMethod = @"POST";
    [theRequest setHTTPBody:[@"_json_att=" dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setHTTPShouldHandleCookies:YES];
    return theRequest;
}


//_constructCookieString 和 _setGlobalCookieInfo二选一，由于后面用到SDWebImage这里选择设置全局cookie
//如果使用_constructCookieString，后面可选择使用AFNetworking请求图片数据
- (void)_setGlobalCookieInfo{
    //设置cookie
    NSMutableArray *cookies = [NSMutableArray array];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies addObjectsFromArray:storage.cookies];
     
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
     }
     NSURL *baseURL = [NSURL URLWithString:BASE_URL];
     [storage setCookies:cookies forURL:baseURL mainDocumentURL:baseURL];
}
//
//- (NSString*)_constructCookieString{
//    NSMutableString *retStr = [NSMutableString string];
//    
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    for (NSHTTPCookie *cookie in storage.cookies) {
//        [retStr appendFormat:@"%@=%@;", cookie.name, cookie.value];
//    }
//    [retStr appendString:@"_jc_save_fromStation=深圳,SZQ;"];
//    [retStr appendString:@"_jc_save_showIns=true;"];
//    [retStr appendString:@"_jc_save_toStation=fI,WHN;"];
//    [retStr appendString:@"_jc_save_wfdc_flag=dc;"];
//    [retStr appendString:@"_jc_save_fromDate=2015-12-13;"];
//    [retStr appendString:@"_jc_save_toDate=2015-12-01"];
//    
//    return retStr;
//}

- (void)_requestSubmitToken{
    NSDictionary *params = @{@"_json_att=":@""};
    [self.manager POST:INIT_DC_URI parameters:params success:^(AFHTTPRequestOperation *op, id retData) {
        [self _handleRequestTokenData:retData];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [TSMessage showNotificationInViewController:self.navigationController title:@"悲鸟个催！" subtitle:@"请求REPEAT_SUBMIT_TOKEN出错啦！" type:TSMessageNotificationTypeError duration:1];
    }];
}

- (void)_handleRequestTokenData:(NSData*)retData{
    NSString *str = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
    NSArray *tempArr = [str componentsSeparatedByString:@"var "];
    NSMutableArray *mutaleArr = [NSMutableArray arrayWithArray:tempArr];
    [mutaleArr removeLastObject];
    [mutaleArr removeObjectAtIndex:0];
    for (NSString *str in mutaleArr) {
        if ([str rangeOfString:@"globalRepeatSubmitToken"].location != NSNotFound) {
            NSArray *tempArr = [str componentsSeparatedByString:@"="];
            for (NSString *s in tempArr) {
                _tokenStr = [s stringByReplacingOccurrencesOfString:@"\'" withString:@""];
                _tokenStr = [_tokenStr stringByReplacingOccurrencesOfString:@";" withString:@""];
                _tokenStr = [_tokenStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                _tokenStr = [_tokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
        }
    }
    if (!_tokenStr || ([_tokenStr rangeOfString:@"null"].location != NSNotFound)) {
        [TSMessage showNotificationInViewController:self.navigationController title:@"悲鸟个催！" subtitle:@"请求REPEAT_SUBMIT_TOKEN出错啦！" type:TSMessageNotificationTypeError duration:1];
    } else {
//        [self _requestRandomVerifyCode];
//        [self _requestPassengerInfo];
        [self refreshVerifyCode:nil];
    }
}

//- (void)_requestPassengerInfo{
//    NSDictionary *params = @{@"REPEAT_SUBMIT_TOKEN":_tokenStr,@"_json_att":@""};
//    [self.manager POST:@"https://kyfw.12306.cn/otn/confirmPassenger/getPassengerDTOs" parameters:params success:^(AFHTTPRequestOperation *op, id retData) {
////        NSString *str = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
////        NSLog(@"%@", str);
//        [self _requestRandomVerifyCode];
//    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
//        
//    }];
//}
//
//- (void)_requestRandomVerifyCode{
//    NSDictionary *params = nil;
//    [self.manager GET:@"https://kyfw.12306.cn/otn/passcodeNew/getPassCodeNew?module=passenger&rand=randp&0.20263652402247678" parameters:params success:^(AFHTTPRequestOperation *op, id retData) {
//        UIImage *image = [UIImage imageWithData:retData];
//        _verifyCodeImgView.image = image;
//    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
//        
//    }];
//}

- (void)_clearBtnSelectStatus{
    for (UIButton *btn in _verifyCodeImgView.subviews) {
        btn.selected = NO;
    }
}


#pragma mark - target Action

- (IBAction)refreshVerifyCode:(id)sender{
    [self _clearBtnSelectStatus];
    
    NSString *randomStr = [CommonUtils generateRandomWithLength:17
                                                  containNumber:YES
                                               containUpperChar:NO
                                               containLowerChar:NO
                                             containSepcialChar:NO];
    NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@%@",BASE_URL, CONFIRM_ORDER_VERIFY_CODE_URI, randomStr];
    NSURL *imgUrl = [NSURL URLWithString:imgUrlStr];
    SDWebImageOptions options = SDWebImageAllowInvalidSSLCertificates|SDWebImageRefreshCached|SDWebImageHandleCookies;
    [_verifyCodeImgView sd_setImageWithURL:imgUrl placeholderImage:nil options:options];
}


- (IBAction)_beginSelectTrainNo:(id)sender{
    
}

- (void)tapImageAction:(UIButton*)btn{
    btn.selected = !btn.selected;
}


@end
