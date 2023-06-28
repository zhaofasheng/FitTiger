//
//  NoticeComTools.m
//  NoticeXi
//
//  Created by li lei on 2019/5/27.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeComTools.h"
#import "NoticeVoiceListModel.h"
#import "NoticeZjModel.h"
#import "UNNotificationsManager.h"
#import "ClockViewModel.h"
#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "NoticeTabbarController.h"
#import "NoticeSCViewController.h"
#import "AFNetworking.h"
#define STATICEHEIGHT 168
@implementation NoticeComTools

+ (BOOL)pareseError:(NSError *)error{
  
      // 网络状态改变的回调
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        return YES;
    }else{
        return NO;
    }

}

+ (CGFloat)voiceCellHeight:(NoticeVoiceListModel *)model needFavie:(BOOL)needfavie{
    CGFloat insterHeight = model.intersect_tags.count?40:0;
    if (!needfavie) {
        insterHeight = 0;
    }
    CGFloat textShowHeight = model.content_type.intValue == 2?(model.isMoreFiveLines?model.fiveBetTextHeight: model.textBetwonHeight):0;
    if (model.img_list.count) {
        if (model.img_list.count == 1) {
            return STATICEHEIGHT + DR_SCREEN_WIDTH*0.448+15+insterHeight+textShowHeight+ model.titleHeight;
        }else if (model.img_list.count == 2){
            return STATICEHEIGHT + DR_SCREEN_WIDTH*0.373+15+insterHeight+textShowHeight+ model.titleHeight;
        }else{
            return STATICEHEIGHT + (DR_SCREEN_WIDTH-46)/3+15+insterHeight+textShowHeight+ model.titleHeight;
        }
    }else if (model.resource){
        return STATICEHEIGHT + 83+15+10+insterHeight+textShowHeight;
    }
    return STATICEHEIGHT+insterHeight+textShowHeight + model.titleHeight;
}


+ (CGFloat)voiceCellHeight:(NoticeVoiceListModel *)model{
    CGFloat selfHeight = ((!model.resource && model.isSelf)?32:0)+model.topicHeight+ model.bgmHeight;
    if (model.content_type.integerValue != 2) {
        if (model.img_list.count) {
            if (model.img_list.count==1) {
                return 164+15+200+15 + selfHeight;
            }else if (model.img_list.count == 2){
                return 164+15+(DR_SCREEN_WIDTH-68)/2+15+ selfHeight;
            }else{
                return 164+15+(DR_SCREEN_WIDTH-60-18)/3+15+ selfHeight;
            }
        }
        if (model.resource) {
            return 164+15+78+15+ selfHeight;
        }
        
        return 164+15+ selfHeight;
    }else{
        if (model.resource) {
            return 164+15+78+15+(model.isMoreFiveLines?model.fiveTextHeight:model.textHeight)-54-40+15+ selfHeight ;
        }else{
            if (model.img_list.count) {
                if (model.img_list.count==1) {
                    return 55+54+10+(model.isMoreFiveLines?model.fiveTextHeight:model.textHeight)+200+25+ selfHeight;
                }else if (model.img_list.count == 2){
                    return 55+54+10+(model.isMoreFiveLines?model.fiveTextHeight:model.textHeight)+(DR_SCREEN_WIDTH-68)/2+25+ selfHeight;
                }else{
                    return 55+54+10+(model.isMoreFiveLines?model.fiveTextHeight:model.textHeight)+(DR_SCREEN_WIDTH-60-18)/3+25+ selfHeight;
                }
            }
            return 55+54+15+(model.isMoreFiveLines?model.fiveTextHeight:model.textHeight)+15+ selfHeight;
        }
    }
    return 0;
}

+ (CGFloat)voiceSelfCellHeight:(NoticeVoiceListModel *)model{
    CGFloat selfHeight = ((!model.resource && model.isSelf)?32:0)+model.topicHeight + model.bgmHeight;
    if (model.resource) {
        if (model.content_type.integerValue != 2) {
       
            return 160+15+78;
        }else{

            return 145+78+15+(model.isMoreFiveLines?model.fiveTextHeight:model.textHeight)-54-40+15+15;
        }
    }else{
        if (model.content_type.integerValue != 2) {
            if (model.img_list.count) {
                if (model.img_list.count==1) {
                    return 160+15+200+ selfHeight;
                }else if (model.img_list.count == 2){
                    return 160+15+(DR_SCREEN_WIDTH-68)/2+ selfHeight;
                }else{
                    return 160+15+(DR_SCREEN_WIDTH-60-18)/3+ selfHeight;
                }
            }

            return 160+ selfHeight;
        }else{
            CGFloat height;
            if (model.img_list.count) {
                if (model.img_list.count==1) {
                    height = 200;
                }else if (model.img_list.count == 2){
                     height = (DR_SCREEN_WIDTH-68)/2;
                }else{
                     height = (DR_SCREEN_WIDTH-60-18)/3;
                }
            }else{
                height = 0;
            }
            return 120+(model.isMoreFiveLines?model.fiveTextHeight:model.textHeight)+height+15+ selfHeight;
        }
    }


}

+ (CGFloat)voiceAllCellHeight:(NoticeVoiceListModel *)model needFavie:(BOOL)needfavie{
    CGFloat insterHeight = model.intersect_tags.count?40:0;
    if (!needfavie) {
        insterHeight = 0;
    }
    CGFloat textShowHeight = model.content_type.intValue == 2?model.textBetwonHeight:0;
    if (model.img_list.count) {
          if (model.img_list.count == 1) {
              return STATICEHEIGHT + DR_SCREEN_WIDTH*0.448+15+insterHeight+textShowHeight+ model.titleHeight;
        }else if (model.img_list.count == 2){
            return STATICEHEIGHT + DR_SCREEN_WIDTH*0.373+15+insterHeight+textShowHeight+ model.titleHeight;
        }else{
            return STATICEHEIGHT + (DR_SCREEN_WIDTH-46)/3+15+insterHeight+textShowHeight+ model.titleHeight;
        }
    }else if (model.resource){
        return STATICEHEIGHT + 83+15+10+insterHeight+textShowHeight;
    }
    return STATICEHEIGHT + insterHeight + textShowHeight + model.titleHeight;
}

+ (void)saveAssestPointModel:(NoticeAssestPointModel *)model{
    model.hasSave = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[model mj_keyValues] forKey:[NSString stringWithFormat:@"%@assestPoint",[[NoticeSaveModel getUserInfo]user_id]]];
    [userDefaults synchronize];
}

+ (NoticeAssestPointModel *)getAssestPointModel{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic  = [userDefaults objectForKey:[NSString stringWithFormat:@"%@assestPoint",[[NoticeSaveModel getUserInfo]user_id]]];
    return [NoticeAssestPointModel mj_objectWithKeyValues:userInfoDic];
}


+ (int)getChianNum:(NSString*)strtemp {
    int chinaNum = 0;
    for (int i=0; i<strtemp.length; i++) {
        NSRange range=NSMakeRange(i,1);
        NSString *subString=[strtemp substringWithRange:range];
        if ([NoticeComTools isChineseFirst:subString])
        {
            chinaNum++;
        }
    }
    return chinaNum;
}

+ (int)getEnglishNum:(NSString *)strtemp{
    int englishNum = 0;
    for (int i=0; i<strtemp.length; i++) {
        NSRange range=NSMakeRange(i,1);
        NSString *subString=[strtemp substringWithRange:range];
        if([NoticeComTools MatchLetter:subString])
        {
            englishNum++;
        }
    }
    return englishNum;
}

+(BOOL)isChineseFirst:(NSString *)firstStr
{
    //是否以中文开头(unicode中文编码范围是0x4e00~0x9fa5)
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    //判断是不是中文开头的,buffer->获取字符的字节数据 maxLength->buffer的最大长度 usedLength->实际写入的长度，不需要的话可以传递NULL encoding->字符编码常数，不同编码方式转换后的字节长是不一样的，这里我用了UTF16 Little-Endian，maxLength为2字节，如果使用Unicode，则需要4字节 options->编码转换的选项，有两个值，分别是NSStringEncodingConversionAllowLossy和NSStringEncodingConversionExternalRepresentation range->获取的字符串中的字符范围,这里设置的第一个字符 remainingRange->建议获取的范围，可以传递NULL
    BOOL b = [firstStr getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5))
        return YES;
    else
        return NO;
}

+(BOOL)MatchLetter:(NSString *)str
{
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}
+ (void)saveZJarr:(NSMutableArray *)arr{
    NSMutableArray *dictArrary = [[NSMutableArray alloc] init];
    for (NoticeZjModel *model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArrary addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticezhuanjiArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    [dictArrary writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getZjArr{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticezhuanjiArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    for (NSDictionary *dic in models) {
        NoticeZjModel *topic = [NoticeZjModel mj_objectWithKeyValues:dic];
        [arrayDict addObject:topic];
    }
    return arrayDict;
}

+ (NSMutableArray *)getColockChaceModel{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeClockArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    for (NSDictionary *dic in models) {
        NoticeClockChaceModel *topic = [NoticeClockChaceModel mj_objectWithKeyValues:dic];
        [arrayDict addObject:topic];
    }
    return arrayDict;
}

+ (NSArray *)getColockChaceDict{//获取缓存的原始数据
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeClockArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    return models;
}

//缓存下载的音频信息
+ (void)saveColockChace:(NoticeClockChaceModel *)caceModel{
    NSMutableArray *dictArrary = [[NSMutableArray alloc] init];
    
    if ([[NoticeComTools getColockChaceDict] count]) {
        dictArrary = [NSMutableArray arrayWithArray:[NoticeComTools getColockChaceDict]];
    }
    [dictArrary addObject:caceModel.mj_keyValues];
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeClockArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    [dictArrary writeToFile:fileName atomically:YES];
}

+ (void)cancelCaceClockModel:(NSString *)cancelId{
    NSMutableArray *arr = [NoticeComTools getColockChaceModel];
    if (arr.count) {
        for (int i = 0; i < arr.count; i++) {
            NoticeClockChaceModel *model = arr[i];
            if ([model.pyIdAndUserId isEqualToString:cancelId]) {
                if (model.voicePlayerUrl.length && [model.voicePlayerUrl isKindOfClass:[NSString class]]) {
                    if ([[NSFileManager defaultManager ] fileExistsAtPath :model.voicePlayerUrl]) {
                        [[NSFileManager defaultManager ] removeItemAtPath :model.voicePlayerUrl error :nil];
                    }
                }
                [arr removeObjectAtIndex:i];
                break;
            }
        }
    }
    NSMutableArray *dictArrary = [[NSMutableArray alloc] init];
    for (NoticeClockChaceModel *model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArrary addObject:dic];
    }
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeClockArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    [dictArrary writeToFile:fileName atomically:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postHasDianZanInPageCheace" object:nil];
    
    if ([[NoticeComTools getColockVoiceChaceModel] count]) {//同时如果存在缓存选中的音频，也要删除
        [NoticeComTools cancelCaceClockVoiceModel:cancelId];
    }
}

//获取选中的音频
+ (NSMutableArray *)getColockVoiceChaceModel{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeClockVoiceArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    for (NSDictionary *dic in models) {
        NoticeClockChaceModel *topic = [NoticeClockChaceModel mj_objectWithKeyValues:dic];
        [arrayDict addObject:topic];
    }
    return arrayDict;
}

+ (NSArray *)getColockVoiceChaceDict{//获取缓存的原始数据
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeClockVoiceArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    return models;
}

//缓存选择的音频
+ (void)saveColockVoiceChace:(NSMutableArray *)caceArr{
    NSMutableArray *dictArrary = [[NSMutableArray alloc] init];
    for (NoticeClockChaceModel *choiceM in caceArr) {
        [dictArrary addObject:choiceM.mj_keyValues];
    }
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeClockVoiceArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    [dictArrary writeToFile:fileName atomically:YES];
}

//删除选中的音频
+ (void)cancelCaceClockVoiceModel:(NSString *)cancelId{
    NSMutableArray *arr = [NoticeComTools getColockVoiceChaceModel];
    if (arr.count) {
        for (int i = 0; i < arr.count; i++) {
            NoticeClockChaceModel *model = arr[i];
            if ([model.pyIdAndUserId isEqualToString:cancelId]) {
                [arr removeObjectAtIndex:i];
                break;
            }
        }
    }
    NSMutableArray *dictArrary = [[NSMutableArray alloc] init];
    for (NoticeClockChaceModel *model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArrary addObject:dic];
    }
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeClockVoiceArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    [dictArrary writeToFile:fileName atomically:YES];
}

+ (void)saveDefaultZjArr:(NSMutableArray *)arr withType:(NSInteger)type{
    NSMutableArray *dictArrary = [[NSMutableArray alloc] init];
    for (NoticeZjModel *model in arr) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArrary addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticezhuanjiArrary%@WithType%ld",[[NoticeSaveModel getUserInfo]user_id],(long)type]];
    [dictArrary writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getDefaultZjArrWithType:(NSInteger)type{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticezhuanjiArrary%@WithType%ld",[[NoticeSaveModel getUserInfo]user_id],(long)type]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    for (NSDictionary *dic in models) {
        NoticeZjModel *topic = [NoticeZjModel mj_objectWithKeyValues:dic];
        [arrayDict addObject:topic];
    }
    if (arrayDict.count) {
       return arrayDict;
    }else{
        NSArray *titleArr = @[@[@"把心情",[NoticeTools isSimpleLau]?@"整理成一张张":@"整理成壹張張",[NoticeTools isSimpleLau]?[NoticeTools getLocalStrWith:@"zj.zfname"]:@"專輯"],@[[NoticeTools isSimpleLau]?@"每一张":@"每壹張",[NoticeTools isSimpleLau]?@"专辑都是你的故事":@"專輯都是妳的故事",@""],@[[NoticeTools isSimpleLau]?@"长按调整顺序":@"長按調整順序",@"",@""]];
        NSArray *imgArr = @[@[@"azj1_img",@"azj2_img",@"azj3_img"],@[@"hzj1_img",@"hzj2_img",@""],@[@"szj1_img",@"",@""]];
        for (int i = 0; i < 3; i++) {
            NoticeZjModel *model = [[NoticeZjModel alloc] init];
            model.defaultName = titleArr[type][i];
            model.defaultImage = imgArr[type][i];
            [arrayDict addObject:model];
        }
        return arrayDict;
    }
}


+ (void)saveTimeListVoice:(NSMutableArray *)dataArrary{
    NSMutableArray *dictArrary = [[NSMutableArray alloc] init];
    for (NoticeVoiceListModel *model in dataArrary) {
        NSDictionary *dic = model.mj_keyValues;
        [dictArrary addObject:dic];
    }
    
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeTimeArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    [dictArrary writeToFile:fileName atomically:YES];
}

+ (NSMutableArray *)getTimeListVoiceArrary{
    NSString * docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES) lastObject];
    NSString * fileName = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"NoticeTimeArrary%@",[[NoticeSaveModel getUserInfo]user_id]]];
    NSArray * models = [NSArray arrayWithContentsOfFile:fileName];
    NSMutableArray *arrayDict=[NSMutableArray array];
    for (NSDictionary *dic in models) {
        NoticeVoiceListModel *topic = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
        [arrayDict addObject:topic];
    }
    return arrayDict;
}

+ (void)hasCacheTimeList{
    
    if ([NoticeSaveModel getUserInfo] && ![[NoticeComTools getTimeListVoiceArrary] count]) {
        NSString *url = nil;
        NSString *userId = [[NoticeSaveModel getUserInfo] user_id];
        url = [NSString stringWithFormat:@"users/%@/voices?sort=asc&moduleId=1",userId];
        __block NSMutableArray *dataArr = [NSMutableArray new];
        [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
            if (success) {
                if ([dict[@"data"] isEqual:[NSNull null]]) {
                    return ;
                }
                
                for (NSDictionary *dic in dict[@"data"]) {
                    NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                    
                    BOOL alerady = NO;
                    for (NoticeVoiceListModel *olM in dataArr) {
                        if ([olM.voice_id isEqualToString:model.voice_id]) {
                            alerady = YES;
                            break;
                        }
                    }
                    if (!alerady) {
                        [dataArr addObject:model];
                    }
                }
                
                if (dataArr.count) {
                    NoticeVoiceListModel *lastM = dataArr[dataArr.count-1];
                    [NoticeComTools getMore:lastM.voice_id dataArr:dataArr];
                }else{
                    return;
                }
            }
        } fail:^(NSError *error) {
        
        }];
    }
}

+ (void)getMore:(NSString *)lastId dataArr:(NSMutableArray *)dataArr{
    NSString *url = nil;
    NSString *userId = [[NoticeSaveModel getUserInfo] user_id];
    url = [NSString stringWithFormat:@"users/%@/voices?lastId=%@&sort=asc&moduleId=1",userId,lastId];
    __block NSMutableArray *arr = [NSMutableArray new];
    [[DRNetWorking shareInstance] requestNoNeedLoginWithPath:url Accept:nil isPost:NO parmaer:nil page:0 success:^(NSDictionary *dict, BOOL success) {
        if (success) {
            if ([dict[@"data"] isEqual:[NSNull null]]) {
                return ;
            }
            
            for (NSDictionary *dic in dict[@"data"]) {
                NoticeVoiceListModel *model = [NoticeVoiceListModel mj_objectWithKeyValues:dic];
                
                BOOL alerady = NO;
                for (NoticeVoiceListModel *olM in dataArr) {
                    if ([olM.voice_id isEqualToString:model.voice_id]) {
                        alerady = YES;
                        break;
                    }
                }
                if (!alerady) {
                    [dataArr addObject:model];
                    [arr addObject:model];
                }
            }
            
            if (arr.count) {
                NoticeVoiceListModel *lastM = dataArr[dataArr.count-1];
                [NoticeComTools getMore:lastM.voice_id dataArr:dataArr];
            }else{
                [NoticeComTools saveTimeListVoice:dataArr];
                return;
            }
            
        }
    } fail:^(NSError *error) {
        
    }];
}

+ (void)saveNoTost:(NSString *)tost{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:tost forKey:@"notost"];
    [cache synchronize];
}

+ (BOOL)noTost{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
   return  [[cache objectForKey:@"notost"] integerValue];
}

+ (void)saveHasLookBanner:(NSString *)banner{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"banner%@",banner]];
    [cache synchronize];
}

+ (BOOL)hasLookBanner:(NSString *)banner{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    return  [[cache objectForKey:[NSString stringWithFormat:@"banner%@",banner]] integerValue];
}


+ (void)saveCurrentFindTime{
    if ([NoticeTools getBeiJingTimeWithFormort:@"yyyy-MM-dd"]) {
        NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
        
        [cache setObject:[NoticeTools getBeiJingTimeWithFormort:@"yyyy-MM-dd"] forKey:[NSString stringWithFormat:@"%@findKeyWordPeopleKey",[[NoticeSaveModel getUserInfo]user_id]]];
        [cache synchronize];
    }
}

+ (BOOL)canContinueFind{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@findKeyWordPeopleKey",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:[NoticeTools getBeiJingTimeWithFormort:@"yyyy-MM-dd"]]) {
        return  NO;
    }
    return YES;
}

+ (void)saveFromeFromeRegister:(NSString *)obj{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    
    [cache setObject:obj forKey:@"FromeRegister"];
    [cache synchronize];
}

+ (BOOL)isFromRegister{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
   return  [[cache objectForKey:@"FromeRegister"] integerValue];
}

+ (void)saveFindKeyWord:(NSString *)key{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    
    [cache setObject:key forKey:[NSString stringWithFormat:@"%@findKeyWordKey",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (NSString *)getKeyWord{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    return [cache objectForKey:[NSString stringWithFormat:@"%@findKeyWordKey",[[NoticeSaveModel getUserInfo]user_id]]];
}

+ (NSString *)canDraw:(NSString *)time{
    
    NSInteger  secondsCountDown = (time.integerValue + 86400) - [NoticeTools getNowTimeTimestamp].integerValue;
    if (secondsCountDown < 0) {
        return nil;
    }
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", (long)secondsCountDown / 3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (long)(secondsCountDown % 3600) / 60];
    if (str_minute.length == 2 && [[str_minute substringToIndex:1] isEqualToString:@"0"]) {
        str_minute = [str_minute substringFromIndex:1];
    }
    NSString *format_time = [NSString stringWithFormat:@"%@%@%@%@", str_hour,[NoticeTools getLocalStrWith:@"group.hour"], str_minute,[NoticeTools getLocalStrWith:@"group.min"]];
    return format_time;
}

+ (NSString *)getTime:(NSInteger)secondsCountDown{
    // 重新计算 时/分/秒
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", (long)secondsCountDown / 3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (long)(secondsCountDown % 3600) / 60];
    NSString *format_time = [NSString stringWithFormat:@"%@时%@分", str_hour, str_minute];

    return format_time;
}

+ (void)saveSetCacha:(NSString *)strangView{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:strangView forKey:[NSString stringWithFormat:@"%@strangView",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (BOOL)isOpenVoice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@strangView",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

+ (void)saveHasTostPlayerMIni{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"%@playerMini",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (BOOL)noTostPlayerMini{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
      if ([[cache objectForKey:[NSString stringWithFormat:@"%@playerMini",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"1"]) {
          return YES;
      }
      return NO;
}

+ (void)saveHasTostPlayerdubai{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"%@dubai",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (BOOL)noTostPlayerdubai{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@dubai",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)needTostAchmentForVoice{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@voiceAchment",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void)noNeedTostAchMentForVoice:(NSString *)need{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:need forKey:[NSString stringWithFormat:@"%@voiceAchment",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (void)saveHasKnowSendText{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"%@sendText",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (BOOL)ifKnowSendText{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@sendText",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void)saveHasClickHs{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"%@hsrul",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (BOOL)ifKnowHsRul{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@hsrul",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void)saveHasKnowMainuse{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"%@mainuse",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (BOOL)ifKnowMainuse{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@mainuse",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)needTostAchmentForSgj{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@sgjAchment",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void)noNeedTostAchMentForSgj:(NSString *)need{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:need forKey:[NSString stringWithFormat:@"%@sgjAchment",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (BOOL)hasKnowgul{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@chatknow",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void)saveHasKnow{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"%@chatknow",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (NSInteger)tostAchmentLeavel{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@leaveAchment",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"1"]) {
        return 1;
    }
    return 0;
}

+ (void)saveTostAchmentLeavel:(NSString *)leave{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:leave forKey:[NSString stringWithFormat:@"%@leaveAchment",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (NSString *)isOpenVoiceString{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@strangView",[[NoticeSaveModel getUserInfo]user_id]]] isEqualToString:@"0"]) {
        return @"0";
    }
    return @"7";
}

+ (void)setLookMp4:(NSString *)mp4Id{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"%@%@mp4Id",[NoticeTools getuserId],mp4Id]];
    [cache synchronize];
}

+ (BOOL)getHasLookMp4:(NSString *)mp4Id{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@%@mp4Id",[[NoticeSaveModel getUserInfo]user_id],mp4Id]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void)setbgmMp4:(NSString *)mp4Id{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"%@%@bgmmp4Id",[NoticeTools getuserId],mp4Id]];
    [cache synchronize];
}

+ (BOOL)getHasbmgMp4:(NSString *)mp4Id{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    if ([[cache objectForKey:[NSString stringWithFormat:@"%@%@bgmmp4Id",[[NoticeSaveModel getUserInfo]user_id],mp4Id]] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

+ (void)saveAlphaValue:(NSString *)alpha{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:alpha forKey:[NSString stringWithFormat:@"%@AlphaValue",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (NSString *)getAlphaValue{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    return [cache objectForKey:[NSString stringWithFormat:@"%@AlphaValue",[[NoticeSaveModel getUserInfo]user_id]]];
}

+ (void)saveEffectValue:(NSString *)effect{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    [cache setObject:effect forKey:[NSString stringWithFormat:@"%@effect",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}
+ (NSString *)getEffect{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    return [cache objectForKey:[NSString stringWithFormat:@"%@effect",[[NoticeSaveModel getUserInfo]user_id]]];
}

+ (void)saveClockModel:(NoticeColockSetModel *)model{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[model mj_keyValues] forKey:[NSString stringWithFormat:@"%@shengxiClockSetModel",[[NoticeSaveModel getUserInfo]user_id]]];
    [userDefaults synchronize];
}

+ (NoticeColockSetModel *)getCloclSetModel{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSDictionary *userInfoDic  = [userDefaults objectForKey:[NSString stringWithFormat:@"%@shengxiClockSetModel",[[NoticeSaveModel getUserInfo]user_id]]];
     return [NoticeColockSetModel mj_objectWithKeyValues:userInfoDic];
}

+ (void)sendNotificationWithBody:(NSString *)str{
    //获取通知中心用来激活新建的通知
    UNUserNotificationCenter * center  = [UNUserNotificationCenter currentNotificationCenter];
    UNMutableNotificationContent * content = [[UNMutableNotificationContent alloc]init];
    content.body = str;
    UNTimeIntervalNotificationTrigger * tirgger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    //建立通知请求
    UNNotificationRequest * request = [UNNotificationRequest requestWithIdentifier:@"fsdjfkl" content:content trigger:tirgger];
    //将建立的通知请求添加到通知中心
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        DRLog(@"%@本地推送 :( 报错 %@",@"fsdhkj",error);
        
    }];
    
}

+(NSString *)deleteCharacters:(NSString *)targetString{
    
    if (targetString.length==0 || !targetString) {
        return nil;
    }
    
    NSError *error = nil;
    NSString *pattern = @"[^a-zA-Z0-9\u4e00-\u9fa5]";//正则取反
    NSRegularExpression *regularExpress = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];//这个正则可以去掉所有特殊字符和标点
    NSString *string = [regularExpress stringByReplacingMatchesInString:targetString options:0 range:NSMakeRange(0, [targetString length]) withTemplate:@""];
    
    return string;
}


+ (void)setCloclWithModel:(NoticeColockSetModel *)setModel{
    //开启，关闭闹钟
      NSDate *now = [NSDate date];
      NSDateFormatter *formatDay1 = [[NSDateFormatter alloc] init];
      //设置时区,这个对于时间的处理有时很重要
      NSTimeZone* timeZone = [NSTimeZone localTimeZone];
      [formatDay1 setTimeZone:timeZone];
      formatDay1.dateFormat = @"yyyy-MM-dd";
      NSString *dayStr = [formatDay1 stringFromDate:now];
      
      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      //设置时区,这个对于时间的处理有时很重要
      [formatter setTimeZone:timeZone];
      [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
      NSDate *deadline = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@:%@:00",dayStr,setModel.hour,setModel.min]];
      DRLog(@"%@",[NSString stringWithFormat:@"%@ %@:%@:00",dayStr,setModel.hour,setModel.min]);
      ClockModel *model = [[ClockModel alloc] init];
      model.date = deadline;
      model.music = @"hotM_01.caf";
      model.isOn = YES;
      model.isLater = YES;
      NSMutableArray *repeatsArr = [[NSMutableArray alloc] init];
      if (setModel.day1.integerValue) {
          [repeatsArr addObject:@"每周一"];
      }
      if (setModel.day2.integerValue) {
          [repeatsArr addObject:@"每周二"];
      }
      if (setModel.day3.integerValue) {
          [repeatsArr addObject:@"每周三"];
      }
      if (setModel.day4.integerValue) {
          [repeatsArr addObject:@"每周四"];
      }
      if (setModel.day5.integerValue) {
          [repeatsArr addObject:@"每周五"];
      }
      if (setModel.day6.integerValue) {
          [repeatsArr addObject:@"每周六"];
      }
      if (setModel.day7.integerValue) {
          [repeatsArr addObject:@"每周日"];
      }
      model.repeatStrs = repeatsArr;
      setModel.isOpen = @"1";
      [NoticeComTools saveClockModel:setModel];
      [model addUserNotification];
}

+ (void)connectXiaoer{
    NoticeSCViewController *ctl = [[NoticeSCViewController alloc] init];
    ctl.navigationItem.title = @"声昔小二";
    ctl.toUser = [NSString stringWithFormat:@"%@1",socketADD];
    ctl.toUserId = @"1";
    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NoticeTabbarController *tabBar = (NoticeTabbarController *)appdel.window.rootViewController;//获取window的跟视图,并进行强制转换
    if ([tabBar isKindOfClass:[UITabBarController class]]) {//判断是否是当前根视图
        BaseNavigationController *nav = tabBar.selectedViewController;//获取到当前视图的导航视图
        [nav.topViewController.navigationController pushViewController:ctl animated:YES];//获取当前跟视图push到的最高视图层,然后进行push到目的页面
    }
}

+ (void)saveHasShowLeader{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    
    [cache setObject:@"1" forKey:[NSString stringWithFormat:@"%@showLeader",[[NoticeSaveModel getUserInfo]user_id]]];
    [cache synchronize];
}

+ (NSString *)getShowLeader{
    NSUserDefaults * cache = [NSUserDefaults standardUserDefaults];
    return [cache objectForKey:[NSString stringWithFormat:@"%@showLeader",[[NoticeSaveModel getUserInfo]user_id]]];
}

@end
