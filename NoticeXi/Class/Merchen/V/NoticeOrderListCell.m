//
//  NoticeOrderListCell.m
//  NoticeXi
//
//  Created by li lei on 2022/7/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeOrderListCell.h"
#import "NoticeGoToComShopController.h"
#import "NoticeOrderComDetailController.h"
#import "NoticdShopDetailForUserController.h"
@implementation NoticeOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 12, DR_SCREEN_WIDTH-40, 152)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 10;
        backView.layer.masksToBounds = YES;
        [self.contentView addSubview:backView];
        self.backV = backView;
        
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 40, 60, 60)];
        self.iconImageView.layer.cornerRadius = 5;
        self.iconImageView.layer.masksToBounds = YES;
        [backView addSubview:self.iconImageView];
        
        self.userIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        self.userIconImageView.layer.cornerRadius = 10;
        self.userIconImageView.layer.masksToBounds = YES;
        [backView addSubview:self.userIconImageView];
        self.userIconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopTap)];
        [self.userIconImageView addGestureRecognizer:tap1];
        
        self.shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(82, 47, backView.frame.size.width-82, 22)];
        self.shopNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.shopNameL.font = SIXTEENTEXTFONTSIZE;
        [backView addSubview:self.shopNameL];
        
        self.priceL = [[UILabel alloc] initWithFrame:CGRectMake(82, 73, 134, 20)];
        self.priceL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.priceL.font = FOURTHTEENTEXTFONTSIZE;
        [backView addSubview:self.priceL];
        
        self.payL = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-120, 73, 120, 20)];
        self.payL.textColor = [UIColor colorWithHexString:@"#0099E6"];
        self.payL.font = TWOTEXTFONTSIZE;
        self.payL.textAlignment = NSTextAlignmentRight;
        [backView addSubview:self.payL];
        
        self.userNameL = [[UILabel alloc] initWithFrame:CGRectMake(38, 11, 128, 17)];
        self.userNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        self.userNameL.font = TWOTEXTFONTSIZE;
        [backView addSubview:self.userNameL];
        self.userNameL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopTap)];
        [self.userNameL addGestureRecognizer:tap2];
        
        self.statusL = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-126, 12, 126, 17)];
        self.statusL.textColor = [UIColor colorWithHexString:@"#25262E"];
        self.statusL.font = XGTWOBoldFontSize;
        self.statusL.textAlignment = NSTextAlignmentRight;
        [backView addSubview:self.statusL];
        
        UILabel *orderInfoL = [[UILabel alloc] initWithFrame:CGRectMake(10, 118, 100, 17)];
        orderInfoL.font = TWOTEXTFONTSIZE;
        orderInfoL.text = @"订单信息";
        orderInfoL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backView addSubview:orderInfoL];
        
        self.comButton = [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.size.width-10-80, 110, 80, 32)];
        self.comButton.titleLabel.font = TWOTEXTFONTSIZE;
        [self.comButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
        [self.comButton setTitle:@"暂无评价" forState:UIControlStateNormal];
        self.comButton.layer.cornerRadius = 16;
        self.comButton.layer.masksToBounds = YES;
        self.comButton.layer.borderWidth = 1;
        self.comButton.layer.borderColor = [UIColor colorWithHexString:@"#A1A7B3"].CGColor;
        [backView addSubview:self.comButton];
        [self.comButton addTarget:self action:@selector(comClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)shopTap{
    if (self.isUser) {
        NoticdShopDetailForUserController *ctl = [[NoticdShopDetailForUserController alloc] init];
        NoticeMyShopModel *model = [[NoticeMyShopModel alloc] init];
        model.shopId = self.orderM.shop_id;
        ctl.shopModel = model;
        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (void)comClick{
    __weak typeof(self) weakSelf = self;
    if(self.isUser){

        if(_orderM.is_comment.intValue == 0){//没有评价的时候点击进入评价
            NoticeGoToComShopController *ctl = [[NoticeGoToComShopController alloc] init];
            ctl.orderM = self.orderM;
            ctl.hasComBlock = ^(NSString * _Nonnull orderId) {
                if([weakSelf.orderM.orderId isEqualToString:orderId]){
                    weakSelf.orderM.is_comment = @"1";
                    [weakSelf.comButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
                    [weakSelf.comButton setTitle:@"查看评价" forState:UIControlStateNormal];
                    weakSelf.comButton.layer.borderWidth = 1;
                    weakSelf.comButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
                }
         
            };
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }else if(_orderM.is_comment.intValue == 1){//有评价的时候点击查看评价
            NoticeOrderComDetailController *ctl = [[NoticeOrderComDetailController alloc] init];
            ctl.orderId = self.orderM.orderId;
            ctl.goodsUrl = self.orderM.goods_img_url;
            ctl.isVoice = self.orderM.room_id.intValue?YES:NO;
            ctl.orderName = self.orderM.goods_name;
            ctl.time = self.orderM.created_at;
            ctl.second = self.orderM.voice_duration;
            ctl.needDelete = YES;
            
            ctl.hasDeleteComBlock = ^(NSString * _Nonnull orderId) {
                if([weakSelf.orderM.orderId isEqualToString:orderId]){
                    weakSelf.orderM.is_comment = @"2";
                    [weakSelf.comButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
                    [weakSelf.comButton setTitle:@"评价已删除" forState:UIControlStateNormal];
                    weakSelf.comButton.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
                    weakSelf.comButton.layer.cornerRadius = 16;
                    weakSelf.comButton.layer.borderWidth = 1;
                    weakSelf.comButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
                }
            };
            [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
        }
    }else{
        NoticeOrderComDetailController *ctl = [[NoticeOrderComDetailController alloc] init];
        ctl.orderId = self.orderM.orderId;
        ctl.goodsUrl = self.orderM.goods_img_url;
        ctl.isVoice = self.orderM.room_id.intValue?YES:NO;
        ctl.orderName = self.orderM.goods_name;
        ctl.time = self.orderM.created_at;
        ctl.second = self.orderM.voice_duration;

        [[NoticeTools getTopViewController].navigationController pushViewController:ctl animated:YES];
    }
}

- (UIImageView *)intoImageView{
    if(!_intoImageView){
        _intoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(38+GET_STRWIDTH(self.userNameL.text, 14, 20), 10, 20, 20)];
        _intoImageView.image = UIImageNamed(@"Image_lookShopjt");
        _intoImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shopTap)];
        [_intoImageView addGestureRecognizer:tap1];
        [self.backV addSubview:_intoImageView];
    }
    return _intoImageView;
}

- (void)setOrderM:(NoticeOrderListModel *)orderM{
    _orderM = orderM;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:orderM.goods_img_url]];
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:self.isUser?orderM.shop_avatar_url: orderM.avatar_url]];
    self.shopNameL.text = self.orderM.room_id.intValue?[NSString stringWithFormat:@"%@*%@",self.orderM.goods_name,[self getMMSSFromSS:self.orderM.voice_duration]]: [NSString stringWithFormat:@"文字聊天*%@",self.orderM.goods_name];
    
    NSString *allStr = [NSString stringWithFormat:@"%@鲸币(%@分钟)",orderM.room_id.intValue ?orderM.unit_price: orderM.price,orderM.duration];
    NSString *str1 = [NSString stringWithFormat:@"%@鲸币",orderM.room_id.intValue ?orderM.unit_price: orderM.price];
    NSString *str2 = [NSString stringWithFormat:@"(%@分钟)",orderM.duration];
    self.priceL.attributedText = [DDHAttributedMode setSizeAndColorString:allStr setColor:[UIColor colorWithHexString:@"#5C5F66"] setSize:12 setLengthString:str2 beginSize:str1.length];
    
    self.userNameL.text =self.isUser?orderM.shop_name: orderM.user_nick_name;
    
    if(self.isUser){
        self.intoImageView.hidden = NO;
        self.intoImageView.frame = CGRectMake(38+GET_STRWIDTH(self.userNameL.text, 14, 20), 10, 20, 20);
        self.userNameL.font = XGTHREEBoldFontSize;
        self.userNameL.textColor = [UIColor blackColor];
        self.userNameL.frame =CGRectMake(38, 10, GET_STRWIDTH(self.userNameL.text, 14, 20), 20);
    }else{
        self.userNameL.font = TWOTEXTFONTSIZE;
        self.userNameL.frame = CGRectMake(38, 11, 128, 17);
        _intoImageView.hidden = YES;
        self.userNameL.textColor = [UIColor colorWithHexString:@"#8A8F99"];
    }
    
    self.payL.hidden = YES;
    
    self.comButton.hidden = YES;
    if (orderM.order_type.intValue == 3 || orderM.order_type.intValue == 2) {
        self.statusL.text = @"拒绝订单";
    }else if (orderM.order_type.intValue == 4){
        self.statusL.text = @"接单超时";
    }else if (orderM.order_type.intValue == 6){
        self.statusL.text = @"已完成";
        self.payL.hidden = NO;
        self.comButton.hidden = NO;
    }else if (orderM.order_type.intValue == 7){
        self.statusL.text = @"订单异常，审核中";
    }else if (orderM.order_type.intValue == 8){
        if(orderM.is_fault.intValue == 2){//卖家过错
            self.statusL.text  = @"交易失败";
        }else{
            self.payL.hidden = NO;
            self.statusL.text = @"已完成";
            self.comButton.hidden = NO;
        }
    }
    
    self.comButton.layer.borderColor = [UIColor colorWithHexString:@"#A1A7B3"].CGColor;
    if(self.isUser){
        self.payL.text = [NSString stringWithFormat:@"支付:%@鲸币",orderM.price];
        if(orderM.is_comment.intValue == 0){
            [self.comButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            [self.comButton setTitle:@"给个评价" forState:UIControlStateNormal];
            self.comButton.layer.borderWidth = 0;
            self.comButton.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        }else if(orderM.is_comment.intValue == 1){
            [self.comButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            [self.comButton setTitle:@"查看评价" forState:UIControlStateNormal];
            self.comButton.layer.borderWidth = 1;
            self.comButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }else if(orderM.is_comment.intValue == 2){
            [self.comButton setTitleColor:[UIColor colorWithHexString:@"#A1A7B3"] forState:UIControlStateNormal];
            [self.comButton setTitle:@"评价已删除" forState:UIControlStateNormal];
            self.comButton.layer.borderColor = [UIColor colorWithHexString:@"#F7F8FC"].CGColor;
            self.comButton.layer.cornerRadius = 16;
            self.comButton.layer.borderWidth = 1;
            self.comButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
    }else{
        self.payL.text = [NSString stringWithFormat:@"实收:%@鲸币",orderM.income];
        if(orderM.is_comment.intValue == 1){
            [self.comButton setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
            [self.comButton setTitle:@"查看评价" forState:UIControlStateNormal];
            self.comButton.layer.borderWidth = 0;
            self.comButton.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
        }else{
            [self.comButton setTitleColor:[UIColor colorWithHexString:@"#25262E"] forState:UIControlStateNormal];
            [self.comButton setTitle:@"暂无评价" forState:UIControlStateNormal];
            self.comButton.layer.borderWidth = 1;
            self.comButton.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }
    }

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
