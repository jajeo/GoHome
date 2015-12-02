//
//  CommonUtils.m
//  
//
//  Created by jajeo on 12/1/15.
//
//

#import "CommonUtils.h"
#import "TSMessage.h"

@implementation CommonUtils

+ (NSString*)generateRandomWithLength:(unsigned int)num
                        containNumber:(BOOL)containNumber
                     containUpperChar:(BOOL)containUpperChar
                     containLowerChar:(BOOL)containLowerChar
                   containSepcialChar:(BOOL)containSepcialChar{
    NSMutableString *retStr = [NSMutableString string];
    NSString *number = @"0123456789";
    NSString *lowerChar = @"abcdefghijklmnopqrstuvwxyz";
    NSString *specialChar = @"`~!@#$%^&*()_-+=?/.,;'\":<>";
    NSMutableArray *containArr = [NSMutableArray array];
    
    if (containNumber) {
        [containArr addObject:number];
    }
    if (containUpperChar) {
        [containArr addObject:[lowerChar uppercaseString]];
    }
    if (containLowerChar) {
        [containArr addObject:lowerChar];
    }
    if (containSepcialChar) {
        [containArr addObject:specialChar];
    }
    
    
    
    for (int i = 0; i < num; i++) {
        int r = arc4random()%(containArr.count);
        NSString *tempStr = [containArr objectAtIndex:r];
        r = arc4random()%(tempStr.length);
        char c = [tempStr characterAtIndex:r];
        [retStr appendFormat:@"%c", c];
    }
    return retStr;
}

@end
