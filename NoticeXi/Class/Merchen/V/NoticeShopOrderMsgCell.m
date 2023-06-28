//
//  NoticeShopOrderMsgCell.m
//  NoticeXi
//
//  Created by li lei on 2023/4/18.
//  Copyright © 2023 zhaoxiaoer. All rights reserved.
//

#import "NoticeShopOrderMsgCell.h"

@implementation NoticeShopOrderMsgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DR_SCREEN_WIDTH-30, 98)];
        backView.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];

        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 48,48)];
        self.iconImageView.layer.cornerRadius = 2;
        self.iconImageView.layer.masksToBounds = YES;
        [backView addSubview:self.iconImageView];

        self.nickNameL = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, GET_STRWIDTH(@"用户评价了你的服务", 15, 20)+20, 20)];
        self.nickNameL.font = XGFourthBoldFontSize;
        self.nickNameL.text = @"用户评价了你的服务";
        self.nickNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backView addSubview:self.nickNameL];
        
        self.timeL = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-GET_STRWIDTH(@"2021-03-25 10:00:52", 14, 20)-10, 11, GET_STRWIDTH(@"2021-03-25 10:00:52", 14, 20)+10, 17)];
        self.timeL.font = TWOTEXTFONTSIZE;
        self.timeL.textAlignment = NSTextAlignmentRight;
        self.timeL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backView addSubview:self.timeL];

        
        self.marksL = [[UILabel alloc] initWithFrame:CGRectMake(66, 54, backView.frame.size.width-66, 20)];
        self.marksL.font = FOURTHTEENTEXTFONTSIZE;
        self.marksL.textColor = [UIColor colorWithHexString:@"#5C5F66"];
        [backView addSubview:self.marksL];
    }
    return self;
}

- (void)setModel:(NoticeShopCommentModel *)model{
    _model = model;
    self.timeL.text = model.created_at;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_img_url]];
    self.marksL.text = model.room_id.intValue?[NSString stringWithFormat:@"%@*%@",model.goods_name,[self getMMSSFromSS:model.second]]: [NSString stringWithFormat:@"文字聊天*%@",model.goods_name];
}

-(NSString *)getMMSSFromSS:(NSString *)totalTime{
 
    NSInteger seconds = [totalTime integerValue];
 
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    if(str_hour.intValue){
        return [NSString stringWithFormat:@"%@时%@分%@秒",str_hour.intValue?str_hour:@"0",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
    }else{
        if(str_minute.intValue){
            return [NSString stringWithFormat:@"%@分%@秒",str_minute.intValue?str_minute:@"0",str_second.intValue?str_second:@"0"];
        }else{
            return [NSString stringWithFormat:@"%@秒",str_second.intValue?str_second:@"0"];
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
