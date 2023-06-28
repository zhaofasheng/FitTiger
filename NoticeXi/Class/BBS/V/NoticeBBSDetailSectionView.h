//
//  NoticeBBSDetailSectionView.h
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeBBSDetailSectionView : UITableViewHeaderFooterView
@property (nonatomic,copy) void (^showTypeBlock)(NSInteger type);
@end

NS_ASSUME_NONNULL_END
