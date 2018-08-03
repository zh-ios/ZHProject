//
//  SXAddScoreView.h
//  ZHProject
//
//  Created by zh on 2018/8/3.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXScoreModel.h"
@interface SXAddScoreView : UIView

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) void (^finishSelectBlock)(SXScoreModel *_Nonnull first,SXScoreModel *_Nonnull second, SXScoreModel *_Nullable third);

- (void)show;

- (void)dismiss;

@end
