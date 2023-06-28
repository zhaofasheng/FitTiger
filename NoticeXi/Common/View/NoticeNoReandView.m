//
//  NoticeNoReandView.m
//  NoticeXi
//
//  Created by li lei on 2020/10/15.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeNoReandView.h"

@implementation NoticeNoReandView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.image = UIImageNamed(@"Image_noread_b");
        self.numL = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 30,28)];
        self.numL.textColor = GetColorWithName(VMainThumeWhiteColor);
        self.numL.font = [UIFont systemFontOfSize:12];
        self.numL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numL];
    }
    return self;
}
@end
