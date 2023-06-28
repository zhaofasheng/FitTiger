//
//  NoticeChoiceVoiceTimeController.m
//  NoticeXi
//
//  Created by li lei on 2021/4/16.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeChoiceVoiceTimeController.h"

#import "CXDatePickerView.h"
#import "NSDate+CXCategory.h"

@interface NoticeChoiceVoiceTimeController ()

@end

@implementation NoticeChoiceVoiceTimeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    
    self.navBarView.titleL.text = [NoticeTools getLocalStrWith:@"mineme.shaixuan"];
    self.navBarView.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    self.tableView.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-40-45-BOTTOM_HEIGHT);
    self.tableView.tableHeaderView = self.typeChoiceView;
    self.tableView.backgroundColor = self.view.backgroundColor;
   
    [self setCHoice:self.typeChoiceView];

    UIButton *reSetBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tableView.frame), (DR_SCREEN_WIDTH-40-30)/3, 45)];
    reSetBtn.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    reSetBtn.layer.cornerRadius = 45/2;
    reSetBtn.layer.masksToBounds = YES;
    [reSetBtn setTitle:[NoticeTools getLocalStrWith:@"intro.reset"] forState:UIControlStateNormal];
    [reSetBtn setTitleColor:[UIColor colorWithHexString:@"#5C5F66"] forState:UIControlStateNormal];
    reSetBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [self.view addSubview:reSetBtn];
    [reSetBtn addTarget:self action:@selector(resetClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(reSetBtn.frame)+15, reSetBtn.frame.origin.y,DR_SCREEN_WIDTH-40-15-reSetBtn.frame.size.width, 45)];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
    sureBtn.layer.cornerRadius = 45/2;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:[NoticeTools getLocalStrWith:@"main.sure"] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = EIGHTEENTEXTFONTSIZE;
    [self.view addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)resetClick{
    [self.typeChoiceView removeFromSuperview];
    NoticeVoiceChoiceView *choiceView = [[NoticeVoiceChoiceView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 460)];
    [self setCHoice:choiceView];
    self.tableView.tableHeaderView = choiceView;
    self.typeChoiceView = choiceView;
    
    self.type = 0;
    self.voiceType = 0;
    self.shareType = 0;
    self.status = nil;
    self.year = nil;
    self.mon = nil;
    self.fromDay = nil;
    self.toDay = nil;
    if (self.newViewBlock) {
        self.newViewBlock(self.typeChoiceView);
    }
    if (self.typeBlock) {
        self.typeBlock(self.type, self.year, self.mon, self.fromDay, self.toDay, self.voiceType, self.shareType, self.status);
    }
}

- (void)setCHoice:(NoticeVoiceChoiceView *)choiceView{
    __block NoticeChoiceVoiceTimeController *blockSelf = self;
    //__weak typeof(self) weakSelf = self;
    choiceView.choiceTimeBlock = ^(NSInteger typea) {
        NSString *formatStr = nil;
        NSString *titleStr = nil;
        blockSelf.type = typea+1;
        CXDatePickerStyle style = 0;
        if (typea == 0) {
            formatStr = @"yyyy";
            style = CXDateYear;
            titleStr = @"选择年份";
        }else if (typea == 1){
            formatStr = @"yyyy-MM";
            style = CXDateYearMonth;
            titleStr = [NoticeTools getLocalStrWith:@"intro.choicemon"];
        }else{
            formatStr = @"yyyy-MM-dd";
            style = CXDateYearMonthDay;
            titleStr = [NoticeTools getLocalStrWith:@"intro.choiceday"];
        }
        
        CXDatePickerView *datepicker = [[CXDatePickerView alloc] initWithDateStyle:style completeBlock:^(NSDate *selectDate) {
            
            NSString *dateString = [selectDate cx_stringWithFormat:formatStr];
             if(typea == 1){
                [blockSelf.typeChoiceView.timeButton setTitle:dateString forState:UIControlStateNormal];
                blockSelf.mon = dateString;
            }
            
            else if (typea == 3){
                NSInteger fromT = [[dateString stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
                NSInteger toT = [[blockSelf.toDay stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
                if (toT > 0) {
                    if (fromT > toT) {
                        [self showToastWithText:[NoticeTools getLocalStrWith:@"intro.tostada1"]];
                        return;
                    }
                }
                [blockSelf.typeChoiceView.timeButton2 setTitle:dateString forState:UIControlStateNormal];
                blockSelf.fromDay = dateString;
            }else if (typea == 4){
                NSInteger toT = [[dateString stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
                NSInteger fromT = [[blockSelf.fromDay stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
                if (fromT > 0) {
                    if (fromT > toT) {
                        [self showToastWithText:[NoticeTools getLocalStrWith:@"intro.tostada2"]];
                        return;
                    }
                }
                [blockSelf.typeChoiceView.timeButton3 setTitle:dateString forState:UIControlStateNormal];
                blockSelf.toDay = dateString;
            }
        }];
        datepicker.timeBlock = ^(NSString *yearTime) {
            [blockSelf.typeChoiceView.timeButton setTitle:yearTime forState:UIControlStateNormal];
            blockSelf.year = yearTime;
        };
    
        datepicker.headerTitle = titleStr;
        datepicker.hideBackgroundYearLabel = YES;
        datepicker.datePickerFont = SIXTEENTEXTFONTSIZE;
        datepicker.datePickerSelectColor = [UIColor colorWithHexString:@"#25262E"];
        datepicker.datePickerColor = [UIColor colorWithHexString:@"#A1A7B3"];
        datepicker.datePickerSelectFont = XGEightBoldFontSize;
        [datepicker show];
    };
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    choiceView.choiceClickBlock = ^(NSInteger typea) {
        blockSelf.type = typea+1;
        blockSelf.year = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy"];
        blockSelf.fromDay = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy-MM-dd"];
        blockSelf.toDay = blockSelf.fromDay;
        blockSelf.mon = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy-MM"];
    };
    
    choiceView.voiceTypeBlock = ^(NSInteger voiceType){
        blockSelf.voiceType = voiceType;
    };
    
    choiceView.shareClickBlock = ^(NSInteger voiceType) {
        blockSelf.shareType = voiceType;
    };
    
    choiceView.statusClickBlock = ^(NSString * _Nonnull status) {
        blockSelf.status = status;
    };
}

- (void)sureClick{
    if (self.typeBlock) {
        self.typeBlock(self.type, self.year, self.mon, self.fromDay, self.toDay, self.voiceType, self.shareType, self.status);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
