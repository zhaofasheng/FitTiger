//
//  NoticeCustumButton.h
//  NoticeXi
//
//  Created by li lei on 2019/3/4.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoticeCustumButton : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *selectView;
@property (nonatomic, assign) BOOL isSelect;
- (void)setImageView:(NSString *)imageName label:(NSString *)labelName;
@end

NS_ASSUME_NONNULL_END
