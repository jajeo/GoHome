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

@interface BookInfoViewController (){
    __weak IBOutlet UITextField     *_dateTF;
    __weak IBOutlet UITextField     *_fromTF;
    __weak IBOutlet UITextField     *_toTF;
    __weak IBOutlet UIImageView     *_verifyCodeImg;
    
    NSString                        *_tokenStr;
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
    }
    return _manager;
}

#pragma mark - private method

- (NSURLRequest *)_constructRestCookieInfo{
    NSURL *theURL = [NSURL URLWithString:@"https://kyfw.12306.cn/otn/confirmPassenger/initDc"];
    NSMutableString *cookieStr = [NSMutableString string];
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:theURL];
    theRequest.HTTPMethod = @"POST";
    
    //设置cookie
    NSMutableArray *cookies = [NSMutableArray array];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookies addObjectsFromArray:storage.cookies];
   
    NSDictionary *tempDic = @{@"_jc_save_fromStation":@"深圳,SZQ",
                              @"_jc_save_showIns":@"true",
                              @"_jc_save_toStation":@"fI,WHN",
                              @"_jc_save_wfdc_flag":@"dc",
                              @"_jc_save_fromDate":@"2015-12-13",
                              @"_jc_save_toDate":@"2015-12-01"};
    
    for (NSString *key in tempDic) {
        NSString *value = tempDic[key];
        NSDictionary *properties = @{NSHTTPCookieDomain: @"kyfw.12306.cn", NSHTTPCookiePath: @"/", NSHTTPCookieName:key , NSHTTPCookieValue:value};
        NSHTTPCookie *cookie = [[NSHTTPCookie alloc] initWithProperties:properties];
        [cookies addObject:cookie];
    }
    
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    [storage setCookies:cookies forURL:baseURL mainDocumentURL:baseURL];
    
//    [cookieStr appendString:@"_jc_save_fromStation=深圳,SZQ;"];
//    [cookieStr appendString:@"_jc_save_showIns=true;"];
//    [cookieStr appendString:@"_jc_save_toStation=fI,WHN;"];
//    [cookieStr appendString:@"_jc_save_wfdc_flag=dc;"];
//    [cookieStr appendString:@"_jc_save_fromDate=2015-12-13;"];
//    [cookieStr appendString:@"_jc_save_toDate=2015-12-01"];
//    
//    [theRequest addValue:cookieStr forHTTPHeaderField:@"Cookie"];
    [theRequest setHTTPBody:[@"_json_att=" dataUsingEncoding:NSUTF8StringEncoding]];
    [theRequest setHTTPShouldHandleCookies:YES];
    return theRequest;
}


- (void)_requestSubmitToken{
    NSURLRequest *theRequest = [self _constructRestCookieInfo];
    
    [[self.manager HTTPRequestOperationWithRequest:theRequest success:^(AFHTTPRequestOperation *op, id retData) {
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        [self _handleRequestTokenData:retData];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        [TSMessage showNotificationInViewController:self.navigationController title:@"悲鸟个催！" subtitle:@"请求REPEAT_SUBMIT_TOKEN出错啦！" type:TSMessageNotificationTypeError duration:1];
    }] start];
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
        [self _requestPassengerInfo];
    }
}

- (void)_requestPassengerInfo{
    NSDictionary *params = @{@"REPEAT_SUBMIT_TOKEN":_tokenStr,@"_json_att":@""};
    [self.manager POST:@"https://kyfw.12306.cn/otn/confirmPassenger/getPassengerDTOs" parameters:params success:^(AFHTTPRequestOperation *op, id retData) {
        NSString *str = [[NSString alloc] initWithData:retData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", str);
        [self _requestRandomVerifyCode];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        
    }];
    
}


- (void)_requestRandomVerifyCode{
    NSDictionary *params = nil;
    [self.manager.requestSerializer setValue:@"https://kyfw.12306.cn/otn/confirmPassenger/initDc" forHTTPHeaderField:@"Referer"];
    [self.manager GET:@"https://kyfw.12306.cn/otn/passcodeNew/getPassCodeNew?module=passenger&rand=randp&0.20263652402247678" parameters:params success:^(AFHTTPRequestOperation *op, id retData) {
        NSHTTPCookieStorage *storyge = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        
    }];
    [_verifyCodeImg sd_setImageWithURL:[NSURL URLWithString:@"https://kyfw.12306.cn/otn/passcodeNew/getPassCodeNew?module=passenger&rand=randp&0.6895102937921469"] placeholderImage:nil];
//    [self refreshVerifyCode:nil];
    
}


- (IBAction)refreshVerifyCode:(id)sender{
    NSURL *imgUrl = [NSURL URLWithString:@"https://kyfw.12306.cn/otn/passcodeNew/getPassCodeNew?module=passenger&rand=randp&0.20263652402247678"];
    SDWebImageOptions options = SDWebImageAllowInvalidSSLCertificates|SDWebImageRefreshCached|SDWebImageHandleCookies;
    [_verifyCodeImg sd_setImageWithURL:imgUrl placeholderImage:nil options:options];
}


#pragma mark - target Action

- (IBAction)_beginSelectTrainNo:(id)sender{
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
