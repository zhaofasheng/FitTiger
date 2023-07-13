//
//  NoticeLocalTopicCell.m
//  NoticeXi
//
//  Created by li lei on 2018/10/31.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeLocalTopicCell.h"

@implementation NoticeLocalTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        self.contentView.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
        imgView.image = UIImageNamed(@"Image_zbtm");
        [self.contentView addSubview:imgView];
        self.markImageV = imgView;
        
        _mainL = [[UILabel alloc] initWithFrame:CGRectMake(39,0,DR_SCREEN_WIDTH-39-44,43.5)];
        _mainL .font = XGFifthBoldFontSize;
        _mainL .textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_mainL ];
        
    }
    return self;
}

- (UIButton *)actionBtn{
    if(!_actionBtn){
        _actionBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-43.5, 0, 43.5, 43.5)];
        [_actionBtn setImage:UIImageNamed(@"Image_cancellocaltm") forState:UIControlStateNormal];
        [_actionBtn addTarget:self action:@selector(deleHisClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_actionBtn];
    }
    return _actionBtn;
}

- (UIButton *)likeBtn{
    if(!_likeBtn){
        _likeBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-48-15, 10, 48, 24)];
        _likeBtn.titleLabel.font = ELEVENTEXTFONTSIZE;
        _likeBtn.layer.cornerRadius = 12;
        _likeBtn.layer.masksToBounds = YES;
        _likeBtn.layer.borderWidth = 1;
        [_likeBtn addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_likeBtn];
    }
    return _likeBtn;
}

- (void)likeClick{
    [[NoticeTools getTopViewController] showHUD];
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:self.topicM.isCollection?@"2":@"1" forKey:@"type"];
    [parm setObject:self.topicM.topic_name forKey:@"topicName"];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"topicCollection" Accept:@"application/vnd.shengxi.v5.5.3+json" isPost:YES parmaer:parm page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
     
            self.topicM.isCollection = self.topicM.isCollection?NO:YES;
            if(self.topicM.isCollection){
                [self.likeBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                [self.likeBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
                self.likeBtn.layer.borderColor = [UIColor colorWithHexString:@"#8A8F99"].CGColor;
             
            }else{
                [self.likeBtn setTitle:@"收藏话题" forState:UIControlStateNormal];
                [self.likeBtn setTitleColor:[UIColor colorWithHexString:@"#456DA0"] forState:UIControlStateNormal];
                self.likeBtn.layer.borderColor = [UIColor colorWithHexString:@"#456DA0"].CGColor;
                
            }
        }
        [[NoticeTools getTopViewController] hideHUD];
    } fail:^(NSError *error) {
        [[NoticeTools getTopViewController] hideHUD];
    }];
}

- (void)setTopicM:(NoticeTopicModel *)topicM{
    _topicM = topicM;
    if(self.type == 1){
        _mainL.text = [NSString stringWithFormat:@"#%@#",topicM.topic_name];
    }else{
        _mainL.text = topicM.topic_name;
    }
    
    _actionBtn.hidden = YES;
    _likeBtn.hidden = YES;
    if(self.type == 1){
        self.actionBtn.hidden = NO;
        self.markImageV.image = UIImageNamed(@"Image_zbtm");
    }else if (self.type == 2){
        self.likeBtn.hidden = NO;
        if(_topicM.isCollection){
            [self.likeBtn setTitle:@"已收藏" forState:UIControlStateNormal];
            [self.likeBtn setTitleColor:[UIColor colorWithHexString:@"#8A8F99"] forState:UIControlStateNormal];
            self.likeBtn.layer.borderColor = [UIColor colorWithHexString:@"#8A8F99"].CGColor;
         
        }else{
            [self.likeBtn setTitle:@"收藏" forState:UIControlStateNormal];
            [self.likeBtn setTitleColor:[UIColor colorWithHexString:@"#456DA0"] forState:UIControlStateNormal];
            self.likeBtn.layer.borderColor = [UIColor colorWithHexString:@"#456DA0"].CGColor;
            
        }
        self.markImageV.image = UIImageNamed(@"Image_liketopicimg");
    }else if (self.type == 3){
        self.markImageV.image = UIImageNamed(@"Image_hottopicimg");
    }
}

- (void)deleHisClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelHistoryTipicIn:)]) {
        [self.delegate cancelHistoryTipicIn:self.index];
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
