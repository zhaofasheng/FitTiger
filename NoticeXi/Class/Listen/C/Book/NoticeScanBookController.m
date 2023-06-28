//
//  NoticeScanBookController.m
//  NoticeXi
//
//  Created by li lei on 2020/6/30.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeScanBookController.h"
#import <AVFoundation/AVFoundation.h>
#define KMainW [UIScreen mainScreen].bounds.size.width
#define KMainH [UIScreen mainScreen].bounds.size.height
@interface NoticeScanBookController ()<AVCaptureMetadataOutputObjectsDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;
@property (nonatomic, weak) UIImageView *line;
@property (nonatomic, assign) NSInteger distance;
@end

@implementation NoticeScanBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    self.navigationItem.title = @"扫描图书条码";
    
    
    //创建控件
    [self creatControl];
    
    //设置参数
    [self setupCamera];
    
    //添加定时器
    [self addTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopScanning];
}
 

- (void)creatControl
{
    CGFloat scanW = KMainW * 0.65;
    CGFloat padding = 10.0f;
    CGFloat labelH = 20.0f;
    CGFloat cornerW = 26.0f;
    CGFloat marginX = (KMainW - scanW) * 0.5;
    CGFloat marginY = 150;
    
    //遮盖视图
    for (int i = 0; i < 4; i++) {
        UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, (marginY + scanW) * i, KMainW, marginY + (padding + labelH) * i)];
        if (i == 2 || i == 3) {
            cover.frame = CGRectMake((marginX + scanW) * (i - 2), marginY, marginX, scanW);
        }
        if (i == 1) {
            cover.frame = CGRectMake(0, (marginY + scanW) * i, KMainW, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-scanW-marginY);
        }
        cover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        [self.view addSubview:cover];
    }
    
    //扫描视图
    UIView *scanView = [[UIView alloc] initWithFrame:CGRectMake(marginX,150, scanW, scanW)];
    [self.view addSubview:scanView];
    
    //扫描线
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scanW, 2)];
    [self drawLineForImageView:line];
    [scanView addSubview:line];
    self.line = line;
    
    //边框
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scanW, scanW)];
    borderView.layer.borderColor = [[UIColor whiteColor] CGColor];
    borderView.layer.borderWidth = 1.0f;
    [scanView addSubview:borderView];
    
    //扫描视图四个角
    for (int i = 0; i < 4; i++) {
        CGFloat imgViewX = (scanW - cornerW) * (i % 2);
        CGFloat imgViewY = (scanW - cornerW) * (i / 2);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgViewX, imgViewY, cornerW, cornerW)];
        if (i == 0 || i == 1) {
            imgView.transform = CGAffineTransformRotate(imgView.transform, M_PI_2 * i);
        }else {
            imgView.transform = CGAffineTransformRotate(imgView.transform, - M_PI_2 * (i - 1));
        }
        [self drawImageForImageView:imgView];
        [scanView addSubview:imgView];
    }
    
    //提示标签
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((DR_SCREEN_WIDTH-150)/2, CGRectGetMaxY(scanView.frame) + 46, 150, labelH)];
    label.text = @"扫ISBN码添加书籍";
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [[NoticeTools getWhiteColor:@"#FFFFFF" NightColor:@"#B2B2B2"] colorWithAlphaComponent:0.5];
    label.layer.cornerRadius = 10;
    label.layer.masksToBounds = YES;
    label.backgroundColor = [[NoticeTools getWhiteColor:@"#333333" NightColor:@"#181828"] colorWithAlphaComponent:0.5];
    [self.view addSubview:label];
    
    //开启照明按钮
    UIButton *lightBtn = [[UIButton alloc] initWithFrame:CGRectMake(KMainW - 100, DR_SCREEN_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT, 100,TAB_BAR_HEIGHT)];
    lightBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [lightBtn setTitle:@"开启照明" forState:UIControlStateNormal];
    [lightBtn setTitle:@"关闭照明" forState:UIControlStateSelected];
    [lightBtn addTarget:self action:@selector(lightBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightBtn];
    

}

- (void)photoClick{
//    [self stopScanning];
//    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//    imagePicker.sortAscendingByModificationDate = false;
//    imagePicker.allowPickingOriginalPhoto = false;
//    imagePicker.alwaysEnableDoneBtn = true;
//    imagePicker.allowPickingVideo = false;
//    imagePicker.allowPickingGif = NO;
//    imagePicker.allowPickingMultipleVideo = true;
//    imagePicker.showPhotoCannotSelectLayer = YES;
//    [self presentViewController:imagePicker animated:YES completion:nil];
}


//照明按钮点击事件
- (void)lightBtnOnClick:(UIButton *)btn
{
    //判断是否有闪光灯
    if (![_device hasTorch]) {
        [self showToastWithText:@"当前设备没有闪光灯，无法开启照明功能"];
        return;
    }
    
    btn.selected = !btn.selected;
    
    [_device lockForConfiguration:nil];
    if (btn.selected) {
        [_device setTorchMode:AVCaptureTorchModeOn];
    }else {
        [_device setTorchMode:AVCaptureTorchModeOff];
    }
    [_device unlockForConfiguration];
}

- (void)setupCamera
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //初始化相机设备
        self->_device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
 
        //初始化输入流
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self->_device error:nil];
        
        //初始化输出流
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        //设置代理，主线程刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        self->_session = [[AVCaptureSession alloc] init];
        //高质量采集率
        [self->_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        if ([self->_session canAddInput:input]) [self->_session addInput:input];
        if ([self->_session canAddOutput:output]) [self->_session addOutput:output];
        
        //条码类型（二维码/条形码）
        output.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil];
        
        //更新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_preview = [AVCaptureVideoPreviewLayer layerWithSession:self->_session];
            self->_preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
            self->_preview.frame = CGRectMake(0, 0, KMainW, KMainH);
            [self.view.layer insertSublayer:self->_preview atIndex:0];
            [self->_session startRunning];
        });
    });
}
 
- (void)addTimer
{
    _distance = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
 
- (void)timerAction
{
    if (_distance++ > KMainW * 0.65) _distance = 0;
    _line.frame = CGRectMake(0, _distance, KMainW * 0.65, 2);
}
 
- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}
 
 
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //扫描完成
    if ([metadataObjects count] > 0) {
        //停止扫描
        [self stopScanning];
        
        NSString *appcode = @"457aa641da364b94a915d237fa8fb357";
        NSString *host = @"https://isbn.market.alicloudapi.com";
        NSString *path = @"/ISBN";
        NSString *method = @"GET";
        NSString *querys = [NSString stringWithFormat:@"?is_info=0&isbn=%@",[[metadataObjects firstObject] stringValue]];
        NSString *url = [NSString stringWithFormat:@"%@%@%@",  host,  path , querys];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: url]  cachePolicy:1  timeoutInterval:  5];
        request.HTTPMethod  =  method;
        [request addValue:  [NSString  stringWithFormat:@"APPCODE %@" ,  appcode]  forHTTPHeaderField:  @"Authorization"];
        NSURLSession *requestSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionDataTask *task = [requestSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableContainers error:nil];
            DRLog(@"%@/n%@",url,dict);
            
            
            NoticeSacnModel *model = [NoticeSacnModel mj_objectWithKeyValues:dict];
            if (model.error_code.intValue == 0 && model.resultModel) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.addBookBlock) {
                        self.addBookBlock(model.resultModel);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
                
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setupCamera];
                    [self showToastWithText:[NSString stringWithFormat:@"%@",model.reason?model.reason:@"识别失败"]];
                });
                
            }
            //打印应答中的body
            DRLog(@"%@",dict);
            
        }];
        
        [task resume];
    }
}
 
- (void)stopScanning
{
    [_session stopRunning];
    _session = nil;
    [_preview removeFromSuperlayer];
    [self removeTimer];
}
 
//绘制角图片
- (void)drawImageForImageView:(UIImageView *)imageView
{
    UIGraphicsBeginImageContext(imageView.bounds.size);
 
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条宽度
    CGContextSetLineWidth(context, 6.0f);
    //设置颜色
    CGContextSetStrokeColorWithColor(context, [GetColorWithName(VMainThumeColor) CGColor]);
    //路径
    CGContextBeginPath(context);
    //设置起点坐标
    CGContextMoveToPoint(context, 0, imageView.bounds.size.height);
    //设置下一个点坐标
    CGContextAddLineToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, imageView.bounds.size.width, 0);
    //渲染，连接起点和下一个坐标点
    CGContextStrokePath(context);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
 
//绘制线图片
- (void)drawLineForImageView:(UIImageView *)imageView
{
    CGSize size = imageView.bounds.size;
    UIGraphicsBeginImageContext(size);
 
    //获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //创建一个颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //设置开始颜色
    const CGFloat *startColorComponents = CGColorGetComponents([[UIColor colorWithHexString:@"#0099E6"] CGColor]);
    //设置结束颜色
    const CGFloat *endColorComponents = CGColorGetComponents([[UIColor colorWithHexString:@"#0099E6"] CGColor]);
    //颜色分量的强度值数组
    CGFloat components[8] = {startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]
    };
    //渐变系数数组
    CGFloat locations[] = {0.0, 1.0};
    //创建渐变对象
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    //绘制渐变
    CGContextDrawRadialGradient(context, gradient, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.25, CGPointMake(size.width * 0.5, size.height * 0.5), size.width * 0.5, kCGGradientDrawsBeforeStartLocation);
    //释放
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
    
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
