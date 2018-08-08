//
//  ZHAlbumController.m
//  ZHProject
//
//  Created by zh on 2018/8/3.
//  Copyright © 2018年 autohome. All rights reserved.
//

#import "ZHAlbumController.h"
#import "ZHMediaFetcher.h"

@interface ZHAlbumCell ()
@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *nameL;
@end

@implementation ZHAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIImageView *posterImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 45, 45)];
    [self.contentView addSubview:posterImage];
    
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(posterImage.right+10, 0, 200, 20)];
    nameL.font = [UIFont boldSystemFontOfSize:15];
    [self.contentView addSubview:nameL];
    self.posterImageView = posterImage;
    self.nameL = nameL;
}

- (void)setAlbum:(ZHAlbumModel *)album {
    _album = album;
    
    [[ZHMediaFetcher shareFetcher] getPosterImageForAlbumModel:album completion:^(UIImage *image, NSDictionary *info) {
        self.posterImageView.image = image;
    }];
    self.nameL.text = album.name;
}

@end


@interface ZHAlbumController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ZHAlbumController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavbarHeight, self.view.width, self.view.height-kNavbarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [super viewDidLoad];
    
    [self initCustomNav];
}

- (void)initCustomNav {
    
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, kNavbarHeight)];
    navView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:navView];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(100, kTopSafeArea+10, self.view.width-100*2, 16)];
    titleL.font = [UIFont systemFontOfSize:15];
    titleL.textColor = [UIColor whiteColor];
    titleL.text = @"照片";
    titleL.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleL];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-60, kTopSafeArea+10, 60, 44)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:cancelBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *albumCellID = @"albumCellID";
    ZHAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:albumCellID];
    if (!cell) {
        cell = [[ZHAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:albumCellID];
    }
    ZHAlbumModel *model = self.albums[indexPath.row];
    cell.album = model;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --- targetAction
- (void)cancel:(UIButton *)btn {
    // TODO 点击取消回调
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
