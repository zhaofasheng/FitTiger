//
//  NoticeHelpCommentCell.m
//  NoticeXi
//
//  Created by li lei on 2022/8/6.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeHelpCommentCell.h"
#import "NoticeXi-Swift.h"
#import "NoticeUserInfoCenterController.h"
@implementation NoticeHelpCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.userInteractionEnabled = YES;
        
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 24, 24)];
        _iconImageView.layer.cornerRadius = 12;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap)];
        [_iconImageView addGestureRecognizer:iconTap];
        
        self.meL = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 24, 14)];
        self.meL.textAlignment = NSTextAlignmentCenter;
        self.meL.font = [UIFont systemFontOfSize:10];
        self.meL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.meL.backgroundColor = [UIColor colorWithHexString:@"#E1E4F0"];
        self.meL.layer.cornerRadius = 2;
        self.meL.layer.masksToBounds = YES;
        self.meL.hidden = YES;
        [self.contentView addSubview:self.meL];

        self.contentL = [[UILabel alloc] initWithFrame:CGRectMake(54, 15, DR_SCREEN_WIDTH-104, 0)];
        self.contentL.font = FOURTHTEENTEXTFONTSIZE;
        self.contentL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentL.numberOfLines = 0;
        [self.contentView addSubview:self.contentL];
        
        _sendImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 14, 100, 150)];
        _sendImageView.contentMode = UIViewContentModeScaleAspectFill;
        _sendImageView.clipsToBounds = YES;
        _sendImageView.userInteractionEnabled = YES;
        _sendImageView.layer.cornerRadius = 5;
        _sendImageView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigTag)];
        [_sendImageView addGestureRecognizer:tapImg];
        [self.contentView addSubview:_sendImageView];
        _sendImageView.hidden = YES;
        
        //点赞
        self.numImageView = [[UIImageView alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-40,15, 20, 20)];
        [self.contentView addSubview:self.numImageView];
        self.numImageView.image = UIImageNamed(@"Image_agreeqiuz");
        self.numImageView.userInteractionEnabled = YES;

        self.redNumL = [[UILabel alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-60, 37, 60, 17)];
        self.redNumL.font = FOURTHTEENTEXTFONTSIZE;
        self.redNumL.textAlignment = NSTextAlignmentCenter;
        self.redNumL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:self.redNumL];
        self.redNumL.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
        [self.numImageView addGestureRecognizer:tap1];
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTap)];
        [self.redNumL addGestureRecognizer:tap2];

        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(54,0, 230, 40)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:_timeL];
        
        self.replyButton = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-50-20, self.timeL.frame.origin.y+10, 20, 20)];
        [self.replyButton setBackgroundImage:UIImageNamed(@"Image_helpComReply") forState:UIControlStateNormal];
        [self.replyButton addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
        self.replyButton.hidden = YES;
        [self.contentView addSubview:self.replyButton];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(54, CGRectGetMaxY(self.timeL.frame)-1, DR_SCREEN_WIDTH-104, 1)];
        self.line.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self.contentView addSubview:self.line];
        
        UILongPressGestureRecognizer *longDleTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longDeleteVoice:)];
        longDleTap.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longDleTap];
        
   
    }
    return self;
}

- (void)setModel:(NoticeHelpCommentModel *)model{
    _model = model;
    
    self.replyButton.hidden = YES;
    self.meL.hidden = YES;
    if ([NoticeTools isManager]) {//管理员视角
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.fromUserM.avatar_url]];
    }else if ([model.fromUserM.userId isEqualToString:model.tieUserId]){//如果是发帖人的评论
        self.iconImageView.image = UIImageNamed(@"Image_nimingpeiy");
        self.meL.hidden = NO;
        self.meL.text = [model.tieUserId isEqualToString:[NoticeTools getuserId]]?@"我":@"作者";
    }else{
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.fromUserM.avatar_url]];
    }
    
    if (model.content_type.intValue > 1) {
        self.contentL.hidden = YES;
        self.sendImageView.hidden = NO;
        self.sendImageView.frame = CGRectMake(54, 15, 100, 100);
        __weak typeof(self) weakSelf = self;
        [_sendImageView setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:model.content]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
            [weakSelf setImageViewFrame:image];
        }];
    }else{
        self.contentL.hidden = NO;
        self.sendImageView.hidden = YES;
        self.contentL.frame = CGRectMake(54, 15, DR_SCREEN_WIDTH-104, model.textHeight);
        self.contentL.attributedText = model.textAttStr;
    }
    
    self.timeL.frame = CGRectMake(54, CGRectGetMaxY(model.content_type.intValue > 1?self.sendImageView.frame : self.contentL.frame), 230, 40);
    self.timeL.text = model.created_at;
    
    if (model.like_num.intValue) {
        self.redNumL.text = model.like_num;
    }else{
        self.redNumL.text = @"0";
    }
    
    if ([[NoticeTools getuserId] isEqualToString:model.tieUserId] && !model.replyArr.count){//发帖人是自己并且还没有回复
        self.replyButton.hidden = NO;
        self.replyButton.frame = CGRectMake(DR_SCREEN_WIDTH-50-20, self.timeL.frame.origin.y+10, 20, 20);
    }
 
    _replyView.hidden = YES;
    _replyMeL.hidden = YES;
    if (model.replyArr.count) {
        if (model.isJubaoCom && model.invitation_comment_parent_id.intValue) {
            self.replyView.backgroundColor = [UIColor redColor];
        }
        NoticeHelpCommentModel *subM = model.replyArr[0];
        self.replyView.hidden = NO;
        self.replyMeL.hidden = YES;
        self.replyView.frame = CGRectMake(0, CGRectGetMaxY(self.timeL.frame)+10, DR_SCREEN_WIDTH, 40+ (subM.content_type.intValue>1?100: subM.subTextHeight));
        if ([NoticeTools isManager]) {//管理员视角
            [self.replyIconView sd_setImageWithURL:[NSURL URLWithString:model.fromUserM.avatar_url]];
        }else if ([subM.from_user_id isEqualToString:model.tieUserId]){//如果是发帖人的评论
            self.replyIconView.image = UIImageNamed(@"Image_nimingpeiy");
            self.replyMeL.hidden = NO;
            self.replyMeL.text = [model.tieUserId isEqualToString:[NoticeTools getuserId]]?@"我":@"作者";
        }else{
            [self.replyIconView sd_setImageWithURL:[NSURL URLWithString:subM.fromUserM.avatar_url]];
        }
        
        if (subM.content_type.intValue > 1) {
            self.replySendImageView.hidden = NO;
            self.replyL.hidden = YES;
            self.replySendImageView.frame = CGRectMake(34+54, 0, 100, 100);
            __weak typeof(self) weakSelf = self;
            [_replySendImageView setImageWithURL:[NSURL URLWithString:[NoticeTools hasChinese:subM.content]] placeholder:GETUIImageNamed(@"img_empty") options:YYWebImageOptionShowNetworkActivity progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } transform:nil completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                [weakSelf setImageViewFrame1:image];
            }];
        }else{
            self.replySendImageView.hidden = YES;
            self.replyL.hidden = NO;
            self.replyL.frame = CGRectMake(34+54, 0, DR_SCREEN_WIDTH-88-47, subM.subTextHeight);
            self.replyL.attributedText = subM.textAttStr;
        }
      
        self.replyTimeL.text = subM.created_at;
        self.replyTimeL.frame = CGRectMake(34+54,self.replyView.frame.size.height-40, 200, 40);
    }else{
        self.replySendImageView.hidden = YES;
    }
    
    self.numImageView.image = UIImageNamed(model.is_like.boolValue?@"Image_agreeqiuzed": @"Image_agreeqiuz");
    self.line.frame = CGRectMake(54, model.replyArr.count?CGRectGetMaxY(self.replyView.frame):CGRectGetMaxY(self.timeL.frame), DR_SCREEN_WIDTH-104, 1);
}

- (void)setImageViewFrame:(UIImage *)image{
    if (!image) {
        self.sendImageView.frame = CGRectMake(54, 15,100,100);
        return;
    }
    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(image.CGImage);
    
    CGFloat widthOverHeight = imageWidth/imageHeight;
    
    if (widthOverHeight > 2.5){//宽度超过高度俩倍
        self.sendImageView.frame = CGRectMake(54, 15,250,100);
    }else if (widthOverHeight >= 0.3 && widthOverHeight <= 2.5) {//宽度大于高度，但是没超过俩倍
        self.sendImageView.frame = CGRectMake(54, 15,widthOverHeight*100,100);
    }
    else if (widthOverHeight < 0.3){
        self.sendImageView.frame = CGRectMake(54, 15,30,100);
    }else{
        self.sendImageView.frame = CGRectMake(54, 15,widthOverHeight*100,100);
    }

}

- (void)setImageViewFrame1:(UIImage *)image{
    if (!image) {
        self.replySendImageView.frame = CGRectMake(34+54, 0,100,100);
        return;
    }
    CGFloat imageWidth = CGImageGetWidth(image.CGImage);
    CGFloat imageHeight = CGImageGetHeight(image.CGImage);
    
    CGFloat widthOverHeight = imageWidth/imageHeight;
    
    if (widthOverHeight > 2.5){//宽度超过高度俩倍
        self.replySendImageView.frame = CGRectMake(34+54, 0,250,100);
    }else if (widthOverHeight >= 0.3 && widthOverHeight <= 2.5) {//宽度大于高度，但是没超过俩倍
        self.replySendImageView.frame = CGRectMake(34+54, 0,widthOverHeight*100,100);
    }else if (widthOverHeight < 0.3) {//宽度小于高度 且大于高度一半
        self.replySendImageView.frame = CGRectMake(34+54, 0,30,100);
    }
    else{
        self.replySendImageView.frame = CGRectMake(34+54, 0,widthOverHeight*100,100);
    }
}

- (UIView *)replyView{
    if (!_replyView) {
        _replyView = [[UIView alloc] initWithFrame:CGRectMake(54, 0, DR_SCREEN_WIDTH-54-47, 0)];
        _replyView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        _replyView.layer.cornerRadius = 10;
        _replyView.layer.masksToBounds = YES;
        _replyView.hidden = YES;
        [self.contentView addSubview:_replyView];

        //头像
        _replyIconView = [[UIImageView alloc] initWithFrame:CGRectMake(54, 0, 24, 24)];
        _replyIconView.layer.cornerRadius = 12;
        _replyIconView.layer.masksToBounds = YES;
        [self.replyView addSubview:_replyIconView];
        _replyIconView.userInteractionEnabled = YES;
        UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoTap1)];
        [_replyIconView addGestureRecognizer:iconTap];

        self.replyMeL = [[UILabel alloc] initWithFrame:CGRectMake(54, 16, 24, 14)];
        self.replyMeL.textAlignment = NSTextAlignmentCenter;
        self.replyMeL.font = [UIFont systemFontOfSize:10];
        self.replyMeL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.replyMeL.backgroundColor = [UIColor colorWithHexString:@"#E1E4F0"];
        self.replyMeL.layer.cornerRadius = 2;
        self.replyMeL.layer.masksToBounds = YES;
        self.replyMeL.hidden = YES;
        [_replyView addSubview:self.replyMeL];
        
        self.replyL = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, DR_SCREEN_WIDTH-88-47, 0)];
        self.replyL.font = FOURTHTEENTEXTFONTSIZE;
        self.replyL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.replyL.numberOfLines = 0;
        [self.replyView addSubview:self.replyL];
        
        _replySendImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+12, 14, 100, 0)];
        _replySendImageView .contentMode = UIViewContentModeScaleAspectFill;
        _replySendImageView .clipsToBounds = YES;
        _replySendImageView .userInteractionEnabled = YES;
        _replySendImageView .layer.cornerRadius = 5;
        _replySendImageView .layer.masksToBounds = YES;
        UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigTag1)];
        [_replySendImageView  addGestureRecognizer:tapImg];
        [self.replyView addSubview:_replySendImageView ];
        _replySendImageView .hidden = YES;
        
        //时间
        _replyTimeL = [[UILabel alloc] initWithFrame:CGRectMake(34,self.replyView.frame.size.height-40, 200, 40)];
        _replyTimeL.font = TWOTEXTFONTSIZE;
        _replyTimeL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.5];
        [self.replyView addSubview:_replyTimeL];
        
        _replyView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longDleTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longDeleteVoice1:)];
        longDleTap.minimumPressDuration = 0.5;
        [_replyView addGestureRecognizer:longDleTap];
    }
    return _replyView;
}

- (void)bigTag{
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.sendImageView;
    item.largeImageURL     = [NSURL URLWithString:self.model.content];

    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow;
    [photoView presentFromImageView:self.sendImageView toContainer:toView animated:YES completion:nil];
}

- (void)bigTag1{
    NoticeHelpCommentModel *subM = self.model.replyArr[0];
    YYPhotoGroupItem *item = [YYPhotoGroupItem new];
    item.thumbView         = self.replySendImageView;
    item.largeImageURL     = [NSURL URLWithString:subM.content];

    NSMutableArray *arr = [NSMutableArray new];
    [arr addObject:item];
    YYPhotoGroupView *photoView = [[YYPhotoGroupView alloc] initWithGroupItems:arr];
    UIView *toView         = [UIApplication sharedApplication].keyWindow;
    [photoView presentFromImageView:self.replySendImageView toContainer:toView animated:YES completion:nil];
}

- (void)replyClick{
    if (self.model.replyArr.count) {
        return;
    }
    if (self.model.be_reply_status.boolValue) {
        return;
    }
    if (self.replyBlock) {
        self.replyBlock(self.model);
    }
}

- (void)likeTap{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:[NSString stringWithFormat:@"invitation/commentLike/%@/%@",self.model.commentId,self.model.is_like.boolValue?@"2":@"1"] Accept:@"application/vnd.shengxi.v5.4.1+json" isPost:YES parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            self.model.is_like = self.model.is_like.boolValue?@"0":@"1";
            if (self.model.is_like.boolValue) {
                self.model.like_num = [NSString stringWithFormat:@"%d",self.model.like_num.intValue+1];
            }else{
                self.model.like_num = [NSString stringWithFormat:@"%d",self.model.like_num.intValue-1];
            }
            if (self.model.like_num.intValue < 0) {
                self.model.like_num = @"0";
            }
            if (self.model.like_num.intValue) {
                self.redNumL.text = self.model.like_num;
            }else{
                self.redNumL.text = @"0";
            }
            
            self.numImageView.image = UIImageNamed(self.model.is_like.boolValue?@"Image_agreeqiuzed": @"Image_agreeqiuz");
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
    
}

- (void)userInfoTap{
    if ([NoticeTools isManager]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        if (![self.model.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
            ctl.isOther = YES;
            ctl.userId = self.model.from_user_id;
        }
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)userInfoTap1{
    if ([NoticeTools isManager]) {
        NoticeUserInfoCenterController *ctl = [[NoticeUserInfoCenterController alloc] init];
        NoticeHelpCommentModel *subM = _model.replyArr[0];
        if (![subM.from_user_id isEqualToString:[[NoticeSaveModel getUserInfo] user_id]]) {
            ctl.isOther = YES;
            ctl.userId = subM.from_user_id;
        }
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (NoticeManager *)magager{
    if (!_magager) {
        _magager = [[NoticeManager alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        _magager.delegate = self;
    }
    return _magager;
}

- (void)sureManagerClick:(NSString *)code{
    if ([self.magager.type isEqualToString:@"管理员删除回复留言"]) {
        [[NoticeTools getTopViewController] showHUD];
        NSMutableDictionary *parm = [NSMutableDictionary new];
        [parm setObject:code forKey:@"confirmPasswd"];
        NoticeHelpCommentModel *subM = self.model.replyArr[0];
        [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/invitation/comment/%@",subM.commentId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
            [[NoticeTools getTopViewController] hideHUD];
            if (success) {
                if (self.deletesubSuccess) {
                    self.deletesubSuccess(self.model.commentId);
                }
                [YZC_AlertView showViewWithTitleMessage:@"已删除"];
                [self.magager removeFromSuperview];
            }
        } fail:^(NSError * _Nullable error) {
            [[NoticeTools getTopViewController] hideHUD];
        }];
        return;
    }
    [[NoticeTools getTopViewController] showHUD];
    NSMutableDictionary *parm = [NSMutableDictionary new];
    [parm setObject:code forKey:@"confirmPasswd"];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"admin/invitation/comment/%@",self.model.commentId] Accept:nil parmaer:parm page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            if (self.deleteSuccess) {
                self.deleteSuccess(self.model.commentId);
            }
            [YZC_AlertView showViewWithTitleMessage:@"已删除"];
            [self.magager removeFromSuperview];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)longDeleteVoice:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;

    //py.dele  删除  chat.jubao 举报
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell

            NSArray *arr = @[[NoticeTools getLocalStrWith:@"chat.jubao"]];
            if ([NoticeTools isManager]) {
                arr = @[@"管理员删除"];
            }
            else if ([self.model.from_user_id isEqualToString:[NoticeTools getuserId]]) {//评论是自己的，删除操作
                arr = @[[NoticeTools getLocalStrWith:@"py.dele"]];
            }else if([self.model.tieUserId isEqualToString:[NoticeTools getuserId]]){//帖子是自己的，评论不是自己的
                arr = @[[NoticeTools getLocalStrWith:@"chat.jubao"],[NoticeTools getLocalStrWith:@"py.dele"]];
            }
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:arr];
            sheet.delegate = self;
            [sheet show];
            break;
        }
        default:
            break;
    }
}

- (void)longDeleteVoice1:(id)sender{
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;

    //py.dele  删除  chat.jubao 举报
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            if (!self.model.replyArr.count) {
                return;
            }
            NSArray *arr = @[[NoticeTools getLocalStrWith:@"chat.jubao"]];
            NoticeHelpCommentModel *subM = self.model.replyArr[0];
            if ([NoticeTools isManager]) {
                arr = @[@"管理员删除"];
            }else{
                if ([subM.from_user_id isEqualToString:[NoticeTools getuserId]]) {//自己回复
                    arr = @[[NoticeTools getLocalStrWith:@"py.dele"]];
                }else{
                    arr = @[[NoticeTools getLocalStrWith:@"chat.jubao"]];
                }
            }
 
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
            } otherButtonTitleArray:arr];
            sheet.delegate = self;
            self.subsheet = sheet;
            [sheet show];
            break;
        }
        default:
            break;
    }
}

- (void)deleteTie{
    [[NoticeTools getTopViewController] showHUD];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"invitation/comment/%@",self.model.commentId] Accept:@"application/vnd.shengxi.v5.4.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            if (self.deleteSuccess) {
                self.deleteSuccess(self.model.commentId);
            }
            [YZC_AlertView showViewWithTitleMessage:@"已删除"];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)deletesubTie{
    [[NoticeTools getTopViewController] showHUD];
    NoticeHelpCommentModel *subM = self.model.replyArr[0];
    [[DRNetWorking shareInstance] requestWithDeletePath:[NSString stringWithFormat:@"invitation/comment/%@",subM.commentId] Accept:@"application/vnd.shengxi.v5.4.1+json" parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        [[NoticeTools getTopViewController] hideHUD];
        if (success) {
            if (self.deletesubSuccess) {
                self.deletesubSuccess(self.model.commentId);
            }
            [YZC_AlertView showViewWithTitleMessage:@"已删除"];
        }
    } fail:^(NSError * _Nullable error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}


- (void)actionSheet:(LCActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet == self.subsheet) {
        if (buttonIndex == 1) {
            NoticeHelpCommentModel *subM = self.model.replyArr[0];
            if ([NoticeTools isManager]) {
                if ([NoticeTools isManager]) {
                    self.magager.type = @"管理员删除回复留言";
                    [self.magager show];
                  
                }
            }else{
                if ([subM.from_user_id isEqualToString:[NoticeTools getuserId]]) {//自己回复
                    __weak typeof(self) weakSelf = self;
                    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:[NoticeTools getLocalStrWith:@"py.issueredel"] cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                        if (buttonIndex == 1) {
                            [weakSelf deletesubTie];
                        }
                    } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"py.dele"]]];
                    [sheet show];
                }else{
                    NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
                    juBaoView.reouceId = subM.commentId;
                    juBaoView.reouceType = @"142";
                    [juBaoView showView];
                }
            }
        }
        return;
    }
    if (buttonIndex == 1) {
        if ([NoticeTools isManager]) {
            self.magager.type = @"管理员删除留言";
            [self.magager show];
          
        }
        else if ([self.model.from_user_id isEqualToString:[NoticeTools getuserId]]) {//帖子是自己的
            __weak typeof(self) weakSelf = self;
            LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:[NoticeTools getLocalStrWith:@"nes.delesu"] cancelButtonTitle:[NoticeTools getLocalStrWith:@"main.cancel"] clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    [weakSelf deleteTie];
                }
            } otherButtonTitleArray:@[[NoticeTools getLocalStrWith:@"py.dele"]]];
            [sheet show];

        }else{
            NoticeJuBaoSwift *juBaoView = [[NoticeJuBaoSwift alloc] init];
            juBaoView.reouceId = self.model.commentId;
            juBaoView.reouceType = @"142";
            [juBaoView showView];
        }
    }else if (buttonIndex == 2){
        if([self.model.tieUserId isEqualToString:[NoticeTools getuserId]]){//帖子是自己的，评论不是自己的
            [self deleteTie];
        }
    }
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
