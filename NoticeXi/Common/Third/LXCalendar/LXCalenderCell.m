
#import "LXCalenderCell.h"
#import "NoticeTieTieCaleModel.h"
@interface LXCalenderCell()


@end

@implementation LXCalenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, (int)frame.size.width-10, (int)frame.size.width-10)];
        self.label.layer.cornerRadius = self.label.frame.size.width/2;
        self.label.layer.masksToBounds = YES;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = SIXTEENTEXTFONTSIZE;
        self.label.backgroundColor = [[UIColor colorWithHexString:@"#EBECF0"] colorWithAlphaComponent:0];
        self.label.textColor = [UIColor colorWithHexString:@"#A1A7B3"];
        self.label.layer.borderColor = [UIColor colorWithHexString:@"#0099E6"].CGColor;
        
        
        self.imageView.hidden = YES;
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];
        
        self.smallTimeL = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.label.frame)+3, self.label.frame.size.width, 16)];
        self.smallTimeL.textAlignment = NSTextAlignmentCenter;
        self.smallTimeL.font = ELEVENTEXTFONTSIZE;
        self.smallTimeL.layer.cornerRadius = 8;
        self.smallTimeL.layer.masksToBounds = YES;
        [self.contentView addSubview:self.smallTimeL];
    
        self.backgroundColor = [[UIColor colorWithHexString:@"#F7F8FC"] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;
        
        
    }
    return self;
}

- (void)setNomerModel:(LXCalendarDayModel *)nomerModel{
    self.smallTimeL.hidden = YES;
    self.label.text = [NSString stringWithFormat:@"%ld",nomerModel.day];
    self.label.font = [UIFont systemFontOfSize:self.isCanTap?14: 10];
    self.label.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];

    if (self.netDataArr.count && !nomerModel.voice.intValue) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == %@ && month == %@ && year = %@",nomerModel.dayName,nomerModel.monthName,nomerModel.yearName];//谓词过滤查找数组中年份相同的数据,这里找到年份相同的数据 "yearName"为数组里面的属性值key，必须为字符串
        NSArray *sameYearArr = [self.netDataArr filteredArrayUsingPredicate:predicate];
        if (sameYearArr.count) {
            NoticeTieTieCaleModel *tModel = sameYearArr[0];
            nomerModel.voice = tModel.voice;
            nomerModel.img_url = tModel.img_url;
        }
    }
    
    self.label.layer.cornerRadius = 4;
    
    if (nomerModel.voice.intValue) {//有心情
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = [UIColor colorWithHexString:@"#FFA6A6"];
    }else{
        self.label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.label.textColor = [UIColor colorWithHexString:@"#25262E"];
    }
    
    if(nomerModel.img_url.length > 10){
        self.imageView.hidden = NO;
        self.label.backgroundColor = [[UIColor colorWithHexString:@"#EBECF0"] colorWithAlphaComponent:0];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:nomerModel.img_url]];
    }else{
        self.imageView.hidden = YES;
    }
    
    if(nomerModel.choiceEd){//选中
        self.label.layer.borderWidth = 2;
    }else{
        self.label.layer.borderWidth = 0;
    }

    if (nomerModel.isToday) {
        self.label.text = @"今天";
    }
   
    
    
    self.userInteractionEnabled = self.isCanTap?YES: NO;
    if (nomerModel.isNextMonth || nomerModel.isLastMonth) {
        self.label.hidden = YES;
    }else{
        self.label.hidden = NO;
    }
    
    if (self.isCanTap) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;
    }
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:self.label.frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        UIView *mbV = [[UIView alloc] initWithFrame:_imageView.bounds];
        mbV.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        [_imageView addSubview:mbV];
    }
    return _imageView;
}


- (void)setSmallModel:(LXCalendarDayModel *)smallModel{
    _smallModel = smallModel;
    self.smallTimeL.hidden = YES;
    self.label.text = [NSString stringWithFormat:@"%ld",smallModel.day];
    self.label.font = [UIFont systemFontOfSize:self.isCanTap?14: 10];
    self.label.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    if (smallModel.isToday) {
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = [UIColor colorWithHexString:@"#2E66FF"];
    }
    
    self.userInteractionEnabled = self.isCanTap?YES: NO;
    if (smallModel.isNextMonth || smallModel.isLastMonth) {
        self.label.hidden = YES;
    }else{
        self.label.hidden = NO;
    }
    
    if (self.netDataArr.count  && !smallModel.voice.intValue) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"day == %@ && month == %@  && year = %@",smallModel.dayName,smallModel.monthName,smallModel.yearName];//谓词过滤查找数组中年份相同的数据,这里找到年份相同的数据 "yearName"为数组里面的属性值key，必须为字符串
        NSArray *sameYearArr = [self.netDataArr filteredArrayUsingPredicate:predicate];
    
        if (sameYearArr.count) {
            NoticeTieTieCaleModel *tModel = sameYearArr[0];
            smallModel.voice = tModel.voice;
        }
      
    }
    
    if (smallModel.voice.intValue) {
        self.label.textColor = [UIColor whiteColor];
        self.label.backgroundColor = [UIColor colorWithHexString:@"#FFA6A6"];
    }
    
    if (self.isCanTap) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.contentView.backgroundColor = self.backgroundColor;
    }
}

- (void)setIsCanTap:(BOOL)isCanTap{
    _isCanTap = isCanTap;
    if (isCanTap) {
        self.label.font = FOURTHTEENTEXTFONTSIZE;
    }
}

-(void)setModel:(LXCalendarDayModel *)model{
    _model = model;
    
    self.label.text = [NSString stringWithFormat:@"%ld",model.day];
    
    self.smallTimeL.text = self.label.text;
    self.smallTimeL.textColor = [UIColor colorWithHexString:@"#25262E"];
    self.smallTimeL.backgroundColor = [UIColor colorWithHexString:@"#F7F8FC"];
    self.smallTimeL.hidden = NO;
    self.statusImageView.hidden = YES;
    
    if (self.currentTieTieModel && self.currentTieTieModel.list.count) {
        for (NoticeTieTieModel *tieM in self.currentTieTieModel.list) {
            if (tieM.year==model.year && tieM.month == model.month && tieM.day == model.day) {
                model.number = tieM.number;
                break;
            }
        }
    }

    
    if (model.isNextMonth || model.isLastMonth) {
        self.userInteractionEnabled = NO;
       
        if (model.isShowLastAndNextDate) {
            
            self.label.hidden = NO;
            if (model.isNextMonth) {
                self.label.textColor = model.nextMonthTitleColor? model.nextMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
            }
            
            if (model.isLastMonth) {
                self.label.textColor = model.lastMonthTitleColor? model.lastMonthTitleColor:[UIColor colorWithWhite:0.85 alpha:1.0];
            }
        }else{
            self.statusImageView.hidden = YES;
            self.smallTimeL.hidden = YES;
            self.label.hidden = YES;
        }
    }else{

        self.label.hidden = NO;
        self.userInteractionEnabled = YES;
    
        if (model.number.intValue>0) {//有贴贴的情况
            self.label.hidden = YES;
            self.statusImageView.hidden = NO;
            if (model.number.intValue <= 10) {
                self.statusImageView.image = UIImageNamed(@"Image_tieteinum1");
            }else if (model.number.intValue >10 && model.number.intValue <= 15){
                self.statusImageView.image = UIImageNamed(@"Image_tieteinum2");
            }else if (model.number.intValue >15 && model.number.intValue <= 20){
                self.statusImageView.image = UIImageNamed(@"Image_tieteinum3");
            }else{
                self.statusImageView.image = UIImageNamed(@"Image_tieteinum4");
            }
            self.smallTimeL.hidden = NO;
            self.smallTimeL.text = model.number;
            self.smallTimeL.backgroundColor = [UIColor colorWithHexString:@"#FFA6A6"];
            self.smallTimeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        }else{//没贴贴的情况
            if (model.isOverToday || model.isToday) {//大于等于今天
                self.label.hidden = YES;
                self.statusImageView.hidden = NO;
                self.statusImageView.image = UIImageNamed(@"Image_notietiefurture");
                self.smallTimeL.hidden = NO;
            }else{
                self.smallTimeL.hidden = YES;
            }
            
            if (model.isToday) {//今天
                self.smallTimeL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
                self.smallTimeL.backgroundColor = [UIColor colorWithHexString:@"#2E66FF"];
                self.smallTimeL.text = [NoticeTools getLocalStrWith:@"minee.today"];
            }
        }
//        if (model.isSelected) {
//
//        }

    }
    
}
-(void)addAnimaiton{
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    
    anim.values = @[@0.6,@1.2,@1.0];
//    anim.fromValue = @0.6;
    anim.keyPath = @"transform.scale";  // transform.scale 表示长和宽都缩放
    anim.calculationMode = kCAAnimationPaced;
    anim.duration = 0.25;                // 设置动画执行时间
//    anim.repeatCount = MAXFLOAT;        // MAXFLOAT 表示动画执行次数为无限次
    
//    anim.autoreverses = YES;            // 控制动画反转 默认情况下动画从尺寸1到0的过程中是有动画的，但是从0到1的过程中是没有动画的，设置autoreverses属性可以让尺寸0到1也是有过程的
    
    [self.label.layer addAnimation:anim forKey:nil];
}
@end
