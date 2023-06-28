//
//  NoticeHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2018/10/19.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeHeaderView.h"

@implementation NoticeHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LEFTSPACE,0, 200,45)];
        label.font = SIXTEENTEXTFONTSIZE;
        label.textColor =[UIColor colorWithHexString:@"#A1A7B3"];
        [self.contentView addSubview:label];
        _mainTitleLabel = label;
    }
    return self;
}


@end
