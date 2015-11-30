//
//  PVData.h
//
//  Created by jajeo  on 11/30/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PVData : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *loginCheck;
@property (nonatomic, strong) NSString *otherMsg;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
