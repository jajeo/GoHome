//
//  PVData.m
//
//  Created by jajeo  on 11/30/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PVData.h"


NSString *const kPVDataLoginCheck = @"loginCheck";
NSString *const kPVDataOtherMsg = @"otherMsg";


@interface PVData ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PVData

@synthesize loginCheck = _loginCheck;
@synthesize otherMsg = _otherMsg;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.loginCheck = [self objectOrNilForKey:kPVDataLoginCheck fromDictionary:dict];
            self.otherMsg = [self objectOrNilForKey:kPVDataOtherMsg fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.loginCheck forKey:kPVDataLoginCheck];
    [mutableDict setValue:self.otherMsg forKey:kPVDataOtherMsg];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.loginCheck = [aDecoder decodeObjectForKey:kPVDataLoginCheck];
    self.otherMsg = [aDecoder decodeObjectForKey:kPVDataOtherMsg];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_loginCheck forKey:kPVDataLoginCheck];
    [aCoder encodeObject:_otherMsg forKey:kPVDataOtherMsg];
}

- (id)copyWithZone:(NSZone *)zone
{
    PVData *copy = [[PVData alloc] init];
    
    if (copy) {

        copy.loginCheck = [self.loginCheck copyWithZone:zone];
        copy.otherMsg = [self.otherMsg copyWithZone:zone];
    }
    
    return copy;
}


@end
