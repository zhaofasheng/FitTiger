//
//  NoticePayView.h
//  NoticeXi
//
//  Created by li lei on 2021/9/25.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeOpenTbModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticePayView : UIView
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NoticeOpenTbModel *opTaoBao;
@property (nonatomic, assign) BOOL hasGoToBuy;//是否跳转了购买
@property (nonatomic, strong) NSString *orderNum;
- (void)show;

@end

NS_ASSUME_NONNULL_END
