//
//  SXScoreModel.h
//  JSONTest
//
//  Created by zh on 2018/8/2.
//  Copyright © 2018年 zh. All rights reserved.
//

#import "JSONModel.h"


@protocol SXScoreModel;

@interface SXScoreModel : JSONModel

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<SXScoreModel> *childList;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *parentId;
@end
