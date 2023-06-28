//
//  NoticeHasSupportSectionView.m
//  NoticeXi
//
//  Created by li lei on 2023/5/10.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeHasSupportSectionView.h"
#import "UIView+CLSetRect.h"
@implementation NoticeHasSupportSectionView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithReuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 49)];
        sectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:sectionView];
        [sectionView setCornerOnTop:10];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 24, 24)];
        imageV.image = UIImageNamed(@"Image_helptit");
        [sectionView addSubview:imageV];
        
        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(39, 0, DR_SCREEN_WIDTH-40-78, 49)];
        self.contentL.font = XGSIXBoldFontSize;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [sectionView addSubview:self.contentL];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tieTap)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tieTap{
    if(self.tieBlock){
        self.tieBlock(self.tieId);
    }
}
@end
