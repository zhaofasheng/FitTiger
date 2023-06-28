//
//  NoticeBoKeDocumCell.m
//  NoticeXi
//
//  Created by li lei on 2022/9/24.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeBoKeDocumCell.h"
#import "NoticeSendBoKeController.h"
#import "NoticeSysMeassageTostView.h"
#import "NoticeBokeTosatView.h"
#import "NoticeOneToOne.h"
@implementation NoticeBoKeDocumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 12, DR_SCREEN_WIDTH-40,182)];
        self.backView.layer.cornerRadius = 12;
        self.backView.layer.masksToBounds = YES;
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
    
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.markL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,(self.backView.frame.size.width-30)/2,47)];
        self.markL .font = XGFourthBoldFontSize;
        self.markL .textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.markL];
        
        self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.markL.frame), 120,80)];
        [self.backView addSubview:self.backImageView];
        self.backImageView.layer.cornerRadius = 4;
        self.backImageView.layer.masksToBounds = YES;
        self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backImageView.clipsToBounds = YES;
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.backImageView.frame)+8,47,self.backView.frame.size.width-120-15-8-15,80)];
        self.titleL.font = FOURTHTEENTEXTFONTSIZE;
        self.titleL.numberOfLines = 0;
        self.titleL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:self.titleL];
        
        self.rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-66, 13, 66, 24)];
        self.rightBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        self.rightBtn.layer.cornerRadius = 12;
        self.rightBtn.layer.masksToBounds = YES;
        [self.rightBtn setTitle:[NoticeTools chinese:@"重新投稿" english:@"Repost" japan:@"再投稿"] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rightBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
        [self.rightBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:self.rightBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.backImageView.frame)+15, self.backView.frame.size.width-30, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        [self.backView addSubview:line];
        
        self.eidtButton = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-66-20, CGRectGetMaxY(line.frame)+9, 20, 20)];
        [self.eidtButton addTarget:self action:@selector(eidtClick) forControlEvents:UIControlEventTouchUpInside];
        [self.eidtButton setImage:UIImageNamed(@"editbk_Image") forState:UIControlStateNormal];
        [self.backView addSubview:self.eidtButton];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-20, CGRectGetMaxY(line.frame)+9, 20, 20)];
        [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setImage:UIImageNamed(@"delete_Image") forState:UIControlStateNormal];
        [self.backView addSubview:deleteBtn];
    }
    return self;
}

- (void)setModel:(NoticeDanMuModel *)model{
    _model = model;
    self.titleL.text = model.podcast_title;
    
    if (model.isSaveInDocum) {
        self.eidtButton.hidden = YES;
        self.markL.text = [NoticeTools chinese:@"投稿失败" english:@"Failed" japan:@"失敗した"];
        self.rightBtn.hidden = NO;
        NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        
        [self.backImageView sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",model.cover_url]]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
           
        }];
    }else{
        self.eidtButton.hidden = YES;
        [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.cover_url]];
        self.rightBtn.hidden = YES;
        if (model.podcast_type.intValue == 1) {
            self.markL.text = [NoticeTools chinese:@"审核中" english:@"Reviewing" japan:@"レビュー中"];
            self.markL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        }else{
            self.rightBtn.hidden = NO;
            self.rightBtn.backgroundColor = [UIColor whiteColor];
            [self.rightBtn setTitleColor:[[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.8] forState:UIControlStateNormal];
            [self.rightBtn setTitle:[NoticeTools chinese:@"查看原因" english:@"Check" japan:@"見る"] forState:UIControlStateNormal];
            self.markL.text = [NoticeTools chinese:@"审核未通过" english:@"Denied post" japan:@"拒否された投稿"];
            self.eidtButton.hidden = NO;
            self.markL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        }
    }
}

- (void)deleteBtnClick{
    if (!self.model.isSaveInDocum) {
        if (self.deleteNetBlock) {
            self.deleteNetBlock(self.model);
        }
        return;
    }
    
    if (self.deleteBlock) {
        self.deleteBlock(self.index);
    }
}

- (void)eidtClick{
    NoticeSendBoKeController *ctl = [[NoticeSendBoKeController alloc] init];
    ctl.isCheckReSend = YES;
    ctl.bokeModel = self.model;
    __weak typeof(self) weakSelf = self;
    ctl.refreshDataBlock = ^(BOOL refresh) {
        if (weakSelf.suredeleteBlock) {
            weakSelf.suredeleteBlock(weakSelf.index);
        }
    };
    [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
}

- (void)sendClick{
    if (self.model.isSaveInDocum) {
        [self upLoadHeader:self.backImageView.image path:nil];
    }else if (self.model.podcast_type.intValue == 2){
        NoticeSysMeassageTostView *tostV = [[NoticeSysMeassageTostView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        NoticeMessage *messM = [[NoticeMessage alloc] init];
        tostV.logoImageView.hidden = YES;
        messM.type = @"19";
        messM.title = [NoticeTools chinese:@"未通过原因" english:@"Reason" japan:@"理由"];
        messM.content = self.model.remarks;
        tostV.message = messM;
        [tostV showActiveView];
    }
}


- (void)upLoadHeader:(UIImage *)image path:(NSString *)path{
    if (!path) {

        path = [NSString stringWithFormat:@"%@_%ld",[[NoticeSaveModel getUserInfo] user_id],arc4random()%99999999999];
    }
    
    [[NoticeTools getTopViewController] showHUD];
  
    NSString *pathMd5 =[NSString stringWithFormat:@"%@_%@.jpg",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[NoticeTools getFileMD5WithPath:path]];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"80" forKey:@"resourceType"];
    [parm setObject:pathMd5 forKey:@"resourceContent"];

    [[XGUploadDateManager sharedManager] uploadImageWithImage:image parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            self.imgUrl = Message;
            if (bucketId) {
                self.bucketId = bucketId;
            }else{
                self.bucketId = @"0";
            }
            [self updateVoice];
        }else{
            
            [[NoticeTools getTopViewController] hideHUD];
            [[NoticeTools getTopViewController] showToastWithText:@"投稿失败，请检查网络"];
        }
    }];
}

- (void)updateVoice{
    [[NoticeTools getTopViewController] hideHUD];
    [[NoticeTools getTopViewController] showHUD];
    NSString *pathMd5 =[NSString stringWithFormat:@"%@%@.%@",[NoticeTools timeDataAppointFormatterWithTime:[NoticeTools getNowTimeTimestamp].integerValue appointStr:@"yyyyMMdd_HHmmss"],[DDHAttributedMode md5:[NSString stringWithFormat:@"%d%@",arc4random() % 99999,self.model.saveModel.voiceFilePath]],[self.model.saveModel.voiceFilePath pathExtension]];//音频本地路径转换为md5字符串
    NSMutableDictionary *parm1 = [[NSMutableDictionary alloc] init];
    [parm1 setObject:@"81" forKey:@"resourceType"];
    [parm1 setObject:pathMd5 forKey:@"resourceContent"];
    [[XGUploadDateManager sharedManager] uploadNoToastVoiceWithVoicePath:self.model.saveModel.voiceFilePath parm:parm1 progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message,NSString *bucketId, BOOL sussess) {
        if (sussess) {
            NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];

            [parm setObject:self.model.saveModel.titleName forKey:@"podcastTitle"];
            [parm setObject:self.model.saveModel.textContent forKey:@"podcastIntro"];
            [parm setObject:self.imgUrl forKey:@"coverUri"];
            [parm setObject:Message forKey:@"audioUri"];
            [parm setObject:self.model.saveModel.voiceTimeLen forKey:@"totalTime"];
            if (bucketId) {
                self.bucketId = bucketId;
            }else{
                self.bucketId = @"0";
            }
            [parm setObject:@"0" forKey:@"bucketId"];
          
            [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"podcast" Accept:@"application/vnd.shengxi.v5.4.4+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
                [[NoticeTools getTopViewController] hideHUD];
                if (success) {
                    if ([dict[@"data"] isEqual:[NSNull null]]) {
                        return ;
                    }
                    __weak typeof(self) weakSelf = self;
                    NoticeBokeTosatView *tostView = [[NoticeBokeTosatView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
                    tostView.refreshDataBlock = ^(BOOL refresh) {
                        if (weakSelf.suredeleteBlock) {
                            weakSelf.suredeleteBlock(weakSelf.index);
                        }
                    };
                    [tostView showChoiceView];
                }else{
                    NoticeOneToOne *msgModel = [NoticeOneToOne mj_objectWithKeyValues:dict];
                    [[NoticeTools getTopViewController] showToastWithText:msgModel.msg];
                }
            } fail:^(NSError *error) {
                [[NoticeTools getTopViewController] hideHUD];
                [[NoticeTools getTopViewController] showToastWithText:@"投稿失败，请检查网络"];
            }];
        }
        else{
            [[NoticeTools getTopViewController] hideHUD];
            [[NoticeTools getTopViewController] showToastWithText:@"投稿失败，请检查网络"];
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
