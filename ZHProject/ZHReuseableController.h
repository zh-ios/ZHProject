//
//  ZHReuseableController.h
//  ZHProject
//
//  Created by zh on 2018/9/12.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ZHReuseableController : UIViewController

@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, copy) NSString *instanceName;

- (void)reloadData;

@end
