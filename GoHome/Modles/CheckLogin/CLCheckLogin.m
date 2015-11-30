//
//  CLCheckLogin.m
//
//  Created by jajeo  on 11/30/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "CLCheckLogin.h"
#import "CLData.h"
#import "CLValidateMessages.h"


NSString *const kCLCheckLoginStatus = @"status";
NSString *const kCLCheckLoginData = @"data";
NSString *const kCLCheckLoginHttpstatus = @"httpstatus";
NSString *const kCLCheckLoginMessages = @"messages";
NSString *const kCLCheckLoginValidateMessages = @"validateMessages";
NSString *const kCLCheckLoginValidateMessagesShowId = @"validateMessagesShowId";


@interface CLCheckLogin ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation CLCheckLogin

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
            self.status = [[self objectOrNilForKey:kCLCheckLoginStatus fromDictionary:dict] boolValue];
            self.data = [CLData modelObjectWithDictionary:[dict objectForKey:kCLCheckLoginData]];
            self.httpstatus = [[self objectOrNilForKey:kCLCheckLoginHttpstatus fromDictionary:dict] doubleValue];
            self.messages = [self objectOrNilForKey:kCLCheckLoginMessages fromDictionary:dict];
            self.validateMessages = [CLValidateMessages modelObjectWithDictionary:[dict objectForKey:kCLCheckLoginValidateMessages]];
            self.validateMessagesShowId = [self objectOrNilForKey:kCLCheckLoginValidateMessagesShowId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.status] forKey:kCLCheckLoginStatus];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kCLCheckLoginData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.httpstatus] forKey:kCLCheckLoginHttpstatus];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMessages] forKey:kCLCheckLoginMessages];
    [mutableDict setValue:[self.validateMessages dictionaryRepresentation] forKey:kCLCheckLoginValidateMessages];
    [mutableDict setValue:self.validateMessagesShowId forKey:kCLCheckLoginValidateMessagesShowId];

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

    self.status = [aDecoder decodeBoolForKey:kCLCheckLoginStatus];
    self.data = [aDecoder decodeObjectForKey:kCLCheckLoginData];
    self.httpstatus = [aDecoder decodeDoubleForKey:kCLCheckLoginHttpstatus];
    self.messages = [aDecoder decodeObjectForKey:kCLCheckLoginMessages];
    self.validateMessages = [aDecoder decodeObjectForKey:kCLCheckLoginValidateMessages];
    self.validateMessagesShowId = [aDecoder decodeObjectForKey:kCLCheckLoginValidateMessagesShowId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_status forKey:kCLCheckLoginStatus];
    [aCoder encodeObject:_data forKey:kCLCheckLoginData];
    [aCoder encodeDouble:_httpstatus forKey:kCLCheckLoginHttpstatus];
    [aCoder encodeObject:_messages forKey:kCLCheckLoginMessages];
    [aCoder encodeObject:_validateMessages forKey:kCLCheckLoginValidateMessages];
    [aCoder encodeObject:_validateMessagesShowId forKey:kCLCheckLoginValidateMessagesShowId];
}

- (id)copyWithZone:(NSZone *)zone
{
    CLCheckLogin *copy = [[CLCheckLogin alloc] init];
    
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
