//
//  NoticeDownOrUpRefreshView.m
//  NoticeXi
//
//  Created by li lei on 2021/7/10.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeDownOrUpRefreshView.h"
#import "ZFSDateFormatUtil.h"
@implementation NoticeDownOrUpRefreshView

- (void)setIsUp:(BOOL)isUp{
    if (isUp) {
        self.svagPlayer = [[SVGAPlayer alloc] initWithFrame:CGRectMake(0,0,DR_SCREEN_WIDTH, self.frame.size.height)];
   
        self.parser = [[SVGAParser alloc] init];
        //bottombig
        [self.parser parseWithNamed:@"bluebig" inBundle:nil completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
            self.svagPlayer.videoItem = videoItem;
        } failureBlock:nil];

        [self addSubview:self.svagPlayer];
    }else{
        self.textL = [[UILabel alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, DR_SCREEN_WIDTH, self.frame.size.height-STATUS_BAR_HEIGHT)];
        self.textL.font = TWOTEXTFONTSIZE;
        self.textL.textAlignment = NSTextAlignmentCenter;
        self.textL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        [self addSubview:self.textL];
        
    }
}

- (void)refreshText{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSString *curTime = [NoticeTools timeDataAppointFormatterWithTime:currentTime appointStr:@"yyyy-MM-dd"];
    

    NSInteger night = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 09:00:00",curTime]];
    NSInteger eighteenTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 20:00:00",curTime]];
    NSInteger zeroTime = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 00:00:00",curTime]];
    NSInteger sixMon = [ZFSDateFormatUtil timeIntervalWithDateString:[NSString stringWithFormat:@"%@ 06:00:00",curTime]];
    
    if (currentTime >= sixMon && currentTime < night) {//六点到九点
        DRLog(@"六点到九点");
        self.textL.text = self.monArr[arc4random()%self.monArr.count];
    }else if (currentTime >= night && currentTime < eighteenTime){//九点到晚上八点
        DRLog(@"九点到晚上八点");
        self.textL.text = self.whiteArr[arc4random()%self.whiteArr.count];
    }else if (currentTime >= zeroTime && currentTime < sixMon){//零点到六点
        DRLog(@"零点到六点");
        self.textL.text = self.darkArr[arc4random()%self.darkArr.count];
    }else{
        self.textL.text = self.nightArr[arc4random()%self.nightArr.count];
    }
}

- (NSMutableArray *)darkArr{
    if (!_darkArr) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"refreshPlist" ofType:@"plist"];
        NSDictionary *testDict =[NSDictionary dictionaryWithContentsOfFile:path];//获取plist字典
        _darkArr = [NSMutableArray arrayWithArray:testDict[@"darkNight"]];
    }
    return _darkArr;
}

- (NSMutableArray *)nightArr{
    if (!_nightArr) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"refreshPlist" ofType:@"plist"];
        NSDictionary *testDict =[NSDictionary dictionaryWithContentsOfFile:path];//获取plist字典
        _nightArr = [NSMutableArray arrayWithArray:testDict[@"night"]];
    }
    return _nightArr;
}

- (NSMutableArray *)whiteArr{
    if (!_whiteArr) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"refreshPlist" ofType:@"plist"];
        NSDictionary *testDict =[NSDictionary dictionaryWithContentsOfFile:path];//获取plist字典
        _whiteArr = [NSMutableArray arrayWithArray:testDict[@"white"]];
    }
    return _whiteArr;
}

- (NSMutableArray *)monArr{
    if (!_monArr) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"refreshPlist" ofType:@"plist"];
        NSDictionary *testDict =[NSDictionary dictionaryWithContentsOfFile:path];//获取plist字典
        _monArr = [NSMutableArray arrayWithArray:testDict[@"moning"]];
    }
    return _monArr;
}

@end
