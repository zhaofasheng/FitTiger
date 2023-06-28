//
//  NoticeTextZJContentView.m
//  NoticeXi
//
//  Created by li lei on 2021/1/18.
//  Copyright © 2021 zhaoxiaoer. All rights reserved.
//

#import "NoticeTextZJContentView.h"
#import "NoticeTextZJContentCell.h"
@implementation NoticeTextZJContentView
{
    UIView *_noDataL;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [NoticeTools getWhiteColor:@"#F7F7F7" NightColor:@"#12121F"];
        
        self.musicBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 9, 22, 22)];
        [self.musicBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_textzjbtnm_b":@"Image_textzjbtnm_y") forState:UIControlStateNormal];
        [self addSubview:self.musicBtn];
        
        self.contentBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-22-22-15, 9, 22, 22)];
        [self.contentBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_tzjchoice_b":@"Image_tzjchoice_y") forState:UIControlStateNormal];
        [self addSubview:self.contentBtn];
        
        self.listBtn = [[UIButton alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH-15-22, 9, 22, 22)];
        [self.listBtn setBackgroundImage:UIImageNamed([NoticeTools isWhiteTheme]?@"Image_tzjlistnoc_b":@"Image_tzjlistnoc_y") forState:UIControlStateNormal];
        [self addSubview:self.listBtn];
        
        NoticeScrollView *scrollView = [[NoticeScrollView alloc] initWithFrame:CGRectMake(0,40, DR_SCREEN_WIDTH,frame.size.height-40)];
        [self addSubview:scrollView];
        self.scroolView = scrollView;
        scrollView.delegate = self;
        scrollView.pagingEnabled = YES;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = NO;
        
        _noDataL = [[UIView alloc] initWithFrame:CGRectMake(30, 40, DR_SCREEN_WIDTH-60, frame.size.height-40-30)];
        _noDataL.backgroundColor = GetColorWithName(VBackColor);
        _noDataL.layer.cornerRadius = 3;
        _noDataL.layer.masksToBounds = YES;
        UIImageView *nodataImg = [[UIImageView alloc] initWithFrame:CGRectMake((_noDataL.frame.size.width-35)/2, (_noDataL.frame.size.height-178)/2, 35, 178)];
        nodataImg.image = UIImageNamed([NoticeTools isWhiteTheme]?@"Image_sutextb":@"Image_sutexty");
   
        [_noDataL addSubview:nodataImg];
        [self addSubview:_noDataL];
         
        self.viewArr = [NSMutableArray new];
    }
    return self;
}

- (void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;
    _noDataL.hidden = dataArr.count?YES:NO;
    self.scroolView.contentSize = CGSizeMake(DR_SCREEN_WIDTH*dataArr.count, 0);
    for (int i = 0; i < dataArr.count; i++) {
        
        if (self.viewArr.count) {
            if ((i <= self.viewArr.count-1)) {//如果前面已经有，就不要再创建
                NoticeTextZJContentCell *cell = self.viewArr[i];
                cell.voiceM = dataArr[i];
            }else{//没有则创建
                NoticeTextZJContentCell *cell = [[NoticeTextZJContentCell alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH*i, 0, self.scroolView.frame.size.width, self.scroolView.frame.size.height)];
                cell.voiceM = dataArr[i];
                [self.scroolView addSubview:cell];
                [self.viewArr addObject:cell];
            }
        }else{
            NoticeTextZJContentCell *cell = [[NoticeTextZJContentCell alloc] initWithFrame:CGRectMake(DR_SCREEN_WIDTH*i, 0, self.scroolView.frame.size.width, self.scroolView.frame.size.height)];
            cell.voiceM = dataArr[i];
            [self.scroolView addSubview:cell];
            [self.viewArr addObject:cell];
        }

    }
}

- (void)setCurrentModel:(NoticeVoiceListModel *)currentModel{
    _currentModel = currentModel;
    NSInteger i = 0;
    BOOL hasFind = NO;
    for (NoticeVoiceListModel *model in self.dataArr) {
        if ([model.voice_id isEqualToString:currentModel.voice_id]) {
            hasFind = YES;
            break;
        }
        i++;
    }
    if (hasFind) {
        [self.scroolView setContentOffset:CGPointMake(DR_SCREEN_WIDTH*i, 0)];
    }
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //ScrollView中根据滚动距离来判断当前页数
    int page = (int)scrollView.contentOffset.x/DR_SCREEN_WIDTH;
    
    if (page <= self.dataArr.count-1) {
        if (self.getCurrentBlock) {
            self.getCurrentBlock(self.dataArr[page]);
        }
    }
}


@end
