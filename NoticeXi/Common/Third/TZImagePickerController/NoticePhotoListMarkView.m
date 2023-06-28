//
//  NoticePhotoListMarkView.m
//  NoticeXi
//
//  Created by li lei on 2020/10/14.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticePhotoListMarkView.h"

@implementation NoticePhotoListMarkView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DR_SCREEN_WIDTH-15, frame.size.height)];
        label.text = [NoticeTools getLocalStrWith:@"photo.mark"];
        label.font = TWOTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self addSubview:label];
    }
    return self;
}

@end
