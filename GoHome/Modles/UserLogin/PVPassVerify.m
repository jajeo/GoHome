//
//  PVPassVerify.m
//
//  Created by jajeo  on 11/30/15
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "PVPassVerify.h"
#import "PVData.h"
#import "PVValidateMessages.h"


NSString *const kPVPassVerifyStatus = @"status";
NSString *const kPVPassVerifyData = @"data";
NSString *const kPVPassVerifyHttpstatus = @"httpstatus";
NSString *const kPVPassVerifyMessages = @"messages";
NSString *const kPVPassVerifyValidateMessages = @"validateMessages";
NSString *const kPVPassVerifyValidateMessagesShowId = @"validateMessagesShowId";


@interface PVPassVerify ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation PVPassVerify

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
            self.status = [[self objectOrNilForKey:kPVPassVerifyStatus fromDictionary:dict] boolValue];
            self.data = [PVData modelObjectWithDictionary:[dict objectForKey:kPVPassVerifyData]];
            self.httpstatus = [[self objectOrNilForKey:kPVPassVerifyHttpstatus fromDictionary:dict] doubleValue];
            self.messages = [self objectOrNilForKey:kPVPassVerifyMessages fromDictionary:dict];
            self.validateMessages = [PVValidateMessages modelObjectWithDictionary:[dict objectForKey:kPVPassVerifyValidateMessages]];
            self.validateMessagesShowId = [self objectOrNilForKey:kPVPassVerifyValidateMessagesShowId fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.status] forKey:kPVPassVerifyStatus];
    [mutableDict setValue:[self.data dictionaryRepresentation] forKey:kPVPassVerifyData];
    [mutableDict setValue:[NSNumber numberWithDouble:self.httpstatus] forKey:kPVPassVerifyHttpstatus];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForMessages] forKey:kPVPassVerifyMessages];
    [mutableDict setValue:[self.validateMessages dictionaryRepresentation] forKey:kPVPassVerifyValidateMessages];
    [mutableDict setValue:self.validateMessagesShowId forKey:kPVPassVerifyValidateMessagesShowId];

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

    self.status = [aDecoder decodeBoolForKey:kPVPassVerifyStatus];
    self.data = [aDecoder decodeObjectForKey:kPVPassVerifyData];
    self.httpstatus = [aDecoder decodeDoubleForKey:kPVPassVerifyHttpstatus];
    self.messages = [aDecoder decodeObjectForKey:kPVPassVerifyMessages];
    self.validateMessages = [aDecoder decodeObjectForKey:kPVPassVerifyValidateMessages];
    self.validateMessagesShowId = [aDecoder decodeObjectForKey:kPVPassVerifyValidateMessagesShowId];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_status forKey:kPVPassVerifyStatus];
    [aCoder encodeObject:_data forKey:kPVPassVerifyData];
    [aCoder encodeDouble:_httpstatus forKey:kPVPassVerifyHttpstatus];
    [aCoder encodeObject:_messages forKey:kPVPassVerifyMessages];
    [aCoder encodeObject:_validateMessages forKey:kPVPassVerifyValidateMessages];
    [aCoder encodeObject:_validateMessagesShowId forKey:kPVPassVerifyValidateMessagesShowId];
}

- (id)copyWithZone:(NSZone *)zone
{
    PVPassVerify *copy = [[PVPassVerify alloc] init];
    
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
