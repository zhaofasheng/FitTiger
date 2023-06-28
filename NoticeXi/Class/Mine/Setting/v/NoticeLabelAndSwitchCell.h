//
//  NoticeLabelAndSwitchCell.h
//  NoticeXi
//
//  Created by li lei on 2018/10/24.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "BaseCell.h"
#import "MySwitch.h"
@protocol SwitchChoiceDelegate <NSObject>

- (void)choiceTag:(NSInteger)tag withIsOn:(BOOL)isOn section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NoticeLabelAndSwitchCell : BaseCell
@property (nonatomic, strong) UILabel *mainL;
@property (nonatomic, strong) UISwitch *switchButton;
@property (nonatomic, assign) NSInteger choiceTag;
@property (nonatomic, assign) NSInteger choiceSection;
@property (nonatomic, weak) id<SwitchChoiceDelegate>delegate;
@property (nonatomic, strong) MySwitch *mySwitch;
@property (nonatomic, strong) UIView *line;
@end

NS_ASSUME_NONNULL_END
