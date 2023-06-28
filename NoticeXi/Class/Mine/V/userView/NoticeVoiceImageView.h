//
//  NoticeVoiceImageView.h
//  NoticeXi
//
//  Created by li lei on 2018/10/29.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NoticeTimeStroyImageTapDelegate <NSObject>

@optional
- (void)choiceTapImage:(UIImageView *)image;
- (void)changeFeminatu;
- (void)funViewChangeHide;
- (void)scrollImageIndex:(NSInteger)index allNum:(NSInteger)allNum;
@end

@interface NoticeVoiceImageView : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *imgArr;
@property (nonatomic, assign) BOOL isTime;
@property (nonatomic, assign) BOOL isLocaImage;
@property (nonatomic, weak) id <NoticeTimeStroyImageTapDelegate>delegate;
@property (nonatomic, assign) BOOL isOther;
@property (nonatomic, assign) BOOL isTimeList;
@property (nonatomic, strong) UILabel *pageL;
@property (nonatomic, strong) UIButton *closeBtn0;
@property (nonatomic, strong) UIButton *closeBtn1;
@property (nonatomic, strong) UIButton *closeBtn2;
@property (nonatomic, copy) void(^imgBlock)(NSInteger tag);
@end

NS_ASSUME_NONNULL_END
