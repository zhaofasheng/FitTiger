//
//  NoticePhotoLookViewController.m
//  NoticeXi
//
//  Created by li lei on 2019/6/5.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticePhotoLookViewController.h"

@interface NoticePhotoLookViewController ()<NoticePhotoLookDelegate>
@property (nonatomic, strong) NoticePhotoNavView *navView;
@property (nonatomic, strong) NoticePhotoToolsView *toolView;
@property (nonatomic, strong) UIImage *saveImage;
@property (nonatomic, assign) BOOL isHide;
@end

@implementation NoticePhotoLookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.hidden = YES;
    YYPhotoGroupView *view = [[YYPhotoGroupView alloc] initWithGroupItems:self.lagerUrlArr];
    view.dataArr = self.allDataArr;
    view.isNeedTools = YES;
    view.delegate = self;
    [view presentFromImageView:self.imageCellView
                   toContainer:self.view
                      animated:YES completion:nil];
    
    self.navView = [[NoticePhotoNavView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT)];
    [self.navView.saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.toolView = [[NoticePhotoToolsView alloc] initWithFrame:CGRectMake(0,DR_SCREEN_HEIGHT-(49+45+BOTTOM_HEIGHT), DR_SCREEN_WIDTH, 49+45+BOTTOM_HEIGHT)];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.toolView];
    
    UISwipeGestureRecognizer *recognizer1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer1 setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [self.toolView addGestureRecognizer:recognizer1];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
     [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
     [self.toolView addGestureRecognizer:recognizer];
    
    __weak typeof(self) weakSelf = self;
    self.toolView.hideBlock = ^(BOOL backHide) {
        weakSelf.toolView.scrollView.scrollEnabled = NO;
         [UIView animateWithDuration:0.3 animations:^{
                weakSelf.toolView.frame = CGRectMake(0,(DR_SCREEN_HEIGHT-(49+45+BOTTOM_HEIGHT)), DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
            }];
    };
}


- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer{
    if (self.toolView.currentModel.content_type.intValue == 2) {
        if(recognizer.direction ==UISwipeGestureRecognizerDirectionDown) {
            [UIView animateWithDuration:0.3 animations:^{
                self.toolView.scrollView.scrollEnabled = NO;
                self.toolView.frame = CGRectMake(0,(DR_SCREEN_HEIGHT-(49+45+BOTTOM_HEIGHT)), DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
            }];
        }if(recognizer.direction ==UISwipeGestureRecognizerDirectionUp) {
            self.toolView.scrollView.scrollEnabled = YES;
            [UIView animateWithDuration:0.3 animations:^{
                 self.toolView.frame = CGRectMake(0,NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
             }];
        }
    }else{
        self.toolView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-(49+45+BOTTOM_HEIGHT), DR_SCREEN_WIDTH, 49+45+BOTTOM_HEIGHT);
    }

}

- (void)saveClick{
    if (!self.saveImage) {
        return;
    }
   __weak typeof(self) weakSelf = self;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
           
            [weakSelf.saveImage saveToAlbumWithCompletionBlock:^(NSURL * _Nullable assetURL, NSError * _Nullable error) {
                [weakSelf showToastWithText:[NoticeTools getLocalStrWith:@"yl.baocsus"]];
            }];
        }
    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"mineme.saveimg"]]];
    [sheet show];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapHideOrShow:(BOOL)hide{
    self.isHide = hide;
    [UIView animateWithDuration:0.1 animations:^{
        self.navView.frame = CGRectMake(0,hide? -NAVIGATION_BAR_HEIGHT:0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
        self.toolView.frame = CGRectMake(0,hide? DR_SCREEN_HEIGHT :(DR_SCREEN_HEIGHT-(49+45+BOTTOM_HEIGHT)), DR_SCREEN_WIDTH, 49+45+BOTTOM_HEIGHT);
    }];
}

- (void)scrollWithModel:(NoticeSmallArrModel *)model saveImage:(UIImage *)saveImage{
    self.navView.imgModel = model;
    self.saveImage = saveImage;
    
    if (![self.toolView.funView.currentModel.voice_id isEqualToString:model.currentModel.voice_id]) {
        self.toolView.currentModel = model.currentModel;
        self.toolView.isRefresh = YES;
    }
    self.toolView.funView.currentModel = model.currentModel;
    if (model.currentModel.content_type.intValue == 2) {
        self.toolView.scrollView.scrollEnabled = NO;
        self.toolView.frame = CGRectMake(0,(DR_SCREEN_HEIGHT-(49+45+BOTTOM_HEIGHT)), DR_SCREEN_WIDTH,DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT);
    }else{
        [UIView animateWithDuration:0.1 animations:^{
            self.navView.frame = CGRectMake(0,self.isHide? -NAVIGATION_BAR_HEIGHT:0, DR_SCREEN_WIDTH, NAVIGATION_BAR_HEIGHT);
            self.toolView.frame = CGRectMake(0,self.isHide? DR_SCREEN_HEIGHT :(DR_SCREEN_HEIGHT-(49+45+BOTTOM_HEIGHT)), DR_SCREEN_WIDTH, 49+45+BOTTOM_HEIGHT);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.toolView.isRefresh = YES;
}

@end
