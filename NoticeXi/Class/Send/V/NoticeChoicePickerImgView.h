//
//  NoticeChoicePickerImgView.h
//  NoticeXi
//
//  Created by li lei on 2022/3/28.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeChoicePickerImgView : UIView

@property (nonatomic, strong) UIView *keyView;
@property (nonatomic, copy) void(^typeChoiceBlock)(BOOL isImagPicker);
- (void)show;
@end

NS_ASSUME_NONNULL_END
