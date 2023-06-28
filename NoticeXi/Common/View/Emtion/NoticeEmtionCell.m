//
//  NoticeEmtionCell.m
//  NoticeXi
//
//  Created by li lei on 2020/10/19.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeEmtionCell.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
@implementation NoticeEmtionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 2;
        self.layer.shadowColor = GetColorWithName(VMainTextColor).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 2;
        self.backgroundColor = [GetColorWithName(VBackColor) colorWithAlphaComponent:0];
        
        _sendImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(0,0,(DR_SCREEN_WIDTH-80)/5,(DR_SCREEN_WIDTH-80)/5)];
        _sendImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _sendImageView.clipsToBounds = YES;
        _sendImageView.layer.cornerRadius = 3;
        _sendImageView.layer.masksToBounds = YES;
        _sendImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_sendImageView];
        
        self.choiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-22,0,22,22)];
        [self.contentView addSubview:self.choiceImageView];
        self.choiceImageView.image = UIImageNamed(@"Image_nochoiceem");
        self.choiceImageView.hidden = YES;
        
        self.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.25;
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)longPressGestureRecognized:(id)sender{
    if (self.isHot || self.isCu) {
        UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
        UIGestureRecognizerState longPressState = longPress.state;
        if (longPressState == UIGestureRecognizerStateBegan) {
            self.bubble = [[PGBubble alloc] initWithFrame:CGRectMake(0, 0, 128,173)];
            self.bubble.type = 3;
            self.bubble.url = self.emotionModel.picture_url;
            [self.bubble showWithView:self];
            __weak typeof(self) weakSelf = self;
            self.bubble.clickBlock = ^(NSInteger type) {
                AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
                BaseNavigationController *nav = nil;
                if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                    nav = tabBar.selectedViewController;//获取到当前视图的导航视图
                }
                if (!weakSelf.emotionModel.picture_uri) {
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"group.cannoaddemo"]];
                    return;
                }
                [nav.topViewController showHUD];
                NSMutableDictionary *postParm = [NSMutableDictionary new];
           
                [postParm setObject:weakSelf.emotionModel.bucket_id?weakSelf.emotionModel.bucket_id:@"0" forKey:@"bucketId"];
                [postParm setObject:weakSelf.emotionModel.picture_uri forKey:@"pictureUri"];
                [postParm setObject:@"0" forKey:@"hotPicture"];
                [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"user/%@/picture",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.7.7+json" isPost:YES parmaer:postParm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    if (success) {
                        [YZC_AlertView showViewWithTitleMessage:[NoticeTools getLocalStrWith:@"emtion.scSus"]];
                        if (weakSelf.collectBlock) {
                            weakSelf.collectBlock(YES);
                        }
                    }
                    [nav.topViewController hideHUD];
                } fail:^(NSError * _Nullable error) {
                    [nav.topViewController hideHUD];
                }];
            };
        }
        
        return;
    }
    if (self.isManager || self.row == 0) {
        return;
    }
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    if (longPressState == UIGestureRecognizerStateBegan) {

        self.bubble = [[PGBubble alloc] initWithFrame:CGRectMake(0, 0, 128,173)];
        self.bubble.url = self.emotionModel.picture_url;
        
        __weak typeof(self) weakSelf = self;
        self.bubble.clickBlock = ^(NSInteger type) {
            AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
            BaseNavigationController *nav = nil;
            if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
                nav = tabBar.selectedViewController;//获取到当前视图的导航视图
            }
            [nav.topViewController showHUD];
            NSMutableArray *arr = [NSMutableArray new];
            [arr addObject:weakSelf.emotionModel.pictureId];
            NSMutableDictionary *parm = [NSMutableDictionary new];
            [parm setObject:[NoticeTools arrayToJSONString:arr] forKey:@"pictureId"];
            [nav.topViewController showHUD];
            if (type == 0) {
                [[DRNetWorking shareInstance] requestWithPatchPath:[NSString stringWithFormat:@"%@/picture",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.7.1+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        if (weakSelf.refashBlock) {
                            weakSelf.refashBlock(YES);
                        }
                      }
                    [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"group.moveemosus"]];
                } fail:^(NSError * _Nullable error) {
                    [nav.topViewController hideHUD];
                }];
            }else{
                [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"user/%@/pictureDel",[NoticeTools getuserId]] Accept:@"application/vnd.shengxi.v4.7.1+json" parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
                    [nav.topViewController hideHUD];
                    if (success) {
                        [nav.topViewController showToastWithText:[NoticeTools getLocalStrWith:@"emtion.deleSuc"]];
                        if (weakSelf.refashBlock) {
                            weakSelf.refashBlock(YES);
                        }
                    }
                } fail:^(NSError * _Nullable error) {
                    [nav.topViewController hideHUD];
                }];
            }
        };
        [self.bubble showWithView:self];
    }
}

- (void)setEmotionModel:(NoticeEmotionModel *)emotionModel{
    _emotionModel = emotionModel;
    if (emotionModel.isLocal) {
        _sendImageView.image = UIImageNamed(@"Image_addemotionb");
    }else{
        //__weak typeof(self) weakSelf = self;
        
        [_sendImageView setImageWithURL:[NSURL URLWithString:emotionModel.picture_url] placeholder:GETUIImageNamed(@"img_empty") options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {

//            CGFloat imageWidth = CGImageGetWidth(image.CGImage);
//            CGFloat imageHeight = CGImageGetHeight(image.CGImage);

        }];
    }
    
    if (self.isManager && self.isBeginChoice) {
        self.choiceImageView.hidden = NO;
        self.choiceImageView.image = emotionModel.isChoice?UIImageNamed(@"Image_choiceadd_b"):UIImageNamed(@"Image_nochoiceem");
    }else{
        self.choiceImageView.hidden = YES;
    }
}

@end
