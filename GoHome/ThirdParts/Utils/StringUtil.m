//
//  StringUtil.m
//  DataCollection
//
//  Created by yuanshenwen on 14/12/13.
//  Copyright (c) 2014年 yuanshenwen. All rights reserved.
//

#import "StringUtil.h"
#import <UIKit/UIKit.h>

@implementation StringUtil

+(BOOL)stringIsEmptyOrIsNull:(NSString *)text
{
    if ([text isKindOfClass:[NSNull class]]){
        return YES;
    }
    
    else {
        if (text) {
            text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
            text = [text stringByReplacingOccurrencesOfString:@"null" withString:@""];
            text = [text stringByReplacingOccurrencesOfString:@"nil" withString:@""];
            text = [text stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            text = [text stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
            if (text.length == 0)
                return YES;
        }
        else
            return YES;
    }

    return NO;
}



+(BOOL)containsStr:(NSString *)parentStr substr:(NSString *)subStr
{
    if([parentStr rangeOfString:subStr].location!=NSNotFound)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)isValidateEmail:(NSString *)email
{
    NSArray *array = [email componentsSeparatedByString:@"."];
    if ([array count] >= 4) {
        return FALSE;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+(BOOL)isValidateTel:(NSString *)tel
{
    if (tel.length != 11) {
        return NO;
    }
    
    NSString *telRegex1=@"^1[3-8]{1}\\d{9}$";
    NSString *telRegex2=@"[0]{1}[0-9]{2,3}\\d{6,8}";
    NSPredicate *telTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",telRegex1];
    NSPredicate *telTest2 = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",telRegex2];
    if([telTest1 evaluateWithObject:tel]||[telTest2 evaluateWithObject:tel])
    {
        return YES;
    }
    return NO;
}

+(BOOL)isValidateNum:(NSString *)str
{
    NSString *numRegex = @"^[0-9]*$";
    
    NSPredicate *numTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",numRegex];
    
    return [numTest evaluateWithObject:str];
}

+(BOOL)isAllowDialTel
{
    NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType  isEqualToString:@"iPod touch"]||[deviceType  isEqualToString:@"iPad"]||[deviceType  isEqualToString:@"iPhone Simulator"])
    {
        return NO;
    }
    return YES;
}

+(BOOL)hasChinese:(NSString *)str
{
    NSUInteger length = [str length];
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [str substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            return YES;
        }
    }
    return NO;
}

+ (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return @"";
}

+(NSString *) utf8ToUnicode:(NSString *)string

{
    
    NSUInteger length = [string length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
        
    {
        
        unichar _char = [string characterAtIndex:i];
        
        //判断是否为英文和数字
        
        if (_char <= '9' && _char >='0')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
            
        }
        
        else if(_char >='a' && _char <= 'z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
            
        }
        
        else if(_char >='A' && _char <= 'Z')
            
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        
        else
            
        {
            [s appendFormat:@"\\u%04x",[string characterAtIndex:i]|0x0000];
            
        }
    }
    
    return s;
    
}
@end
