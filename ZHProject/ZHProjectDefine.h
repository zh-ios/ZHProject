//
//  ZHProjectDefine.h
//  ZHProject
//
//  Created by zh on 2018/7/26.
//  Copyright © 2018年 autohome. All rights reserved.
//

#ifndef ZHProjectDefine_h
#define ZHProjectDefine_h


#define kIsIphoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kNavbarHeight (kIsIphoneX ? 88 : 64)
#define kTabbarHeight (kIsIphoneX ? 83 : 49)
// 底部的安全距离
#define kBottomSafeArea     (kIsIphoneX ? 35 : 0)

// 顶部的安全距离,包括状态栏的高度
#define kTopSafeArea        (kIsIphoneX ? 44 : 0)

#endif /* ZHProjectDefine_h */
