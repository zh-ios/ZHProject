//
//  SXAddScoreView.m
//  ZHProject
//
//  Created by zh on 2018/8/3.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "SXAddScoreView.h"
#import "SXScoreModel.h"

@interface SXAddScoreView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *coverBtn;
@property (nonatomic, strong) UITableView *firstTableView;
@property (nonatomic, strong) UITableView *secondTableView;
@property (nonatomic, strong) UITableView *thirdTableView;

@property (nonatomic, strong) NSIndexPath *firstTableViewSelectedIndexPath;
@property (nonatomic, strong) NSIndexPath *secondTableViewSelectedIndexPath;
@property (nonatomic, strong) NSIndexPath *thirdTableViewSelectedIndexPath;

@property (nonatomic, strong) SXScoreModel *firstSelectedModel;
@property (nonatomic, strong) SXScoreModel *thirdSelectedModel;
@property (nonatomic, strong) SXScoreModel *secondSelectedModel;
@end

@implementation SXAddScoreView

#define kAddScoreTableViewHeight             (150)


- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self initData];
    [self.firstTableView reloadData];
    [self.secondTableView reloadData];
}


- (UIButton *)coverBtn {
    if (!_coverBtn) {
        _coverBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _coverBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [_coverBtn addTarget:self action:@selector(coverBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverBtn;
}

- (UITableView *)firstTableView {
    if (!_firstTableView) {
        _firstTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _firstTableView.delegate = self;
        _firstTableView.dataSource = self;
        _firstTableView.backgroundColor = [UIColor whiteColor];
    }
    return _firstTableView;
}

- (UITableView *)secondTableView {
    if (!_secondTableView) {
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _secondTableView.delegate = self;
        _secondTableView.dataSource = self;
        _secondTableView.backgroundColor = [UIColor lightGrayColor];
    }
    return _secondTableView;
}

- (UITableView *)thirdTableView {
    if (!_thirdTableView) {
        _thirdTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _thirdTableView.delegate = self;
        _thirdTableView.dataSource = self;
        _thirdTableView.backgroundColor = [UIColor lightGrayColor];
    }
    return _thirdTableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
}

- (void)initData {
    self.firstSelectedModel = [self.dataArray firstObject];
//    self.secondSelectedModel = [self.firstSelectedModel.childList firstObject];
    self.firstTableViewSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    self.secondTableViewSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

- (void)initSubviews {
    [self addSubview:self.coverBtn];
    [self.coverBtn addSubview:self.firstTableView];
    [self.coverBtn addSubview:self.secondTableView];
    [self.coverBtn addSubview:self.thirdTableView];
    self.thirdTableView.hidden = NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.coverBtn.frame = self.bounds;
    self.firstTableView.frame = CGRectMake(0, 0, self.width*0.5, kAddScoreTableViewHeight);
    self.secondTableView.frame = CGRectMake(self.width*0.5, 0, self.width*0.5, kAddScoreTableViewHeight);

}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.firstTableView) {
        return self.dataArray.count;
    }
    if (tableView == self.secondTableView) {
        return self.firstSelectedModel.childList.count;
    }
    if (tableView == self.thirdTableView) {
        return self.secondSelectedModel.childList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"addscorecellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    if (tableView == self.firstTableView) {
        SXScoreModel *model = self.dataArray[indexPath.row];
        cell.textLabel.text = model.name;
        if (indexPath == self.firstTableViewSelectedIndexPath) {
            cell.textLabel.textColor = [UIColor redColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        
    }
    if (tableView == self.secondTableView) {
        SXScoreModel *model = self.firstSelectedModel.childList[indexPath.row];
        cell.textLabel.text = model.name;
        if (indexPath == self.secondTableViewSelectedIndexPath) {
            cell.textLabel.textColor = [UIColor redColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    if (tableView == self.thirdTableView) {
        SXScoreModel *model = self.secondSelectedModel.childList[indexPath.row];
        cell.textLabel.text = model.name;
        if (indexPath == self.thirdTableViewSelectedIndexPath) {
            cell.textLabel.textColor = [UIColor redColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.firstTableView) {
        self.firstTableViewSelectedIndexPath = indexPath;
        self.firstSelectedModel = self.dataArray[indexPath.row];
        [self.firstTableView reloadData];
        [self.secondTableView reloadData];
    }
    if (tableView == self.secondTableView) {
        self.secondTableViewSelectedIndexPath = indexPath;
        self.secondSelectedModel = self.firstSelectedModel.childList[indexPath.row];
        
        [self resetTableViews];
        
        // 就两个tableVIew的情况
        if (self.secondSelectedModel.childList.count == 0) {
            if (self.finishSelectBlock) {
                self.finishSelectBlock(self.firstSelectedModel, self.secondSelectedModel, self.thirdSelectedModel);
            }
            [self dismiss];
        } else {
            self.thirdTableViewSelectedIndexPath = nil;
            [self.secondTableView reloadData];
            [self.thirdTableView reloadData];
        }
    }
    if (tableView == self.thirdTableView) {
        self.thirdTableViewSelectedIndexPath = indexPath;
        self.thirdSelectedModel = self.secondSelectedModel.childList[indexPath.row];
        
        if (self.finishSelectBlock) {
            self.finishSelectBlock(self.firstSelectedModel, self.secondSelectedModel, self.thirdSelectedModel);
        }
        
        [self dismiss];
    }
}

- (void)resetTableViews {
    if (self.secondSelectedModel.childList.count == 0) {
        self.firstTableView.frame = CGRectMake(0, 0, self.width*0.5, kAddScoreTableViewHeight);
        self.secondTableView.frame = CGRectMake(self.width*0.5, 0, self.width*0.5, kAddScoreTableViewHeight);
        self.thirdTableView.hidden = YES;
    } else {
        self.firstTableView.frame = CGRectMake(0, 0, self.width/3, kAddScoreTableViewHeight);
        self.secondTableView.frame = CGRectMake(self.width/3, 0, self.width/3, kAddScoreTableViewHeight);
        self.thirdTableView.frame = CGRectMake(self.width/3*2, 0, self.width/3, kAddScoreTableViewHeight);
        self.thirdTableView.hidden = NO;
    }
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)coverBtnOnClick:(UIButton *)btn {
    [self dismiss];
}

@end
