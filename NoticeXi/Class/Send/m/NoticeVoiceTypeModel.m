//
//  NoticeVoiceTypeModel.m
//  NoticeXi
//
//  Created by li lei on 2022/3/25.
//  Copyright © 2022 zhaoxiaoer. All rights reserved.
//

#import "NoticeVoiceTypeModel.h"

@implementation NoticeVoiceTypeModel

- (void)setType:(NSInteger)type{
    _type = type;
    NSArray *arr = @[[NoticeTools getLocalStrWith:@"luy.ys"],[NoticeTools getLocalStrWith:@"luy.ns"],[NoticeTools getLocalStrWith:@"luy.nns"],[NoticeTools getLocalStrWith:@"luy.mtt"],[NoticeTools getLocalStrWith:@"luy.ddy"],[NoticeTools getLocalStrWith:@"luy.xhz"],[NoticeTools getLocalStrWith:@"luy.jzy"],[NoticeTools getLocalStrWith:@"luy.bxjg"],[NoticeTools getLocalStrWith:@"luy.xhr"]];

    if (type <= arr.count-1) {
        self.typeName = arr[type];
    }
    if (type == 0) {//原声
        self.speed = 0;
        self.fenbei = 0;
        self.rate = 0;
        self.cRate = 44100;
    }else if (type == 1) {//女声
        self.speed = 0;
        self.fenbei = 6;
        self.rate = 0;
        self.cRate = 44100;
    }else if (type == 2) {//男生
        self.speed = 0;
        self.fenbei = -4;
        self.rate = 0;
        self.cRate = 44100;
    }else if (type == 3) {//慢吞吞
        self.speed = -50;
        self.fenbei = 0;
        self.rate = 0;
        self.cRate = 44100;
    }else if (type == 4) {//嗲嗲音
        self.speed = 0;
        self.fenbei = 8;
        self.rate = 24;
        self.cRate = 36064;
       
    }else if (type == 5) {//小孩纸
        self.speed = -4;
        self.fenbei = 15;
        self.rate = 0;
        self.cRate = 36032;
    }else if (type == 6) {//夹子音
        self.speed = -20;
        self.fenbei = 10;
        self.rate = 0;
        self.cRate = 44100;
    }else if (type == 7) {//变形金刚
        self.speed = 0;
        self.fenbei = -13;
        self.rate = 0;
        self.cRate = 44100;
    }else if (type == 8) {//小黄人
        self.speed = 0;
        self.fenbei = 4;
        self.rate = 65;
        self.cRate = 44100;
    }
    self.typeImageName =[NSString stringWithFormat:@"voicetype%ld",type];
}

@end
