//
//  NetUtils.m
//  
//
//  Created by jajeo on 12/2/15.
//
//

#import "NetUtils.h"

@interface NetUtils()


@end


@implementation NetUtils

static NetUtils *_sharedInstance = nil;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NetUtils alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)sharedInstance{
    return [[self class] sharedInstance];
}

- (instancetype)copyWithZone:(NSZone *)zone{
    return [self sharedInstance];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (!_sharedInstance) {
        _sharedInstance = [[super allocWithZone:zone] init];
    }
    return _sharedInstance;
}

- (AFHTTPRequestOperationManager*)manager{
    if (!_manager) {
        NSURL *baseURL = [NSURL URLWithString:BASE_URL];
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        [securityPolicy setValidatesDomainName:NO];
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        _manager.securityPolicy = securityPolicy;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        [_manager.requestSerializer setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.11; rv:38.0) Gecko/20100101 Firefox/38.0" forHTTPHeaderField:@"User-Agent"];
        [_manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
        _manager.requestSerializer.timeoutInterval = REQUEST_TIMEOUT_SEC;
        [self _setGlobalCookieInfo];
    }
    return _manager;
}

#pragma mark - helpper method

- (void)_setGlobalCookieInfo{
    NSDictionary *cookieDic = [[NSUserDefaults standardUserDefaults] objectForKey:COOKIE_KEY];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSMutableArray *cookieArr = [NSMutableArray array];
    for (NSString *key in cookieDic) {
        NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieDic[key]];
        [cookieArr addObject:cookie];
    }
    NSURL *baseURL = [NSURL URLWithString:BASE_URL];
    [cookieStorage setCookies:cookieArr forURL:baseURL mainDocumentURL:baseURL];
}

@end
