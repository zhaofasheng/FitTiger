//
//  NoticeSysCell.m
//  NoticeXi
//
//  Created by li lei on 2018/11/6.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSysCell.h"
#import "NoticeWebViewController.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeWebViewController.h"
#import "DDHAttributedMode.h"
#import "NoticeTopiceVoicesListViewController.h"
#import "AFHTTPSessionManager.h"
@implementation NoticeSysCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
   
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
                
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 44*2+20+45)];
        self.backView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        self.backView.layer.cornerRadius = 10;
        self.backView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.backView];

        self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 20, 20)];
        self.titleImageView.image = UIImageNamed(@"img_huodong");
        [self.backView addSubview:self.titleImageView];
        
        self.titleL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImageView.frame)+4, 0, 200, 44)];
        self.titleL.font = THRETEENTEXTFONTSIZE;
        self.titleL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.titleL.text = [NoticeTools getLocalStrWith:@"system.sx"];
        [self.backView addSubview:self.titleL];
        
        //时间
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(self.backView.frame.size.width-15-120,0,120, 44)];
        _timeL.font = TWOTEXTFONTSIZE;
        _timeL.textAlignment = NSTextAlignmentRight;
        _timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [self.backView addSubview:_timeL];
        
        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(15,44,DR_SCREEN_WIDTH-30-40, 45)];
        _nickNameL.font = XGEightBoldFontSize;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:_nickNameL];

        _infoL = [[UILabel alloc] init];
        _infoL.font = TWOTEXTFONTSIZE;
        _infoL.numberOfLines = 0;
        _infoL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.backView addSubview:_infoL];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, self.backView.frame.size.height-44,self.backView.frame.size.width-30, 1)];
        _line = line;
        line.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:1];
        [self.backView addSubview:line];
        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backView.frame.size.height-43, self.backView.frame.size.width, 43)];
        self.buttonView.backgroundColor = [[UIColor colorWithHexString:@"#FFFFFF"] colorWithAlphaComponent:1];
        [self.backView addSubview:self.buttonView];
    
        self.buttonL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.buttonView.frame.size.width-30-20, 43)];
        self.buttonL.text = [NoticeTools getLocalStrWith:@"system.detail"];
        self.buttonL.font = TWOTEXTFONTSIZE;
        self.buttonL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.buttonView addSubview:self.buttonL];
        self.buttonL.userInteractionEnabled = NO;
        UITapGestureRecognizer *deleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteMsg)];
        [self.buttonL addGestureRecognizer:deleTap];
        
        UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-15-21, 11, 21, 21)];
        nextImageView.image = UIImageNamed(@"sys_nextimg");
        [self.buttonView addSubview:nextImageView];
        
        self.editL = [[UILabel alloc] initWithFrame:CGRectMake(self.buttonView.frame.size.width-50-20, 0, 50, 43)];
        self.editL.backgroundColor = self.buttonView.backgroundColor;
        self.editL.font = SIXTEENTEXTFONTSIZE;
        self.editL.text = @"编辑";
        self.editL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [self.buttonView addSubview:self.editL];
        self.editL.hidden = YES;
        self.editL.userInteractionEnabled = YES;
        UITapGestureRecognizer *editT = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTap)];
        [self.editL addGestureRecognizer:editT];
    
    }
    return self;

}

- (void)deleteMsg{
    if (self.deleteBlock) {
        self.deleteBlock(self.message);
    }
}

- (void)editTap{
    if (self.editBlock) {
        self.editBlock(self.message);
    }
}

- (void)setMessage:(NoticeMessage *)message{
    _message = message;
    
    _titleL.text = (message.category_name.length && message.category_name)?message.category_name:[NoticeTools getLocalStrWith:@"system.mark"];
    _nickNameL.text = message.title;
    self.buttonL.text = [NoticeTools getLocalStrWith:@"system.detail"];
    //1 图书，2播客,3话题，4活动，5声昔君说，6反馈，7版本更新
    if (message.category_id.intValue == 1) {
        self.titleImageView.image = UIImageNamed(@"Image_syststuijian");
    }else if (message.category_id.intValue == 2){
        self.titleImageView.image = UIImageNamed(@"Image_sysboke");
    }else if (message.category_id.intValue == 3){
        self.titleImageView.image = UIImageNamed(@"Image_syshuati");
        _nickNameL.text = [NSString stringWithFormat:@"#%@#",message.supply];
        self.buttonL.text = [NoticeTools getLocalStrWith:@"system.joinTopic"];
    }else if (message.category_id.intValue == 4){
        self.titleImageView.image = UIImageNamed(@"Image_syshuodong");
    }else if (message.category_id.intValue == 5){
        self.titleImageView.image = UIImageNamed(@"Image_syssxjs");
    }else if (message.category_id.intValue == 6){
        self.titleImageView.image = UIImageNamed(@"Image_sysyhfk");
    }else if (message.category_id.intValue == 7){
        self.titleImageView.image = UIImageNamed(@"Image_sysbbgx");
    }else if (message.category_id.intValue == 8){
        self.titleImageView.image = UIImageNamed(@"Image_sysbbzb");
    }
    else{
        self.titleImageView.image = UIImageNamed(@"Image_syssxjs");
    }
    
    _infoL.attributedText = message.allTextAttStr;
    
    self.backView.frame = CGRectMake(20, 0, DR_SCREEN_WIDTH-40, 44*2+20+45+message.contentHeight);
    
    _infoL.frame = CGRectMake(15, CGRectGetMaxY(_nickNameL.frame), DR_SCREEN_WIDTH-30-40, message.contentHeight);
    
    _line.frame = CGRectMake(15, self.backView.frame.size.height-44,self.backView.frame.size.width-30, 1);
    
    self.buttonView.frame = CGRectMake(0, self.backView.frame.size.height-43, self.backView.frame.size.width, 43);
    _infoL.numberOfLines = 0;
    _timeL.text = message.created_at;
    
    if (self.isManager) {
        self.buttonL.userInteractionEnabled = YES;
        self.buttonL.font = SIXTEENTEXTFONTSIZE;
        self.buttonL.textColor = [UIColor redColor];
        self.buttonL.text = [NoticeTools getLocalStrWith:@"groupManager.del"];
        self.editL.hidden = NO;
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
