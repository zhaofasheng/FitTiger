

#import "LHEditTextView.h"
#import "AppDelegate.h"
#import "LHTopTextView.h"


@interface LHEditTextView()<UIGestureRecognizerDelegate>


@property (nonatomic,weak)LHTopTextView *topTextView;
@property (nonatomic,weak)UIViewController *controller;
@end

@implementation LHEditTextView

-(instancetype)initWithController:(UIViewController *)controller isAdd:(BOOL)isAdd{
    self=[super init];
    if(self){
        //黑色半透明背景
        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        UIButton *grayBgView=[UIButton buttonWithType:UIButtonTypeCustom];
        grayBgView.frame=[UIScreen mainScreen].bounds;
        grayBgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [app.window.rootViewController.view addSubview:grayBgView];
        grayBgView.hidden=YES;
        self.grayBgView=grayBgView;
        
        
        [grayBgView addTarget:self action:@selector(popAndPushPickerView) forControlEvents:UIControlEventTouchUpInside];
        
        LHTopTextView *topTextView=[[LHTopTextView alloc]initWithFrame:CGRectMake((DR_SCREEN_WIDTH-263)/2, controller.view.bounds.size.height/3-30, 263,118)];
        topTextView.isAdd = isAdd;
        self.topTextView=topTextView;
        if (isAdd) {
            topTextView.submitBlock=^(NSString *text){
                if (!text) {
                    return ;
                }
                [self popAndPushPickerView];
                if (self.requestTwoDataBlock) {
                    self.requestTwoDataBlock(text, nil);
                }
            };
            topTextView.submitImageBlock = ^(NSString *text) {
                if (!text) {
                    return ;
                }
                [self popAndPushPickerView];
                if (self.requestTwoDataBlock) {
                    self.requestTwoDataBlock(nil, text);
                }
            };
        }else{
            topTextView.submitBlock=^(NSString *text){
                [self popAndPushPickerView];
                if(self.requestDataBlock){
                    self.requestDataBlock(text);
                }
            };
            topTextView.closeBlock=^(){
                [self popAndPushPickerView];
            };
        }

        [self.grayBgView addSubview:topTextView];
        
    }
    return self;
}



+(instancetype)showWithController:(UIViewController *)controller{
    LHEditTextView *editTextView=[[self alloc]initWithController:controller isAdd:NO];
    editTextView.controller=controller;
    [controller.view addSubview:editTextView];
    [editTextView popAndPushPickerView];
    return  editTextView;
}

+(void)showWithController:(UIViewController *)controller isAddandRequestDataBlock:(void(^)(NSString *,NSString*))requestDataBlock{
    LHEditTextView *editTextView=[[self alloc]initWithController:controller isAdd:YES];
    editTextView.controller=controller;
    [controller.view addSubview:editTextView];
    [editTextView popAndPushPickerView];
    editTextView.requestTwoDataBlock = requestDataBlock;
}

+(void)showWithController:(UIViewController *)controller andRequestDataBlock:(void(^)(NSString *text))requestDataBlock{
    LHEditTextView *edit=[LHEditTextView showWithController:controller];
    edit.requestDataBlock=requestDataBlock;
}

-(void)popAndPushPickerView{
    if(self.grayBgView.hidden){
        [UIView animateWithDuration:0.5 animations:^{
            self.grayBgView.hidden=NO;
            self.topTextView.hidden=NO;
        }];
        [self.grayBgView setUserInteractionEnabled:YES];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.topTextView.hidden=YES;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.grayBgView.hidden=YES;
            }];
        }];
        
    }
    
}


-(void)dealloc{
    NSLog(@"edit被销毁");
}


@end
