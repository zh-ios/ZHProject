//
//  PluginModel.h
//  Router
//
//  Created by zh on 2018/9/21.
//  Copyright © 2018年 zh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PluginType){
    PluginType_Bussiness = 0,
    PluginType_CommonFunction,
    PluginType_FillingTabbar // 加在tabbar上的插件
};

NS_ASSUME_NONNULL_BEGIN


@interface PluginModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) PluginType pluginType;
@property (nonatomic, copy) NSString *pluginFrameworkName;
@property (nonatomic, copy) NSString *entryClassName;

@end

NS_ASSUME_NONNULL_END
