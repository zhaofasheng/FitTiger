//
//  NoticeSupportFootView.m
//  NoticeXi
//
//  Created by li lei on 2023/5/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeSupportFootView.h"
#import "UIView+CLSetRect.h"
@implementation NoticeSupportFootView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 15)];
        sectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:sectionView];
        [sectionView setCornerOnBottom:10];

    }
    return self;
}

@end
