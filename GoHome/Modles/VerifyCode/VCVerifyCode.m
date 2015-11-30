//
//  VCVerifyCode.m
//
//  Created by jajeo  on 11/30/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "VCVerifyCode.h"
#import "VCData.h"
#import "VCValidateMessages.h"


NSString *const kVCVerifyCodeStatus = @"status";
NSString *const kVCVerifyCodeData = @"data";
NSString *const kVCVerifyCodeHttpstatus = @"httpstatus";
NSString *const kVCVerifyCodeMessages = @"messages";
NSString *const kVCVerifyCodeValidateMessages = @"validateMessages";
NSString *const kVCVerifyCodeValidateMessagesShowId = @"validateMessagesShowId";


@interface VCVerifyCode ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation VCVerifyCode

@synthesize status = _status;
@synthesize data = _data;
@synthesize httpstatus = _httpstatus;
@synthesize messages = _messages;
@synthesize validateMessages = _validateMessages;
@synthesize validateMessagesShowId = _validateMessagesShowId;


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
            self.status = [[self objectOrNilForKey:kVCVerifyCodeStatus fromDictionary:dict] boolValue];
            self.data = [VCData modelObjectWithDictionary:[dict objectForKey:kVCVerifyCodeData]];
            self.httpstatus = [[self objectOrNilForKey:kVCVerifyCodeHttpstatus fromDictionary:dict] doubleValue];
            self.messages = [self objectOrNilForKey:kVCVerifyCodeMessages fromDictionary:dict];
            self.validateMessages = [VCValidateMessages modelObjectWithDictionary:[dict objectForKey:kVCVerifyCodeValidateMessages]];
            self.validateMessagesShowId = [self objectOrNilForKey:kVCVerifyCodeValidateMessagesShowId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.status] forKey:kVCVerifyCodeStatus];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kVCVerifyCodeData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.httpstatus] forKey:kVCVerifyCodeHttpstatus];
    NSMutableArray *tempArrayForMessages = [NSMutableArray array];
    for (NSObject *subArrayObject in self.messages) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForMessages addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForMessages addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMessages] forKey:kVCVerifyCodeMessages];
    [mutableDict setValue:[self.validateMessages dictionaryRepresentation] forKey:kVCVerifyCodeValidateMessages];
    [mutableDict setValue:self.validateMessagesShowId forKey:kVCVerifyCodeValidateMessagesShowId];

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

    self.status = [aDecoder decodeBoolForKey:kVCVerifyCodeStatus];
    self.data = [aDecoder decodeObjectForKey:kVCVerifyCodeData];
    self.httpstatus = [aDecoder decodeDoubleForKey:kVCVerifyCodeHttpstatus];
    self.messages = [aDecoder decodeObjectForKey:kVCVerifyCodeMessages];
    self.validateMessages = [aDecoder decodeObjectForKey:kVCVerifyCodeValidateMessages];
    self.validateMessagesShowId = [aDecoder decodeObjectForKey:kVCVerifyCodeValidateMessagesShowId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_status forKey:kVCVerifyCodeStatus];
    [aCoder encodeObject:_data forKey:kVCVerifyCodeData];
    [aCoder encodeDouble:_httpstatus forKey:kVCVerifyCodeHttpstatus];
    [aCoder encodeObject:_messages forKey:kVCVerifyCodeMessages];
    [aCoder encodeObject:_validateMessages forKey:kVCVerifyCodeValidateMessages];
    [aCoder encodeObject:_validateMessagesShowId forKey:kVCVerifyCodeValidateMessagesShowId];
}

- (id)copyWithZone:(NSZone *)zone
{
    VCVerifyCode *copy = [[VCVerifyCode alloc] init];
    
    if (copy) {

        copy.status = self.status;
        copy.data = [self.data copyWithZone:zone];
        copy.httpstatus = self.httpstatus;
        copy.messages = [self.messages copyWithZone:zone];
        copy.validateMessages = [self.validateMessages copyWithZone:zone];
        copy.validateMessagesShowId = [self.validateMessagesShowId copyWithZone:zone];
    }
    
    return copy;
}


@end
