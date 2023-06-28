//
//  NoticePickerShowController.m
//  NoticeXi
//
//  Created by li lei on 2020/9/1.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticePickerShowController.h"
#import "NoticeSpecialModel.h"
@interface NoticePickerShowController ()
@property (nonatomic, strong) UIImageView *moveImageView;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@implementation NoticePickerShowController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.moveImageView = [[UIImageView alloc] init];
    self.moveImageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
    longPress.minimumPressDuration = 0.3;
    [self.moveImageView addGestureRecognizer:longPress];
    [self.tableView registerClass:[BaseCell class] forCellReuseIdentifier:@"cell"];
    [self requestImage];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    self.needBackGroundView = YES;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    [self.navBarView.rightButton setImage:UIImageNamed(@"Image_closepic") forState:UIControlStateNormal];
    [self.navBarView.rightButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    self.navBarView.backButton.hidden = YES;
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)longPressGestureRecognized:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    if (longPressState == UIGestureRecognizerStateBegan) {
        __weak typeof(self) weakSelf = self;
        LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [weakSelf.moveImageView.image saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
                    [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"yl.baocsus"]];
                }];
            }
        } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"mineme.saveimg"]]];
        [sheet show];
    }
}

- (void)requestImage{
    [self.moveImageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:GETUIImageNamed(@"img_empty") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            self.moveImageView.frame = CGRectMake(15, 0, DR_SCREEN_WIDTH-30, (DR_SCREEN_WIDTH-30)*image.size.height/image.size.width);
            self.cellHeight = (DR_SCREEN_WIDTH-15)*image.size.height/image.size.width;
            [self.tableView reloadData];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.userInteractionEnabled = YES;
    cell.backgroundColor = self.view.backgroundColor;
    cell.contentView.backgroundColor = self.view.backgroundColor;
    [self.moveImageView removeFromSuperview];
    [cell.contentView addSubview:self.moveImageView];
    return cell;
}
@end
