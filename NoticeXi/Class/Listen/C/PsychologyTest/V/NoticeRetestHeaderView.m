//
//  NoticeRetestHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2019/1/29.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeRetestHeaderView.h"
#import "DDHAttributedMode.h"
@implementation NoticeRetestHeaderView
{
    
    UILabel *_numL;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-111)/2, 27, 111, 30)];
        [self addSubview:imageV1];
        
        UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-186)/2, CGRectGetMaxY(imageV1.frame)+16, 186, 41)];
        if (![NoticeTools isWhiteTheme]) {
            imageV2.image = UIImageNamed(@"Image_retest_headerijy");
            imageV1.image = UIImageNamed(@"Image_retest_headerjy");
        }else{
            if ([NoticeTools isSimpleLau]) {
                imageV2.image = UIImageNamed(@"Image_retest_headerij");
                imageV1.image = UIImageNamed(@"Image_retest_headerj");
            }else{
                imageV2.image = UIImageNamed(@"Image_retest_headerif");
                imageV1.image = UIImageNamed(@"Image_retest_headerf");
            }
        }

        [self addSubview:imageV2];
        
        //
        for (int i = 0; i < 2; i++) {
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imageV2.frame)+27+75*i, DR_SCREEN_WIDTH-30, 55)];
            imageV.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_retest_label":@"Image_retest_labely");
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7.5, DR_SCREEN_WIDTH-50, 40)];
            [imageV addSubview:label];
            imageV.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
            [imageV addGestureRecognizer:tap];
            
            label.textAlignment = NSTextAlignmentCenter;
            label.font = FOURTHTEENTEXTFONTSIZE;
            label.textColor = GetColorWithName(VMainTextColor);
            if (i == 0) {
                imageV.tag = 1;
                self.typeImageView = imageV;
                _nameL = label;
            }else{
                imageV.tag = 0;
                self.tongzuImageView = imageV;
                _numL = label;
            }
            [self addSubview:imageV];
        }
    }
    return self;
}

- (void)tapView:(UITapGestureRecognizer *)tap{
    UIImageView *imageView = (UIImageView *)tap.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapWithTypeOrNum:)]) {
        [self.delegate tapWithTypeOrNum:imageView.tag];
    }
}

- (void)setType:(NSString *)type{
    //listen.yourlx
    _nameL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@  %@",GETTEXTWITE(@"listen.yourlx"),type] setColor:GetColorWithName(VMainThumeColor) setLengthString:type beginSize:[GETTEXTWITE(@"listen.yourlx") length]+2];
}
- (void)setAddnums:(NSString *)addnums{
    _numL.attributedText = [DDHAttributedMode setColorString:[NSString stringWithFormat:@"%@  %@",@"今天新加入的“同族”有",[NSString stringWithFormat:@"%@名",addnums]] setColor:GetColorWithName(VMainThumeColor) setLengthString:[NSString stringWithFormat:@"%@名",addnums] beginSize:[@"今天新加入的“同族”有" length]+2];
}

@end
