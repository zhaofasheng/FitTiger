//
//  NoticeChangeTextView.h
//  NoticeXi
//
//  Created by li lei on 2020/12/2.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChangeTextView : UIView
@property (nonatomic, strong) NSString *voiceContent;
@property (nonatomic, strong) UILabel *textL;
@property (nonatomic,retain) UIScrollView *alertView;
@end

NS_ASSUME_NONNULL_END
