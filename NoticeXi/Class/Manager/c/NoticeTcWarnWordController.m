//
//  NoticeTcWarnWordController.m
//  NoticeXi
//
//  Created by li lei on 2019/11/15.
//  Copyright © 2019 zhaoxiaoer. All rights reserved.
//

#import "NoticeTcWarnWordController.h"
#import "AFHTTPSessionManager.h"
#import "NoticeManagerModel.h"
#import "KMTagListView.h"
@interface NoticeTcWarnWordController ()<UITextFieldDelegate,KMTagListViewDelegate>
@property (nonatomic, strong) UITextField *warnField;
@property (nonatomic, strong) NSString *oldStr;
@property (nonatomic, strong) NSMutableArray *wordArr;
@property (nonatomic, strong) UILabel *warnL;
@property (nonatomic, strong) KMTagListView *labeView;
@end

@implementation NoticeTcWarnWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = GetColorWithName(VBackColor);
    
    self.wordArr = [NSMutableArray new];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, DR_SCREEN_WIDTH-15-55, 33)];
    backView.backgroundColor = GetColorWithName(VlistColor);
    backView.layer.cornerRadius = 33/2;
    backView.layer.masksToBounds = YES;
    [self.view addSubview:backView];
    
    self.warnField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0,backView.frame.size.width-30, 33)];
    self.warnField.placeholder = @"敏感词用中文逗号隔开(首个字不能为符号)";
    self.warnField.tintColor = [UIColor colorWithHexString:WHITEMAINCOLOR];
    self.warnField.font = FOURTHTEENTEXTFONTSIZE;
    self.warnField.textColor = GetColorWithName(VMainTextColor);
    self.warnField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.warnField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"敏感词用中文逗号隔开(首个字不能为符号)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:GetColorWithName(VDarkTextColor)}];
    [self.warnField setupToolbarToDismissRightButton];
    self.warnField.delegate = self;
    [backView addSubview:self.warnField];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backView.frame), 15, 55, 33)];
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:GetColorWithName(VMainTextColor) forState:UIControlStateNormal];
    addBtn.titleLabel.font = FOURTHTEENTEXTFONTSIZE;
    [addBtn addTarget:self action:@selector(addWordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    self.warnL = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backView.frame)+20, DR_SCREEN_WIDTH-15, 13)];
    self.warnL.text = @"敏感词汇";
    self.warnL.font = THRETEENTEXTFONTSIZE;
    self.warnL.textColor = GetColorWithName(VDarkTextColor);
    [self.view addSubview:self.warnL];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DR_SCREEN_WIDTH, 1)];
    line.backgroundColor = GetColorWithName(VlineColor);
    [self.view addSubview:line];
    
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[string stringByAppendingFormat:@"/line-sensitive.txt"]];
    NSData *data = [fileHandle readDataToEndOfFile];
    [fileHandle closeFile];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DRLog(@"已经存在的敏感词库:%@",text);
    self.oldStr = text;
    [self refreshList];

    [self getWarnCikKu];
    
}

- (void)refreshList{
    if (self.oldStr) {
        if (!self.oldStr.length || !self.oldStr) {
            return;
        }
        if ([[self.oldStr substringFromIndex:self.oldStr.length-1] isEqualToString:@","]) {
            self.oldStr = [self.oldStr substringToIndex:self.oldStr.length-1];
        }
        NSArray *arr = [self.oldStr componentsSeparatedByString:@","];
        self.wordArr = [NSMutableArray arrayWithArray:arr];
        [self.labeView removeFromSuperview];
        KMTagListView *tagV = [[KMTagListView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.warnL.frame)+10, self.view.frame.size.width, 0)];
        self.labeView = tagV;

        [tagV setupCustomeSubViewsWithTitles:arr];
        CGRect rect = tagV.frame;
        rect.size.height = tagV.contentSize.height;
        tagV.frame = rect;
        tagV.delegate_ = self;
        [self.view addSubview:tagV];
    }
}
#pragma mark - KMTagListViewDelegate
-(void)ptl_TagListView:(KMTagListView *)tagListView didSelectTagViewAtIndex:(NSInteger)index selectContent:(NSString *)content {
   
    __weak typeof(self) weakSelf = self;
    XLAlertView *alerView = [[XLAlertView alloc] initWithTitle:@"确定删除该敏感词汇?" message:nil sureBtn:[NoticeTools getLocalStrWith:@"sure.comgir"] cancleBtn:[NoticeTools getLocalStrWith:@"main.cancel"]];
    alerView.resultIndex = ^(NSInteger index) {
        if (index == 1) {
            if ([content isEqualToString:@""]) {
                 //写入文件打包词库为TXT文件
                 NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
                 NSString * fileName = [docDir stringByAppendingPathComponent:@"/line-sensitive.txt"];
                
                 NSString *str = weakSelf.oldStr;
                 str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];//去除空格
                 str = [str isEqualToString:@","]?@"":str;
                 if ([[str substringToIndex:1] isEqualToString:@","]) {
                     str = [str substringFromIndex:1];
                 }
                 
                 if ([[str substringToIndex:1] isEqualToString:@","]) {
                     str = [str substringFromIndex:1];
                 }
                 if ([[str substringWithRange:NSMakeRange(str.length-1, 1)] isEqualToString:@","]) {
                       str = [str substringToIndex:str.length-1];
                   }
                 
                 [str writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
                  
                 //获取打包好的TXT文件进行上传
                 NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                 NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[string stringByAppendingFormat:@"/line-sensitive.txt"]];
                 NSData *data = [fileHandle readDataToEndOfFile];
                 [fileHandle closeFile];
                 NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 DRLog(@"新的词库:%@",text);
                 
                 NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
                 [parm setObject:@"21" forKey:@"resourceType"];
                 [parm setObject:@"line-sensitive.txt" forKey:@"resourceContent"];
                 [weakSelf showHUDWithText:@"更新敏感词库..."];
                 [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/line-sensitive.txt"] error:nil];
                 [[XGUploadDateManager sharedManager] uploadTxtWithTxtData:data parm:parm progressHandler:^(CGFloat progress) {
                     
                 } complectionHandler:^(NSError *error, NSString *Message, NSString *bucketId, BOOL sussess) {
                     [weakSelf hideHUD];
                     if (sussess) {
                         weakSelf.oldStr = text;
                         [weakSelf refreshList];
                         [weakSelf showToastWithText:@"更新成功"];
                     }
                 }];
                return ;
            }
            if (index == 0) {
                   weakSelf.oldStr = [weakSelf.oldStr stringByReplacingOccurrencesOfString:content withString:@""];
                   if (weakSelf.oldStr.length > 1) {
                     weakSelf.oldStr = [weakSelf.oldStr substringFromIndex:1];
                   }else{
                       weakSelf.oldStr = @"";
                   }
               }else if (index == weakSelf.wordArr.count - 1){
                   weakSelf.oldStr = [weakSelf.oldStr stringByReplacingOccurrencesOfString:content withString:@""];
                    if (weakSelf.oldStr.length > 1) {
                      weakSelf.oldStr = [weakSelf.oldStr substringToIndex:weakSelf.oldStr.length-1];
                    }else{
                        weakSelf.oldStr = @"";
                    }
               }else{
                   weakSelf.oldStr = [weakSelf.oldStr stringByReplacingOccurrencesOfString:content withString:@""];
                   weakSelf.oldStr = [weakSelf.oldStr stringByReplacingOccurrencesOfString:@",," withString:@","];
               }
                 //写入文件打包词库为TXT文件
               NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
               NSString * fileName = [docDir stringByAppendingPathComponent:@"/line-sensitive.txt"];
               
               NSString *str = weakSelf.oldStr.length? weakSelf.oldStr : @"";
               str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];//去除空格
               [str writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
               
               //获取打包好的TXT文件进行上传
               NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
               NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[string stringByAppendingFormat:@"/line-sensitive.txt"]];
               NSData *data = [fileHandle readDataToEndOfFile];
               [fileHandle closeFile];
               NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
               DRLog(@"新的词库:%@",text);
               
               
               NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
               [parm setObject:@"21" forKey:@"resourceType"];
               [parm setObject:@"line-sensitive.txt" forKey:@"resourceContent"];
               [weakSelf showHUDWithText:@"更新敏感词库..."];
               [[XGUploadDateManager sharedManager] uploadTxtWithTxtData:data parm:parm progressHandler:^(CGFloat progress) {
                   
               } complectionHandler:^(NSError *error, NSString *Message, NSString *bucketId, BOOL sussess) {
                   [weakSelf hideHUD];
                   if (sussess) {
                       weakSelf.oldStr = text;
                       [weakSelf refreshList];
                       [weakSelf showToastWithText:@"更新成功"];
                   }
               }];
        }
    };
    [alerView showXLAlertView];
}


- (void)getWarnCikKu{
    [self showHUDWithText:@"正在获取最新敏感词库..."];
    [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/line-sensitive.txt"] error:nil];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:@"admin/lines/sensitive" Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary * _Nullable dict, BOOL success) {
        if (success) {
            NoticeManagerModel *model = [NoticeManagerModel mj_objectWithKeyValues:dict[@"data"]];
            if (model.sensitive_url) {
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:model.sensitive_url]];
                //返回一个下载任务对象
                NSURLSessionDownloadTask *loadTask = [manager downloadTaskWithRequest:requset progress:^(NSProgress * _Nonnull downloadProgress) {

                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSString *fullPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/line-sensitive.txt"];

                    //这个block 需要返回一个目标 地址 存储下载的文件
                    return  [NSURL fileURLWithPath:fullPath];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    DRLog(@"下载完成地址:%@",filePath);
                    //获取打包好的TXT文件进行上传
                    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[string stringByAppendingFormat:@"/line-sensitive.txt"]];
                    NSData *data = [fileHandle readDataToEndOfFile];
                    [fileHandle closeFile];
                    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    self.oldStr = [text stringByReplacingOccurrencesOfString:@",," withString:@","];
                    [self refreshList];
                    DRLog(@"新的网上词库词库:%@",text);
                    [self hideHUD];
                }];

                //启动下载任务--开始下载
                [loadTask resume];
            }else{
                [self hideHUD];
                [self showToastWithText:@"未有返回敏感词库链接"];
            }

        }
    } fail:^(NSError * _Nullable error) {
        [self hideHUD];
    }];
}

- (void)addWordClick{
    if (!self.warnField.text.length) {
        return;
    }
    //写入文件打包词库为TXT文件
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:@"/line-sensitive.txt"];
   
    NSString *str = self.oldStr.length? [NSString stringWithFormat:@"%@,%@",self.oldStr,[self.warnField.text stringByReplacingOccurrencesOfString:@"，" withString:@","]] : [self.warnField.text stringByReplacingOccurrencesOfString:@"，" withString:@","];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];//去除空格
    str = [str isEqualToString:@","]?@"":str;
    if ([[str substringToIndex:1] isEqualToString:@","]) {
        str = [str substringFromIndex:1];
    }
    
    if ([[str substringToIndex:1] isEqualToString:@","]) {
        str = [str substringFromIndex:1];
    }
    if ([[str substringWithRange:NSMakeRange(str.length-1, 1)] isEqualToString:@","]) {
          str = [str substringToIndex:str.length-1];
      }
    
    [str writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
     
    //获取打包好的TXT文件进行上传
    NSString *string = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:[string stringByAppendingFormat:@"/line-sensitive.txt"]];
    NSData *data = [fileHandle readDataToEndOfFile];
    [fileHandle closeFile];
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DRLog(@"新的词库:%@",text);
    
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc] init];
    [parm setObject:@"21" forKey:@"resourceType"];
    [parm setObject:@"line-sensitive.txt" forKey:@"resourceContent"];
    [self showHUDWithText:@"更新敏感词库..."];
    [[NSFileManager defaultManager] removeItemAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingString:@"/line-sensitive.txt"] error:nil];
    [[XGUploadDateManager sharedManager] uploadTxtWithTxtData:data parm:parm progressHandler:^(CGFloat progress) {
        
    } complectionHandler:^(NSError *error, NSString *Message, NSString *bucketId, BOOL sussess) {
        [self hideHUD];
        if (sussess) {
            self.oldStr = text;
            [self refreshList];
            [self showToastWithText:@"更新成功"];
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
