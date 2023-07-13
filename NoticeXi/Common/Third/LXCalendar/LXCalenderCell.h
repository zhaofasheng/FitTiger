//
//  LXCalenderCell.h
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXCalendarDayModel.h"
#import "NoticeTieTieModel.h"
@interface LXCalenderCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *label;
@property (nonatomic, assign) BOOL isSmall;
@property(nonatomic,assign) BOOL     isCanTap;
@property (nonatomic, strong) UILabel *smallTimeL;
@property (nonatomic, strong) UIImageView *statusImageView;
@property(nonatomic,strong)LXCalendarDayModel *model;
@property(nonatomic,strong)LXCalendarDayModel *smallModel;
@property(nonatomic,strong)LXCalendarDayModel *nomerModel;
@property(nonatomic,strong)LXCalendarDayModel *choiceModel;
@property (nonatomic, strong) NoticeTieTieModel *currentTieTieModel;
@property (nonatomic, strong) NSMutableArray *netDataArr;
@property (nonatomic, strong) UIImageView *imageView;

@end
