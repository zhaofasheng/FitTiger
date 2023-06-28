//
//  NoticeCustumBackImageView.h
//  NoticeXi
//
//  Created by li lei on 2021/8/12.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGA.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeCustumBackImageView : UIImageView
@property (nonatomic, strong) SVGAParser *parser;
@property (nonatomic, strong) SVGAPlayer *svagPlayer;
@property (nonatomic, assign) BOOL noNeedPaopao;
@end

NS_ASSUME_NONNULL_END
