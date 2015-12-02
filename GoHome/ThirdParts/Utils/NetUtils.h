//
//  NetUtils.h
//  
//
//  Created by jajeo on 12/2/15.
//
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^CompletionBlock)(AFHTTPRequestOperation *op, id retData);

@interface NetUtils : NSObject

+ (instancetype)sharedInstance;
- (instancetype)sharedInstance;

@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;

@end
