//
//  NoticeBBSComentInputView.m
//  NoticeXi
//
//  Created by li lei on 2020/11/9.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeBBSComentInputView.h"

@implementation NoticeBBSComentInputView
{
    CGFloat kebordHeight;
    
    UIView *_bottomV;
    UIVisualEffectView *effectView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
        self.backView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
        [rootWindow addSubview:self.backView];
        self.backView.hidden = YES;
        self.backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regFirst)];
        [self.backView addGestureRecognizer:tap];
        
        if (appdel.backImg) {
            //背景图相关
            UIBlurEffect *effect1 = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *effectView1 = [[UIVisualEffectView alloc] initWithEffect:effect1];
            effectView1.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, self.frame.size.height+BOTTOM_HEIGHT);
            effectView1.alpha = 0.7;
            [self addSubview:effectView1];
            effectView = effectView1;
        }

        
        self.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        
        self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(15,8, DR_SCREEN_WIDTH-15-60, 34)];
        self.contentView.tintColor = GetColorWithName(VMainThumeColor);
        self.contentView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        self.contentView.delegate = self;
        self.contentView.font = FIFTHTEENTEXTFONTSIZE;
        self.contentView.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentView.layer.cornerRadius = 34/2;
        self.contentView.layer.masksToBounds = YES;
        self.contentView.showsVerticalScrollIndicator = NO;
        self.contentView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.contentView];
        
        _plaL = [[UILabel alloc] initWithFrame:CGRectMake(27,7, 200, 34)];
        _plaL.text = self.plaStr;
        _plaL.font = FOURTHTEENTEXTFONTSIZE;
        _plaL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        [self addSubview:_plaL];
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), 0.5, DR_SCREEN_WIDTH-CGRectGetMaxX(self.contentView.frame), 49.5)];
        sendBtn.titleLabel.font = FIFTHTEENTEXTFONTSIZE;
        [sendBtn setTitle:[NoticeTools getTextWithSim:[NoticeTools getLocalStrWith:@"read.send"] fantText:@"發送"] forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sendBtn];
        self.sendButton = sendBtn;
                
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDiddisss) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)setIsmanager:(BOOL)ismanager{
    if (ismanager) {
        self.backView.hidden = NO;
    }
}

- (void)setIsRead:(BOOL)isRead{
    _isRead = isRead;
    if (isRead) {
        effectView.hidden = YES;
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    }
}

- (void)setIspy:(BOOL)ispy{
    _ispy = ispy;
    if (ispy) {
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.textColor = [UIColor colorWithHexString:@"#25262E"];
        _plaL.textColor = [[UIColor colorWithHexString:@"#A1A7B3"] colorWithAlphaComponent:1];
        effectView.hidden = YES;
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
    }
}

- (void)setPlaStr:(NSString *)plaStr{
    _plaStr = plaStr;
    _plaL.text = self.contentView.text.length?@"": _plaStr;
}

- (void)showJustComment:(NSString *)commentId{
    self.commentId = commentId;

    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    if (commentId || self.subCommentM || self.isHelp) {
        self.replyToView = [[NoticeReplyToView alloc] initWithFrame:CGRectMake(0, self.frame.origin.y-30, DR_SCREEN_WIDTH, 30)];
  
        if (self.isHelp) {
            self.replyToView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
            self.replyToView.replyLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        }
    }
    [rootWindow addSubview:self];
    
    [rootWindow bringSubviewToFront:self.backView];
    [rootWindow bringSubviewToFront:self];
    
    if (self.isVoiceComment || self.isHelp) {
        [self.backView removeFromSuperview];
        UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
        [rootWindow addSubview:self.backView];
    }
    if (self.isHelp) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [effectView removeFromSuperview];
    }
    [rootWindow bringSubviewToFront:self];
}

- (void)regFirst{
    [self.contentView resignFirstResponder];
    if (self.ismanager) {
        [self clearView];
    }
    if (self.isHelp) {
        if (self.imgOpen) {
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
            self.imgOpen = NO;
            [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
            self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);

        }
        if (self.emotionOpen) {
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
            self.emotionOpen = NO;
            [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
            self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);

        }
    }
    if (self.isHelp) {
        [self.replyToView removeFromSuperview];
        self.commentId = nil;
    }
    if (self.isHelpCom) {
        self.hidden = YES;
    }
    self.backView.hidden = YES;
}

- (void)setIsHelp:(BOOL)isHelp{
    _isHelp = isHelp;
    self.contentView.returnKeyType = UIReturnKeySend;
    self.sendButton.hidden = YES;
    
    self.contentView.frame = CGRectMake(15,8, DR_SCREEN_WIDTH-15-96, 34);
    
    self.emtionBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame)+18, 0, 24, 50)];
    [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
    [self.emtionBtn addTarget:self action:@selector(emtionClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.emtionBtn];
    
    self.imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.emtionBtn.frame)+10, 0, 24, 50)];
    [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
    [self.imgBtn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.imgBtn];
}

- (NoticeScroEmtionView *)emotionView{
    if (!_emotionView) {
        _emotionView  = [[NoticeScroEmtionView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+15)];
        _emotionView.backgroundColor = self.backgroundColor;
        __weak typeof(self) weakSelf = self;
        _emotionView.sendBlock = ^(NSString * _Nonnull url, NSString * _Nonnull buckId, NSString * _Nonnull pictureId, BOOL isHot) {
            
            if (weakSelf.emtionBlock) {
                weakSelf.emtionBlock(url, buckId, pictureId, isHot,weakSelf.commentId);
            }
            [weakSelf emtionClick];
        };

        [[NoticeTools getTopViewController].view addSubview:_emotionView];
    }
    return _emotionView;
}

- (NoticeChocieImgListView *)imgListView{
    if (!_imgListView) {
        __weak typeof(self) weakSelf = self;
        _imgListView = [[NoticeChocieImgListView alloc] initWithFrame:CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, 250+35+15)];
        _imgListView.limitNum = 1;
        _imgListView.didSelectPhotosMBlock = ^(NSMutableArray * _Nonnull photoArr) {
            
            if (weakSelf.imgBlock) {
                weakSelf.imgBlock(photoArr,weakSelf.commentId);
            }
            [weakSelf imgClick];
        };
        [[NoticeTools getTopViewController].view addSubview:_imgListView];
    }
    return _imgListView;
}

- (void)imgClick{
    
    [self.contentView resignFirstResponder];
    
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    }

    if (self.imgOpen) {
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
        }];
        if (self.isHelpCom) {
            self.hidden = YES;
        }
        [self.replyToView removeFromSuperview];
        self.commentId = nil;
    }else{
   
        [self.imgListView refreshImage];
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.imgListView.frame.size.height-self.frame.size.height, DR_SCREEN_WIDTH,self.frame.size.height);
            self.imgListView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.imgListView.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
            self.replyToView.frame = CGRectMake(0, self.frame.origin.y-30, DR_SCREEN_WIDTH, 30);
        }];
        [self.imgBtn setImage:UIImageNamed(@"Image_openimgpri") forState:UIControlStateNormal];
    }
    self.imgOpen = !self.imgOpen;
}

- (void)emtionClick{
    
    [self.contentView resignFirstResponder];
    
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    }
    
    if (self.emotionOpen) {
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
     
        [UIView animateWithDuration:0.5 animations:^{
  
            self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
        }];
        if (self.isHelpCom) {
            self.hidden = YES;
        }
        [self.replyToView removeFromSuperview];
        self.commentId = nil;
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT-self.emotionView.frame.size.height-self.frame.size.height, DR_SCREEN_WIDTH,self.frame.size.height);
            self.emotionView.frame = CGRectMake(0,DR_SCREEN_HEIGHT-self.emotionView.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
            self.replyToView.frame = CGRectMake(0, self.frame.origin.y-30, DR_SCREEN_WIDTH, 30);
        }];
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_sb") forState:UIControlStateNormal];
    }
    self.emotionOpen = !self.emotionOpen;
}

- (void)sendClick{
    
    self.commentM.caogaoText = nil;
    
    if (!self.contentView.text.length) {
        [self.contentView resignFirstResponder];
       
        return;
    }
    NSInteger num = self.limitNum?self.limitNum:500;
    if (self.contentView.text.length > num) {
        self.contentView.text = [self.contentView.text substringToIndex:num];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendWithComment: commentId:)]) {
        [self.delegate sendWithComment:self.contentView.text commentId:self.commentId];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendWithComment: toUserId: subCommentId:)]) {
        [self.delegate sendWithComment:self.contentView.text toUserId:self.toUserId subCommentId:self.subcommentId];
    }
    self.contentView.text = @"";
    [self.contentView resignFirstResponder];
    
    if (self.isHelp) {
        [self.replyToView removeFromSuperview];
        self.commentId = nil;
    }
    if (self.isHelpCom) {
        self.hidden = YES;
    }
}


-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    if (self.imgOpen) {
        self.imgOpen = NO;
        [self.imgBtn setImage:UIImageNamed(@"Image_hsimgbtn") forState:UIControlStateNormal];
        self.imgListView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.imgListView.frame.size.height);
    }
    if (self.emotionOpen) {
        self.emotionOpen = NO;
        [self.emtionBtn setImage:UIImageNamed(@"Image_emtion_nb") forState:UIControlStateNormal];
        self.emotionView.frame = CGRectMake(0, DR_SCREEN_HEIGHT, DR_SCREEN_WIDTH, self.emotionView.frame.size.height);
    }
    
    self.backView.hidden = NO;
    if (!self.isVoiceComment) {
        self.backView.hidden = YES;
    }
    
    if (self.isHelp) {
        self.backView.hidden = NO;
        self.backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    }

        
    NSDictionary *userInfo = notification.userInfo;
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-keyboardF.size.height-self.frame.size.height, DR_SCREEN_WIDTH, self.frame.size.height);
    self.isresiger = NO;
    
    kebordHeight = keyboardF.size.height;
    self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame),self.frame.size.height-49.5,DR_SCREEN_WIDTH-CGRectGetMaxX(self.contentView.frame),49.5);
    if (self.commentId) {
    }
    _bottomV.hidden = YES;
    if (self.orignYBlock) {
        self.orignYBlock(self.frame.origin.y);
    }
    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
    if (self.isHelp && self.commentId) {
        [self.replyToView removeFromSuperview];
        [rootWindow addSubview:self.replyToView];
        self.replyToView.frame = CGRectMake(0, self.frame.origin.y-30, DR_SCREEN_WIDTH, 30);
        self.replyToView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        self.replyToView.replyLabel.textColor = [UIColor colorWithHexString:@"#8A8F99"];
     
    }
    if (self.isHelp) {

        self.backView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-BOTTOM_HEIGHT);
    }else{
        self.backView.frame = CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT-self.frame.origin.y);
    }
    
    [rootWindow bringSubviewToFront:self.replyToView];
    [rootWindow bringSubviewToFront:self];
}

- (void)keyboardDiddisss{
    _bottomV.hidden = NO;
    self.isresiger = YES;

    if ((self.commentId || self.subCommentM || self.needClear || self.isVoiceComment) && !self.isHelp) {
        [self clearView];
    }
 
    self.backView.hidden = YES;
    self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-self.frame.size.height-BOTTOM_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height);
    kebordHeight = 0;
    self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame),self.frame.size.height-49.5,DR_SCREEN_WIDTH-CGRectGetMaxX(self.contentView.frame),49.5);
    if (self.commentId) {
        self.replyToView.frame = CGRectMake(0, self.frame.origin.y-30, DR_SCREEN_WIDTH, 30);
    }
    if (self.orignYBlock) {
        self.orignYBlock(self.frame.origin.y);
    }
}

- (void)clearView{
    [self.replyToView removeFromSuperview];
    [self.backView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)setCommentM:(NoticeBBSComent *)commentM{
    _commentM = commentM;
    if (commentM.caogaoText) {
        _plaL.text = @"";
        self.contentView.text = commentM.caogaoText;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"] && self.isHelp) {
        [self sendClick];
        return NO;
    }
    else if ([text isEqualToString:@"\n"] && self.ispy) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    if (textView.text.length) {
        _plaL.text = @"";
        [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#0099E6"] forState:UIControlStateNormal];
    }else{
        if (self.isRead) {
            [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        }else{
            [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#ACB3BF"] forState:UIControlStateNormal];
        }
        if (self.ispy) {
            [self.sendButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
        }
        _plaL.text = self.plaStr;
    }
    CGRect frame = textView.frame;
    
    NSInteger num = self.limitNum?self.limitNum:500;

    if (textView.text.length > num) {
        textView.text = [textView.text substringToIndex:num];
    }
    float height;
    height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@",textView.text]];
    if (height > 70) {
        height = 70;
    }
    if (height <= 35) {
        height = 36;
    }
    frame.size.height = height;
    if (self.commentM) {
        self.commentM.caogaoText = textView.text;
    }
    
    if (self.isresiger) {
        return;
    }
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(0, DR_SCREEN_HEIGHT-(14+height)-self->kebordHeight, DR_SCREEN_WIDTH,14+height);
        self->effectView.frame = CGRectMake(0,0, DR_SCREEN_WIDTH, self.frame.size.height+BOTTOM_HEIGHT);
        if (self.commentId) {
            self.replyToView.frame = CGRectMake(0, self.frame.origin.y-30, DR_SCREEN_WIDTH, 30);
        }
        textView.frame = frame;
        self.sendButton.frame = CGRectMake(CGRectGetMaxX(self.contentView.frame),self.frame.size.height-49.5,DR_SCREEN_WIDTH-CGRectGetMaxX(self.contentView.frame),49.5);
    } completion:nil];
}

- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height+(size.size.height>36?10:0)+5;
    return textHeight;
}

@end
