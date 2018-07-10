//
//  XCTextField.h
//  XCTextFieldTest
//
//  Created by zh on 2018/7/6.
//  Copyright © 2018年 zh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCTextField : UITextField

@property (nonatomic, strong) UIFont *placeHolderFont;
@property (nonatomic, strong) UIColor *placeHolderColor;

// 如果要设置左侧边距，创建一个空白leftView 。

@end
