//
//  NoticeAtPersonCell.m
//  NoticeXi
//
//  Created by li lei on 2023/6/6.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeAtPersonCell.h"
#import "UIView+CLSetRect.h"
@implementation NoticeAtPersonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //头像
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,5, 30, 30)];
        [_iconImageView setAllCorner:15];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.image = [UIImage imageNamed:@"Image_jynohe"];

        //昵称
        _nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 0,DR_SCREEN_WIDTH-CGRectGetMaxX(_iconImageView.frame)-10-60, 40)];
        _nickNameL.font = FIFTHTEENTEXTFONTSIZE;
        _nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [self.contentView addSubview:_nickNameL];

        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.chocieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        [self.contentView addSubview:self.chocieImageView];
        self.chocieImageView.hidden = YES;
        
        self.markL = [[UILabel alloc] init];
        self.markL.font = ELEVENTEXTFONTSIZE;
        self.markL.textAlignment = NSTextAlignmentCenter;
        self.markL.textColor = [UIColor whiteColor];
        self.markL.layer.cornerRadius = 2;
        self.markL.layer.masksToBounds = YES;
        [self.contentView addSubview:self.markL];
        
        self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame)-12, CGRectGetMaxY(_iconImageView.frame)-12,12, 12)];
        self.markImage.image = UIImageNamed(@"Image_guanfang_b");
        [self.contentView addSubview:self.markImage];
        self.markImage.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editNameNotice:) name:@"CHANGETEAMMASSNICKNAMENotification" object:nil];
    }
    return self;
}

- (void)editNameNotice:(NSNotification*)notification{
    NSDictionary *Dictionary = [notification userInfo];
    NSString *userId = Dictionary[@"userId"];
    NSString *name = Dictionary[@"nickName"];
    if([self.person.userId isEqualToString:userId]){
        self.person.name = name;
        self.nickNameL.text = name;
    }
}

- (void)setPerson:(YYPersonItem *)person{
    _person = person;
    self.nickNameL.text = person.name;
    if(self.canChoiceMore){
        self.iconImageView.frame = CGRectMake(50,5, 30, 30);
    }else{
        self.iconImageView.frame = CGRectMake(20,5, 30, 30);
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:person.avatar_url]];
    self.nickNameL.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)+10, 0,GET_STRWIDTH(person.name, 15, 40), 40);

    self.markL.hidden = person.identity.intValue==1?YES:NO;
    if(!self.markL.hidden){
        self.markL.text = person.identity.intValue==2?@"管理员":@"超级管理员";
        self.markL.frame = CGRectMake(CGRectGetMaxX(self.nickNameL.frame)+2, 12, GET_STRWIDTH(self.markL.text, 11, 16)+5, 16);
        self.markL.backgroundColor = [UIColor colorWithHexString:person.identity.intValue==2? @"#45C2EB":@"#F8D30D"];
    }
    
    self.markImage.hidden = person.userId.intValue==1?NO:YES;
    
    if(!self.listView){
        self.chocieImageView.hidden = self.canChoiceMore?NO:YES;
        self.chocieImageView.image = UIImageNamed(!person.isAt?@"Image_agreereg_nomol":@"Image_choiceadd_b");
    }else{
        self.chocieImageView.hidden = self.canChoiceMore? NO : YES;
        if(self.identity.intValue==3){
            if(person.identity.intValue == 3){
                self.chocieImageView.image = UIImageNamed(@"cannotchoicepersong");
            }else{
                self.chocieImageView.image = UIImageNamed(!person.isAt?@"Image_agreereg_nomol":@"Image_choiceadd_b");
            }
            
        }else{
            if(person.identity.intValue > 1){
                self.chocieImageView.image = UIImageNamed(@"cannotchoicepersong");
            }else{
                self.chocieImageView.hidden = YES;
                self.chocieImageView.image = UIImageNamed(!person.isAt?@"Image_agreereg_nomol":@"Image_choiceadd_b");
            }
        }
    }
    self.markImage.frame = CGRectMake(CGRectGetMaxX(_iconImageView.frame)-12, CGRectGetMaxY(_iconImageView.frame)-12,12, 12);
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
