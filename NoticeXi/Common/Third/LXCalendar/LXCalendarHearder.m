//
//  LXCalendarHearder.m
//  LXCalendar
//
//  Created by chenergou on 2017/11/2.
//  Copyright © 2017年 漫漫. All rights reserved.
//

#import "LXCalendarHearder.h"
#import "LxButton.h"
@interface LXCalendarHearder()
@property (strong, nonatomic)  LxButton *leftBtn;
@property (strong, nonatomic)  LxButton *rightBtn;

@end
@implementation LXCalendarHearder

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.font = XGEightBoldFontSize;
        self.dateLabel.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.dateLabel];
        
        self.leftBtn = [[LxButton alloc] initWithFrame:CGRectMake((frame.size.width-100-GET_STRWIDTH(@"2022年04月", 19, 50))/2, 0, 50, 50)];
        [self.leftBtn setImage:UIImageNamed(@"Image_leftdate") forState:UIControlStateNormal];
        [self.leftBtn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.leftBtn];
        
        self.rightBtn = [[LxButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame)+GET_STRWIDTH(@"2022年04月", 19, 50), 0, 50, 50)];
        [self.rightBtn setImage:UIImageNamed(@"Image_rightdate") forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
    }
    return self;
}

-(void)setDateStr:(NSString *)dateStr{
    _dateStr = dateStr;
    
    self.dateLabel.text = dateStr;
}

- (void)leftClick:(LxButton *)sender {
    if (self.leftClickBlock) {
        self.leftClickBlock();
    }
}
- (void)rightClick:(LxButton *)sender {
    
    if (self.rightClickBlock) {
        self.rightClickBlock();
    }
}
-(void)setIsShowLeftAndRightBtn:(BOOL)isShowLeftAndRightBtn{
    _isShowLeftAndRightBtn = isShowLeftAndRightBtn;
    self.leftBtn.hidden = self.rightBtn.hidden = !isShowLeftAndRightBtn;
}
-(void)hideLeftBtnAndRightBtn{
    self.leftBtn.hidden = self.rightBtn.hidden = YES;
}

@end
