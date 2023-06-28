//
//  NoticeVoiceTypeCell.m
//  NoticeXi
//
//  Created by li lei on 2022/3/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceTypeCell.h"

@implementation NoticeVoiceTypeCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 72, 72)];
        self.playView.layer.cornerRadius = 72/2;
        self.playView.layer.masksToBounds = YES;
        self.playView.layer.borderWidth = 1.5;
        self.playView.layer.borderColor = [UIColor blackColor].CGColor;
        [self.contentView addSubview:self.playView];
        self.playView.hidden = YES;
        
        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, 64, 64)];
        [self.contentView addSubview:self.titleImageView];
        self.titleImageView.layer.cornerRadius = 32;
        self.titleImageView.layer.masksToBounds = YES;
        
        self.nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleImageView.frame)+8, 72, 20)];
        self.nameL.textAlignment = NSTextAlignmentCenter;
        self.nameL.font = FOURTHTEENTEXTFONTSIZE;
        self.nameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:self.nameL];
        
        self.markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImageView.frame)-16, 0, 16, 16)];
        self.markImageView.image = UIImageNamed(@"ly_suo");
        [self.contentView addSubview:self.markImageView];
        self.markImageView.hidden = YES;
        
        self.fgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
        self.fgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self.titleImageView addSubview:self.fgView];
        self.fgView.hidden = YES;
        
        SPActivityIndicatorView *activityIndicatorView = [[SPActivityIndicatorView alloc] initWithType:SPActivityIndicatorAnimationTypeLineScale tintColor:[UIColor colorWithHexString:@"#FFFFFF"]];
        activityIndicatorView.frame = CGRectMake(20,17,44,30);
        activityIndicatorView.left = YES;
        [self.fgView addSubview:activityIndicatorView];
        activityIndicatorView.userInteractionEnabled = YES;
        self.leftAct = activityIndicatorView;
        
        SPActivityIndicatorView *activityIndicatorView1 = [[SPActivityIndicatorView alloc] initWithType:SPActivityIndicatorAnimationTypeLineScale tintColor:[UIColor colorWithHexString:@"#FFFFFF"]];
        activityIndicatorView1.frame = CGRectMake(20,17,44,30);
        activityIndicatorView1.left = NO;
        [self.fgView addSubview:activityIndicatorView1];
        activityIndicatorView.userInteractionEnabled = YES;
        self.rightAct = activityIndicatorView1;
    }
    return self;
}

- (void)setTypeModel:(NoticeVoiceTypeModel *)typeModel{
    _typeModel = typeModel;
    self.nameL.text = typeModel.typeName;
    self.titleImageView.image = UIImageNamed(typeModel.typeImageName);
    NoticeUserInfoModel *userM = [NoticeSaveModel getUserInfo];
    if ((typeModel.needLeavel > userM.level.intValue) && typeModel.needLeavel > 0) {
        self.markImageView.hidden = NO;
    }else{
        self.markImageView.hidden = YES;
    }
    
    if (typeModel.isChoice) {
        self.fgView.hidden = NO;
        self.playView.hidden = NO;
        if (typeModel.isPalying) {
            [self.leftAct startAnimating];
            [self.rightAct startAnimating];
        }else{
            [self.leftAct stopAnimating];
            [self.rightAct stopAnimating];
        }
    }else{
        self.fgView.hidden = YES;
        self.playView.hidden = YES;
        [self.leftAct stopAnimating];
        [self.rightAct stopAnimating];
    }
}

@end
