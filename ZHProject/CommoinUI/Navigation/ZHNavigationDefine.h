//
//  ZHNavigationDefine.h
//  ZHProject
//
//  Created by zh on 2018/9/27.
//  Copyright © 2018年 autohome. All rights reserved.
//

#ifndef ZHNavigationDefine_h
#define ZHNavigationDefine_h

typedef NS_ENUM (NSInteger, NaviAnimationType) {
    NaviAnimationType_Right2Left = 0, // push 进去
    NaviAnimationType_Bottom2Top,  // push进去 类似present动画
    NaviAnimationType_Left2Right, // pop 出来
    NaviAnimationType_Top2Bottom //  pop 出来类似 dismiss动画
};


#endif /* ZHNavigationDefine_h */
