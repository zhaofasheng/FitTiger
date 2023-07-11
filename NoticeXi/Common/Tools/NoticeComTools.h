//
//  NoticeComTools.h
//  NoticeXi
//
//  Created by li lei on 2019/5/27.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeColockSetModel.h"
#import "NoticeClockChaceModel.h"
#import "NoticeAssestPointModel.h"
#import "NoticeVoiceListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NoticeComTools : NSObject
//获取心情列表高度
+ (CGFloat)voiceSelfCellHeight:(NoticeVoiceListModel *)model;
+ (CGFloat)voiceCellHeight:(NoticeVoiceListModel *)model needFavie:(BOOL)needfavie;
+ (CGFloat)voiceCellHeight:(NoticeVoiceListModel *)model;
+ (CGFloat)voiceAllCellHeight:(NoticeVoiceListModel *)model needFavie:(BOOL)needfavie;
+ (BOOL)canContinueFind;//判断是否可以继续找寻关键字的人
+ (void)saveCurrentFindTime;//保存当前找寻成功的时间点
+ (void)saveNoTost:(NSString *)tost;//保存当前找寻成功的时间点
+ (BOOL)noTost;
+ (void)saveHasTostPlayerMIni;//保存已经弹出了播放迷你时光机提示
+ (BOOL)noTostPlayerMini;//获取是否已经弹出过播放迷你时光机提示
+ (void)saveHasTostPlayerdubai;//是否弹出过播放独白提示
+ (BOOL)noTostPlayerdubai;
+ (NSString *)canDraw:(NSString *)time;//判断是否超过24小时
+ (void)saveSetCacha:(NSString *)strangView;//隐私设置缓存，用来判断用户是否开启了陌生人不可见心情
+ (BOOL)isOpenVoice;
+ (NSString *)isOpenVoiceString;
+ (void)saveFindKeyWord:(NSString *)key;//保存当前找寻成功的时间点
+ (NSString *)getKeyWord;
//时光机数据缓存
+ (void)saveTimeListVoice:(NSMutableArray *)dataArrary;
+ (NSMutableArray *)getTimeListVoiceArrary;
+ (void)hasCacheTimeList;
+ (BOOL)hasKnowgul;//私聊规则
+ (void)saveHasKnow;//私聊规则

+ (void)saveHasKnowSendText;//保存已经知道了长按打字功能
+ (BOOL)ifKnowSendText;//获取是否已经知道打字功能

+ (void)saveHasClickHs;//保存已经知道了悄悄话规则
+ (BOOL)ifKnowHsRul;//获取是否已经知道悄悄话规则

+ (void)saveHasKnowMainuse;//保存已经知道了首页使用规则
+ (BOOL)ifKnowMainuse;//获取是否已经知道首页使用规则

//判断是否是注册后进入的首页
+ (BOOL)isFromRegister;
+ (void)saveFromeFromeRegister:(NSString *)obj;

+ (void)saveDefaultZjArr:(NSMutableArray *)arr withType:(NSInteger)type;//0所有专辑  1室友可见专辑  2私密专辑
+ (NSMutableArray *)getDefaultZjArrWithType:(NSInteger)type;
+ (NSMutableArray *)getZjArr;
+ (void)saveZJarr:(NSMutableArray *)arr;

//获取中午汉字个数
+ (int)getChianNum:(NSString*)strtemp;
//获取英文字母个数
+ (int)getEnglishNum:(NSString *)strtemp;

+ (void)saveClockModel:(NoticeColockSetModel *)model;
+ (NoticeColockSetModel *)getCloclSetModel;
+ (void)saveAssestPointModel:(NoticeAssestPointModel *)model;
+ (NoticeAssestPointModel *)getAssestPointModel;
+ (void)sendNotificationWithBody:(NSString *)str;
+ (void)setCloclWithModel:(NoticeColockSetModel *)setModel;

+ (NSMutableArray *)getColockChaceModel;
+ (void)saveColockChace:(NoticeClockChaceModel *)caceModel;
+ (void)cancelCaceClockModel:(NSString *)cancelId;

+ (NSMutableArray *)getColockVoiceChaceModel;
+ (void)saveColockVoiceChace:(NSMutableArray *)caceArr;
+ (void)cancelCaceClockVoiceModel:(NSString *)cancelId;

+(NSString *)deleteCharacters:(NSString *)targetString;

+ (void)connectXiaoer;

+ (BOOL)needTostAchmentForVoice;
+ (void)noNeedTostAchMentForVoice:(NSString *)need;

+ (BOOL)needTostAchmentForSgj;

+ (void)noNeedTostAchMentForSgj:(NSString *)need;

+ (NSInteger)tostAchmentLeavel;
+ (void)saveTostAchmentLeavel:(NSString *)leave;
+ (void)saveAlphaValue:(NSString *)alpha;
+ (void)saveEffectValue:(NSString *)effect;
+ (NSString *)getAlphaValue;
+ (NSString *)getEffect;
+ (void)saveHasLookBanner:(NSString *)banner;

+ (BOOL)hasLookBanner:(NSString *)banner;

+ (void)setLookMp4:(NSString *)mp4Id;
+ (BOOL)getHasLookMp4:(NSString *)mp4Id;

+ (void)setbgmMp4:(NSString *)mp4Id;

+ (BOOL)getHasbmgMp4:(NSString *)mp4Id;

+ (BOOL)pareseError:(NSError *)error;

+ (void)saveHasShowLeader;
+ (NSString *)getShowLeader;

+ (void)saveInput:(NSString *)content saveKey:(NSString *)saveKey;
+ (NSString *)getInputWithKey:(NSString *)saveKey;
+ (void)removeWithKey:(NSString *)saveKey;
@end

NS_ASSUME_NONNULL_END








































