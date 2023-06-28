//
//  NoticeBBSDetailHeaderView.m
//  NoticeXi
//
//  Created by li lei on 2020/11/6.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSDetailHeaderView.h"

@implementation NoticeBBSDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,15,DR_SCREEN_WIDTH-30, 17)];
        _titleL.font = XGEightBoldFontSize;
        _titleL.textColor = GetColorWithName(VMainTextColor);
        _titleL.numberOfLines = 0;
        [self addSubview:_titleL];
        
        self.contentTextL = [[UILabel alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(_titleL.frame)+20,DR_SCREEN_WIDTH-110,0)];
        self.contentTextL.textColor = GetColorWithName(VMainTextColor);
        self.contentTextL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentTextL.numberOfLines = 0;
        [self addSubview:self.contentTextL];
        
        self.imageViewS = [[NoticeVoiceImgList alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.contentTextL.frame)+15, DR_SCREEN_WIDTH, 0)];
        [self addSubview:self.imageViewS];
    }
    return self;
}

- (void)setBbsModel:(NoticeBBSModel *)bbsModel{
    _bbsModel = bbsModel;
    
    self.contentTextL.attributedText = bbsModel.allTextAttStr;
    self.contentTextL.numberOfLines = 0;
    
    self.titleL.text = bbsModel.title;
    
    self.imageViewS.hidden = bbsModel.annexsArr.count?NO:YES;

    _titleL.frame = CGRectMake(15, 15, DR_SCREEN_WIDTH-30, GET_STRHEIGHT(bbsModel.title, 19, DR_SCREEN_WIDTH-30)+10);
    self.contentTextL.frame = CGRectMake(15, CGRectGetMaxY(_titleL.frame)+20, DR_SCREEN_WIDTH-30, bbsModel.textHeight);
    
    CGFloat imagListheight = 0;
    if (bbsModel.annexsArr.count) {
        NSMutableArray *imgListArr = [NSMutableArray new];
        for (NoticeAnnexsModel *imgM in bbsModel.annexsArr) {
            [imgListArr addObject:imgM.annex_url];
        }
        
        if (bbsModel.annexsArr.count == 1) {
            self.imageViewS.frame = CGRectMake(0,CGRectGetMaxY(self.contentTextL.frame)+15, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*0.448);
            imagListheight = DR_SCREEN_WIDTH*0.448+15;
        }else if (bbsModel.annexsArr.count == 2){
            self.imageViewS.frame = CGRectMake(0,CGRectGetMaxY(self.contentTextL.frame)+15, DR_SCREEN_WIDTH, DR_SCREEN_WIDTH*0.373);
            imagListheight = DR_SCREEN_WIDTH*0.373+15;
        }else{
            self.imageViewS.frame = CGRectMake(0,CGRectGetMaxY(self.contentTextL.frame)+15, DR_SCREEN_WIDTH, (DR_SCREEN_WIDTH-46)/3);
            imagListheight = (DR_SCREEN_WIDTH-46)/3+15;
        }
        self.imageViewS.imgArr = imgListArr;
    }else{
        imagListheight = 0;
    }
    
    self.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH-30,50+self.bbsModel.textHeight+10+imagListheight+GET_STRHEIGHT(bbsModel.title, 19, DR_SCREEN_WIDTH-30)+10);
}
@end
