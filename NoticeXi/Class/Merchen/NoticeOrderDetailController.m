//
//  NoticeOrderDetailController.m
//  NoticeXi
//
//  Created by li lei on 2022/7/17.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeOrderDetailController.h"

@interface NoticeOrderDetailController ()

@end

@implementation NoticeOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.needHideNavBar = YES;
    self.navBarView.hidden = NO;
    [self.navBarView.backButton setImage:UIImageNamed(@"Image_blackBack") forState:UIControlStateNormal];
    [self.navBarView.backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView removeFromSuperview];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 160)];
    colorView.backgroundColor = [UIColor colorWithHexString:!self.orderM.isNoFinish? @"#A0D697" : @"#A1A7B3"];
    [self.view addSubview:colorView];
    
    UILabel *statusL = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, DR_SCREEN_WIDTH, 28)];
    statusL.textColor = [UIColor colorWithHexString:@"#25262E"];
    statusL.font = [UIFont systemFontOfSize:20];
    statusL.textAlignment = NSTextAlignmentCenter;
    statusL.text =  self.orderM.goods_name;
    [colorView addSubview:statusL];
    if (_orderM.order_type.intValue == 3) {
        statusL.text = @"拒绝订单";
    }else if (_orderM.order_type.intValue == 4){
        statusL.text = @"接单超时";
    }else if (_orderM.order_type.intValue == 6){
        statusL.text = @"已完成";
    }else if (_orderM.order_type.intValue == 7){
        statusL.text = @"订单异常，审核中";
    }else if (_orderM.order_type.intValue == 8){
        statusL.text = _orderM.isNoFinish?@"交易失败" : @"已完成";
    }
    
    UIImageView *backImageV = [[UIImageView alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-345)/2, NAVIGATION_BAR_HEIGHT+46, 345, 405)];
    backImageV.image = UIImageNamed(self.orderM.isNoFinish?@"color_shopimgn": @"color_shopimg");
    [self.view addSubview:backImageV];
    backImageV.userInteractionEnabled = YES;
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 40, 40)];
    iconImageView.layer.cornerRadius = 5;
    iconImageView.layer.masksToBounds = YES;
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.orderM.goods_img_url]];
    [backImageV addSubview:iconImageView];
        
    UILabel *shopNameL = [[UILabel alloc] initWithFrame:CGRectMake(70, 39, GET_STRWIDTH(@"语音通话*00时00秒00分", 16, 22), 22)];
    shopNameL.textColor = [UIColor colorWithHexString:@"#25262E"];
    shopNameL.font = SIXTEENTEXTFONTSIZE;
    shopNameL.text = self.orderM.room_id.intValue?[NSString stringWithFormat:@"%@*%@",self.orderM.goods_name,[self getMMSSFromSS:self.orderM.voice_duration]]: [NSString stringWithFormat:@"文字聊天*%@",self.orderM.goods_name];
    [backImageV addSubview:shopNameL];
    
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 120+32*i, 62, 17)];
        label.font = TWOTEXTFONTSIZE;
        label.textColor = [UIColor colorWithHexString:@"#8A8F99"];
        [backImageV addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 120+32*i, 200, 17)];
        label1.font = TWOTEXTFONTSIZE;
        label1.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backImageV addSubview:label1];
        
        if (i == 0) {
            if (self.orderM.isNoFinish) {
                label.text = @"下单时间：";
                label1.text = self.orderM.created_at;
            }else{
                label.text = @"订单编号：";
                label1.text = self.orderM.sn;
            }
        }else if (i == 1) {
            if (self.orderM.isNoFinish) {
                label.text = @"失效原因：";
                if (_orderM.order_type.intValue == 3) {
                    label1.text = @"店主拒绝订单";
                }else if (_orderM.order_type.intValue == 4){
                    label1.text = @"接单超时";
                }else if (_orderM.order_type.intValue == 8){
                    label1.text = @"违规订单";
                }else if (_orderM.order_type.intValue == 2){
                    label1.text = @"买家取消订单";
                }
            }else{
                label.text = @"下单时间：";
                label1.text = self.orderM.created_at;
            }
        }else{
            if (!self.orderM.isNoFinish) {
                label.text = @"订单时长：";
                
                if(self.orderM.room_id.intValue){
                    label1.text = [self getMMSSFromSS:self.orderM.voice_duration];
                }else{
                    label1.text = [NSString stringWithFormat:@"%@分钟",self.orderM.duration];
                }
            }
        }
    }
    

    if (!self.orderM.isNoFinish) {
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(backImageV.frame.size.width-10-20, 120, 20, 20)];
        [btn setBackgroundImage:UIImageNamed(@"copy_shopsn") forState:UIControlStateNormal];
        [backImageV addSubview:btn];
        [btn addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel *priclabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, DR_SCREEN_WIDTH-40-40, 28)];
        priclabel.font = [UIFont systemFontOfSize:20];
        priclabel.textAlignment = NSTextAlignmentRight;
        priclabel.textColor = [UIColor colorWithHexString:@"#25262E"];
        [backImageV addSubview:priclabel];
        if ( _orderM.order_type.intValue == 7){
            if([self.orderM.shop_user_id isEqualToString:[NoticeTools getuserId]]){//自己是店主
                priclabel.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"实收款：%@",@"审核中"] setSize:12 setLengthString:@"实收款：" beginSize:0];
            }else{
                priclabel.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"实付款：%@",@"审核中"] setSize:12 setLengthString:@"实付款：" beginSize:0];
            }
            
           
        }else{
            if([self.orderM.shop_user_id isEqualToString:[NoticeTools getuserId]]){//自己是店主
                priclabel.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"实收款：%@鲸币",self.orderM.income] setSize:12 setLengthString:@"实收款：" beginSize:0];
            }else{
                priclabel.attributedText = [DDHAttributedMode setString:[NSString stringWithFormat:@"实付款：%@鲸币",self.orderM.price] setSize:12 setLengthString:@"实付款：" beginSize:0];
            }
      
        }
    }
    
    [self.view bringSubviewToFront:self.navBarView];

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


- (void)copyClick{
    [self showToastWithText:@"订单编号已复制"];
    UIPasteboard *pastboard = [UIPasteboard generalPasteboard];
    [pastboard setString:self.orderM.sn];
}

- (void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (appdel.floatView.isPlaying) {
        appdel.floatView.noRePlay = YES;
        [appdel.floatView.audioPlayer stopPlaying];
    }
    appdel.floatView.hidden = YES;

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdel.floatView.hidden = [NoticeTools isHidePlayThisDeveiceThirdVC]?YES: NO;

}
@end
