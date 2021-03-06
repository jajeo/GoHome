//
//  VCVerifyCode.h
//
//  Created by jajeo  on 11/30/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VCData, VCValidateMessages;

@interface VCVerifyCode : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) VCData *data;
@property (nonatomic, assign) double httpstatus;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) VCValidateMessages *validateMessages;
@property (nonatomic, strong) NSString *validateMessagesShowId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
