//
//  NoticeLeaderUserView.h
//  NoticeXi
//
//  Created by li lei on 2021/7/19.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGA.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeLeaderUserView : UIView
@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) SVGAPlayer *svagPlayer;
- (void)show;
@end

NS_ASSUME_NONNULL_END
