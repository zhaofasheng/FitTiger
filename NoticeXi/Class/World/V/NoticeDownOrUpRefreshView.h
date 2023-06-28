//
//  NoticeDownOrUpRefreshView.h
//  NoticeXi
//
//  Created by li lei on 2021/7/10.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGA.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDownOrUpRefreshView : UIView
@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) SVGAPlayer *svagPlayer;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, strong) UILabel *textL;
@property (nonatomic, strong) NSMutableArray *whiteArr;
@property (nonatomic, strong) NSMutableArray *nightArr;
@property (nonatomic, strong) NSMutableArray *darkArr;
@property (nonatomic, strong) NSMutableArray *monArr;
- (void)refreshText;
@end

NS_ASSUME_NONNULL_END
