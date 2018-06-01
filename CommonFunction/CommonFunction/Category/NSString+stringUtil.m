//
//  NSString+stringUtil.m
//  CommonFunction
//
//  Created by zh on 2018/6/1.
//  Copyright © 2018年 zh. All rights reserved.
//

#import "NSString+stringUtil.h"

@implementation NSString (stringUtil)


- (BOOL)isValidateString {
    if (![self isKindOfClass:[NSString class]]) return NO;
    self =  [self trimingWhiteSpaceAndNewline];
    if ([self length] > 0) {
        return YES;
    }
    return NO;
}

- (NSString *)trimingWhiteSpaceAndNewline {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
