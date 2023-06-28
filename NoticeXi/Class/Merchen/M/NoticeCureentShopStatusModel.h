//
//  NoticeCureentShopStatusModel.h
//  NoticeXi
//
//  Created by li lei on 2022/7/7.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCureentShopStatusModel : NSObject

@property (nonatomic, strong) NSString *apply_stage;//1未实名 2未绑定提现方式 3未设置店名 4待审核 5审核失败 6审核通过
@property (nonatomic, assign) NSInteger status;

@end

NS_ASSUME_NONNULL_END
