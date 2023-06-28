//
//  NoticeDanMuHeaderView.h
//  NoticeXi
//
//  Created by li lei on 2021/2/1.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeDanMuModel.h"
#import "NoticePlayerBokeView.h"
#import "NoticeDanMuMoveListView.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeDanMuHeaderView : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isInduce;
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, strong) UIButton *selfBtn;
@property (nonatomic, strong) UIButton *hotBtn;
@property (nonatomic, strong) UIButton *openBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) NoticePlayerBokeView *playeBoKeView;
@property (nonatomic, strong) NoticeDanMuModel *bokeModel;
@property (nonatomic, strong) NoticeDanMuMoveListView *listView;
@property (nonatomic,copy) void (^hideDanMuBlock)(BOOL isHide);
@property (nonatomic,copy) void (^hideinputBlock)(BOOL isHide);
@property (nonatomic,copy) void (^hideKeyBordBlock)(BOOL isHide);
@property (nonatomic,copy) void (^clickListBlock)(BOOL list);
@end

NS_ASSUME_NONNULL_END
