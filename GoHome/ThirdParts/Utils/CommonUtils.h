//
//  CommonUtils.h
//  
//
//  Created by jajeo on 12/1/15.
//
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject



/**
 *  @author jajeo, 15-12-02 13:12:13
 *
 *
 *
 *  @param num                随机字符串位数
 *  @param containNumber      是否包含数字
 *  @param containUpperChar   是否包含大写字母
 *  @param containLowerChar   是否包含小写字母
 *  @param containSepcialChar 是否包含特殊字符
 *
 *  @return 随机字符串
 */

+ (NSString*)generateRandomWithLength:(unsigned int)num
                        containNumber:(BOOL)containNumber
                     containUpperChar:(BOOL)containUpperChar
                     containLowerChar:(BOOL)containLowerChar
                   containSepcialChar:(BOOL)containSepcialChar;

@end
