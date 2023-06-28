
#import "PGBubble.h"
#import "UIView+MGExtension.h"
#import "YYKit.h"


@interface PGBubble()
@property (nonatomic, strong) YYAnimatedImageView *sendImageView;
@property (nonatomic, strong) UIView *keyBackView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *line2;
/// 自动计算上下尖头
@property (nonatomic) CGFloat top_H;

@end


@implementation PGBubble

// 初始化的时候 高度可以随意给 宽度给定就好
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubView];
    }
    return self;
}

- (void) addSubView {
    self.backgroundColor = [GetColorWithName(VMainThumeColor) colorWithAlphaComponent:0];
    UIView *keyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, DR_SCREEN_HEIGHT)];
    keyView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0];
    [keyView addSubview:self];
    [kMainWindow addSubview:keyView];
    keyView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [keyView addGestureRecognizer:tap];
    self.keyBackView = keyView;

    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)]];
    
    self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.backImageView.backgroundColor = [UIColor colorWithHexString:@"#25262E"];
    [self addSubview:self.backImageView];
    self.backImageView.layer.cornerRadius = 8;
    self.backImageView.layer.masksToBounds = YES;
    self.backImageView.userInteractionEnabled = YES;
    
    _sendImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(12,15,self.frame.size.width-24,self.frame.size.width-24)];
    _sendImageView.contentMode = UIViewContentModeScaleAspectFill;
    _sendImageView.clipsToBounds = YES;
    _sendImageView.userInteractionEnabled = YES;
    _sendImageView.layer.cornerRadius = 5;
    _sendImageView.layer.masksToBounds = YES;
    [self addSubview:_sendImageView];
        
    NSArray *arr = @[[NoticeTools getLocalStrWith:@"emtion.movefont"],[NoticeTools getLocalStrWith:@"groupManager.del"]];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2*i, self.frame.size.height-5-35, self.frame.size.width/2, 35)];
        [btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = TWOTEXTFONTSIZE;
        btn.tag = i;
        [btn addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backImageView addSubview:btn];
        if (i==0) {
            self.btn1 = btn;
            btn.frame = CGRectMake(10, self.frame.size.height-5-35, 50, 35);
        }else{
            btn.frame = CGRectMake(94, self.frame.size.height-5-35, 26, 35);
            self.btn2 = btn;
        }
    }

    UIView *hline = [[UIView alloc] initWithFrame:CGRectMake(0, self.btn1.frame.origin.y-1, self.backImageView.frame.size.width, 1)];
    hline.backgroundColor = [UIColor colorWithHexString:@"#383A42"];
    [self.backImageView addSubview:hline];
    self.line = hline;
    
    UIView *sline = [[UIView alloc] initWithFrame:CGRectMake((self.backImageView.frame.size.width-1)/2, self.btn1.frame.origin.y,1, 35)];
    sline.backgroundColor = [UIColor colorWithHexString:@"#383A42"];
    [self.backImageView addSubview:sline];
    self.line2 = sline;
}

- (void)setType:(NSInteger)type{
    _type = type;
    if (type == 1) {
        [self.btn1 setTitle:[NoticeTools getLocalType]==1?@"Best":@"精华" forState:UIControlStateNormal];
        self.btn1.frame = CGRectMake(0, self.frame.size.height-5-35, self.frame.size.width/2, 35);
        self.btn2.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height-5-35, self.frame.size.width/2, 35);
        [self.btn2 setTitle:[NoticeTools getLocalStrWith:@"groupManager.del"] forState:UIControlStateNormal];
    }else if (type == 2){
        [self.btn1 setTitle:[NoticeTools getLocalStrWith:@"emtion.movefont"] forState:UIControlStateNormal];
        [self.btn2 setTitle:[NoticeTools getLocalStrWith:@"main.cancel"] forState:UIControlStateNormal];
        self.btn1.frame = CGRectMake(0, self.frame.size.height-5-35, self.frame.size.width/2, 35);
        self.btn2.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height-5-35, self.frame.size.width/2, 35);
    }else if (type == 3){
        self.line.hidden = YES;
        self.line2.hidden = YES;
        [self.btn1 setTitle:[NoticeTools getLocalStrWith:@"emtion.sc"] forState:UIControlStateNormal];
        self.btn2.hidden = YES;
        self.btn1.frame = CGRectMake(0, self.frame.size.height-5-35, self.frame.size.width, 35);
    }
}

- (void)actionClick:(UIButton *)btn{
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
    [self dismiss];
}

- (void) configData {
    
    self.isAnimation    = self.isAnimation ? self.isAnimation : NO;
    self.backgroundColor          = [GetColorWithName(VMainThumeColor) colorWithAlphaComponent:0];
    
    [self show];
}

-(void)showWithView:(UIView *)view {
    [_sendImageView sd_setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:GETUIImageNamed(@"img_empty") options:SDWebImageRefreshCached];

    
    CGRect absoluteRect = [view convertRect:view.bounds toView:kMainWindow];
    CGPoint relyPoint = CGPointMake(absoluteRect.origin.x + absoluteRect.size.width / 2, absoluteRect.origin.y + absoluteRect.size.height);
    
    //默认数据配置
    [self configData];
    
    self.frame = CGRectMake((relyPoint.x-self.frame.size.width/2)>0?(relyPoint.x-self.frame.size.width/2):5, relyPoint.y - self.frame.size.height - view.height+(self.isHalf?80:0) , self.frame.size.width, self.frame.size.height);
    if (CGRectGetMaxX(self.frame) > DR_SCREEN_WIDTH) {
        self.frame = CGRectMake(DR_SCREEN_WIDTH-self.frame.size.width-5, relyPoint.y - self.frame.size.height - view.height+(self.isHalf?80:0), self.frame.size.width, self.frame.size.height);
    }
}


- (void)show
{
    self.layer.affineTransform = CGAffineTransformMakeScale(0.1, 0.1);
    [self.keyBackView addSubview:self];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.95 options:UIViewAnimationOptionCurveLinear animations:^{
        self.layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)dismiss
{
    [self.keyBackView removeFromSuperview];
}

@end
