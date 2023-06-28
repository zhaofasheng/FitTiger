//
//  NoticeListPlayer.h
//  NoticeXi
//
//  Created by li lei on 2018/11/16.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeListPlayer : UIView
@property (nonatomic, strong) UILabel *timeL;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) NSString *timeLen;
- (void)refreWithFrame;
@end

NS_ASSUME_NONNULL_END
