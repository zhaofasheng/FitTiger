//
//  NoticeSaveVoiceCell.m
//  NoticeXi
//
//  Created by li lei on 2022/8/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeSaveVoiceCell.h"

@implementation NoticeSaveVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 145)];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(15,0,self.backView.frame.size.width-65-30, 50)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:0.6];
        [self.backView addSubview:_timeL];
        self.backView.backgroundColor = [UIColor whiteColor];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(15,50,self.backView.frame.size.width-65-30, 40)];
        _titleL.font = XGFifthBoldFontSize;
        _titleL.textColor = [[UIColor colorWithHexString:@"#25262E"] colorWithAlphaComponent:1];
        [self.backView addSubview:_titleL];
        self.backView.backgroundColor = [UIColor whiteColor];
        
        UIButton *sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-65, 15, 65, 24)];
        sendBtn.backgroundColor = [UIColor colorWithHexString:@"#0099E6"];
        sendBtn.layer.cornerRadius = 12;
        sendBtn.layer.masksToBounds = YES;
        [sendBtn setTitle:[NoticeTools getLocalStrWith:@"cao.resend"] forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sendBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
        [sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:sendBtn];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-20, self.backView.frame.size.height-15-20, 20, 20)];
        [self.deleteButton setBackgroundImage:UIImageNamed(@"delesavecoiceimg") forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_deleteButton];
        
        _playerView = [[NoiticePlayerView alloc] initWithFrame:CGRectMake(15,50, 150, 40)];
        self.playerView.isThird = YES;
        self.playerView.hidden = YES;
        [self.playerView.playButton setImage:UIImageNamed(@"btn_play") forState:UIControlStateNormal];
        [self.backView addSubview:_playerView];
        
        self.playerView.leftView.hidden = YES;
        self.playerView.rightView.hidden = YES;
        
        _playView = [[UIView alloc] initWithFrame:CGRectMake(-15, -3,_playerView.frame.size.height+15+5, _playerView.frame.size.height+6)];
        _playView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playNoReplay)];
        [_playView addGestureRecognizer:tap];
        [self.playerView addSubview:_playView];
        
        self.dragView = [[UIView alloc] initWithFrame:CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height)];
        self.dragView.userInteractionEnabled = YES;
        self.dragView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.0];
        [self.playerView addSubview:self.dragView];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        longPress.minimumPressDuration = 0.0;
        [self.dragView addGestureRecognizer:longPress];
        
        self.contentTextL = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-70, 13)];
        self.contentTextL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.contentTextL.font = FIFTHTEENTEXTFONTSIZE;
        self.contentTextL.numberOfLines = 0;
        [self.backView addSubview:self.contentTextL];
        self.contentTextL.hidden = YES;
        
        self.imageViewS = [[NoticeVoiceImgList alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH, 0)];
        [self.backView addSubview:self.imageViewS];
    }
    return self;
}

- (void)setSaveModel:(NoticeVoiceSaveModel *)saveModel{
    _saveModel = saveModel;
    
    if ([NoticeTools getLocalType] == 1) {
        self.timeL.text = [NSString stringWithFormat:@"%@%@",@"Saved at",saveModel.sendTime];
    }else if ([NoticeTools getLocalType] == 2){
        self.timeL.text = [NSString stringWithFormat:@"%@%@",@"保存時間",saveModel.sendTime];
    }else{
        self.timeL.text = [NSString stringWithFormat:@"%@%@",@"保存于",saveModel.sendTime];
    }
    
    self.titleL.hidden = saveModel.contentType.intValue==5?NO:YES;
    self.titleL.text = saveModel.titleName;
    
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSInteger imgNum = 0;
    CGFloat imagHeight = 0;
    if (saveModel.img1Path && saveModel.img2Path && saveModel.img3Path) {
        imagHeight = (DR_SCREEN_WIDTH-60-18)/3;
        imgNum = 3;
        [self.imageViewS.imgV1 sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",saveModel.img1Path]]]];
        [self.imageViewS.imgV2 sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",saveModel.img2Path]]]];
        [self.imageViewS.imgV3 sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",saveModel.img3Path]]]];
    }else if (saveModel.img1Path && saveModel.img2Path && !saveModel.img3Path){
        imagHeight = (DR_SCREEN_WIDTH-68)/2;
        imgNum = 2;
        [self.imageViewS.imgV1 sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",saveModel.img1Path]]]];
        [self.imageViewS.imgV2 sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",saveModel.img2Path]]]];
    }else if (saveModel.img1Path && !saveModel.img2Path && !saveModel.img3Path){
        imagHeight = 200;
        imgNum = 1;
        [self.imageViewS.imgV1 sd_setImageWithURL:[NSURL fileURLWithPath:[string stringByAppendingString:[NSString stringWithFormat:@"/%@",saveModel.img1Path]]]];
    }

    if (saveModel.contentType.intValue!=1) {
        self.playerView.hidden = YES;
        self.contentTextL.hidden = NO;
        self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, (saveModel.isMoreFiveLines?saveModel.fiveTextHeight:saveModel.textHeight)+imagHeight+100+(saveModel.contentType.intValue==5?50: 0));
        self.contentTextL.frame = CGRectMake(15,(saveModel.contentType.intValue==5?90: 50), DR_SCREEN_WIDTH-70, (saveModel.isMoreFiveLines?saveModel.fiveTextHeight:saveModel.textHeight));
        self.contentTextL.attributedText = saveModel.isMoreFiveLines?saveModel.fiveAttTextStr:saveModel.allTextAttStr;
        self.imageViewS.frame = CGRectMake(0, CGRectGetMaxY(_contentTextL.frame), DR_SCREEN_WIDTH-70, imagHeight);
    }else{
        self.contentTextL.hidden = YES;
        self.playerView.hidden = NO;
        self.playerView.timeLen = saveModel.nowTime.integerValue?saveModel.nowTime: saveModel.voiceTimeLen;
     
        self.playerView.slieView.progress = saveModel.nowPro >0 ?saveModel.nowPro:0;
        //位置
        if (saveModel.voiceTimeLen.integerValue < 5) {
            self.playerView.frame = CGRectMake(15,50, 130, 40);
        }else if (saveModel.voiceTimeLen.integerValue >= 5 && saveModel.voiceTimeLen.integerValue <= 105){
            self.playerView.frame = CGRectMake(15, 50, 130+saveModel.voiceTimeLen.integerValue, 40);
        }else if (saveModel.voiceTimeLen.integerValue >= 120){
            self.playerView.frame = CGRectMake(15,50, 130+120, 40);
        }
        else{
            self.playerView.frame = CGRectMake(15,50, 130+saveModel.voiceTimeLen.integerValue, 40);
        }
     
        self.dragView.frame =  CGRectMake(_playerView.frame.size.height, 0, _playerView.frame.size.width-_playerView.frame.size.height, _playerView.frame.size.height);
        [self.playerView refreWithFrame];
        self.imageViewS.frame = CGRectMake(0, CGRectGetMaxY(_playerView.frame)+15, DR_SCREEN_WIDTH-70, imagHeight);
        self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, imagHeight+104+50);
    }
    if (imgNum > 0) {
        self.imageViewS.hidden = NO;
        self.imageViewS.imageNum = imgNum;
    }else{
        self.imageViewS.hidden = YES;
    }
    self.deleteButton.frame = CGRectMake(self.backView.frame.size.width-15-20, self.backView.frame.size.height-15-20, 20, 20);
}

- (void)deleteButtonClick{
    if (self.deleteOrSendBlock) {
        self.deleteOrSendBlock(NO, self.index);
    }
}

- (void)sendClick{
    if (self.deleteOrSendBlock) {
        self.deleteOrSendBlock(YES, self.index);
    }
}


//点击播放
- (void)playNoReplay{
    DRLog(@"点击播放区域");
    if (self.delegate && [self.delegate respondsToSelector:@selector(startPlayAndStop:)]) {
        [self.delegate startPlayAndStop:self.index];
    }
}

- (void)longPressGestureRecognized:(id)sender{

    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在tableView中的位置
    CGPoint p = [longPress locationInView:self.playerView];
    if (!_saveModel.isPlaying) {
        if (longPressState == UIGestureRecognizerStateEnded) {
            [self playNoReplay];
        }
        return;
    }
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{  //手势开始，对被选中cell截图，隐藏原cell
            DRLog(@"开始%.f",p.x);
            if (self.delegate && [self.delegate respondsToSelector:@selector(beginDrag:)]) {
                [self.delegate beginDrag:self.tag];
            }
            [self dragWithPoint:p];
            break;
        }
        case UIGestureRecognizerStateChanged:{
         
            [self dragWithPoint:p];
            break;
        }
        default: {
     
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag: progross:)]) {
                [self.delegate endDrag:self.tag progross:p.x/self.playerView.frame.size.width];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(endDrag:)]) {
                [self.delegate endDrag:self.tag];
            }
            break;
        }
    }
}

- (void)dragWithPoint:(CGPoint)p{
    self.playerView.slieView.progress = p.x/self.playerView.frame.size.width;

    if (self.delegate && [self.delegate respondsToSelector:@selector(dragingFloat: index:)]) {
        if ((_saveModel.voiceTimeLen.floatValue/self.playerView.frame.size.width)*p.x < _saveModel.voiceTimeLen.length/5) {
            return;
        }
        [self.delegate dragingFloat:(_saveModel.voiceTimeLen.floatValue/self.playerView.frame.size.width)*p.x index:self.tag];
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
