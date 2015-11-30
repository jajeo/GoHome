//
//  StringUtil.h
//  DataCollection
//
//  Created by yuanshenwen on 14/12/13.
//  Copyright (c) 2014年 yuanshenwen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject

+(BOOL)stringIsEmptyOrIsNull:(NSString *)text;
+(BOOL)containsStr:(NSString *)parentStr substr:(NSString *)subStr;
+(BOOL)isValidateEmail:(NSString *)email;
+(BOOL)isValidateTel:(NSString *)tel;
+(BOOL)isValidateNum:(NSString *)str;
+(BOOL)isAllowDialTel;
+(BOOL)hasChinese:(NSString *)str;
+ (NSString*)encodeURL:(NSString *)string;
+(NSString *) utf8ToUnicode:(NSString *)string;


@end
