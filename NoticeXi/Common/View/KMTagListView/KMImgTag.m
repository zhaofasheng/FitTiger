//
//  KMImgTag.m
//  NoticeXi
//
//  Created by li lei on 2023/4/16.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "KMImgTag.h"

@implementation KMImgTag

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.nameL = [[UILabel alloc] init];
        self.nameL.font = FOURTHTEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self addSubview:self.nameL];
        
        self.layer.cornerRadius = 16;
        self.layer.masksToBounds = YES;
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 6, 20, 20)];
        [self addSubview:self.imgView];
    }
    return self;
}

- (void)setImg:(NSString *)imgUrl name:(NSString *)name{
    self.nameL.text = name;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    
    CGFloat strWidth = GET_STRWIDTH(name, 14, 32);
    CGRect frame = self.frame;
    frame.size = CGSizeMake(strWidth+6+6+20+2, 32);
    self.nameL.frame = CGRectMake(8+20, 0, strWidth, 32);
    self.frame = frame;

}
@end
