//
//  PVPassVerify.h
//
//  Created by jajeo  on 11/30/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PVData, PVValidateMessages;

@interface PVPassVerify : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL status;
@property (nonatomic, strong) PVData *data;
@property (nonatomic, assign) double httpstatus;
@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) PVValidateMessages *validateMessages;
@property (nonatomic, strong) NSString *validateMessagesShowId;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
