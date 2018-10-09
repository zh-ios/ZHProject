//
//  InvocationTool.h
//  Router
//
//  Created by zh on 2018/9/21.
//  Copyright © 2018年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InvocationTool : NSObject



+ (NSInvocation *)invocationWithClassName:(NSString *)clsName
                                 method:(NSString *)method
                                 params:(NSArray *)params;

@end

NS_ASSUME_NONNULL_END
