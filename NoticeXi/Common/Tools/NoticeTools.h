//
//  NoticeTools.h
//  NoticeXi
//
//  Created by li lei on 2018/10/22.
//  Copyright © 2018年 zhaoxiaoer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoticeSaveName.h"
#import "NoticeTimeTools.h"
#import "NoticeChatSaveModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SuccessGetBlock)(NSString *payId, NSInteger type,NSString *name,NSString *iconUrl);// 授权成功block
typedef void (^SuccessGetAliBlock)(id);// 授权成功block

@interface NoticeTools : NSObject

+ (void)getWeChatsuccess:(SuccessGetBlock _Nullable)success;
+ (void)getAlisuccess:(SuccessGetAliBlock _Nullable)success;

+ (BOOL)isFirstinThisDeveiceMainClock;
+(NSString *)getNowTimeStamp;
+ (void)setMarkOfincenterMainClock;
//swift调用
+(UIColor *)colorWith:(NSString *)colorHex;

//是否是管理员,只要把对于公司内部用户id加入到这里面就是管理员
+ (BOOL)isManager;

+ (BOOL)isTextOnThisDeveice;
+ (void)setMarkForTextSend;

+ (NSArray*)getURLFromStr:(NSString *)string;
+(BOOL)isWhetherNoUrl:(NSString *)urlStr;
+ (BOOL)isFirstsameOnThisDeveice;
+ (void)setMarkForsameSend;
+ (NSString *)chinese:(NSString *)chinese english:(NSString *)english japan:(NSString *)japan;
+ (NSString *)getBeiJingTimeWithFormort:(NSString *)formort;
+ (BOOL)isFirstDrawOnThisDeveice;
+ (void)setMarkForDraw;
+ (BOOL)isFirstDrawOnThisDeveicetuya;
+ (void)setMarkForDrawtuya;
+(NSString *)convertToJsonData:(NSMutableArray *)arr;//数组转字符串
+(NSString *)convertDictToJsonData:(NSDictionary *)dict;//数组转字符串
+ (CGFloat)getHeightWithLineHight:(CGFloat)lineHeight font:(CGFloat)font width:(CGFloat)width string:(NSString *)string;
+ (NSMutableAttributedString *)getStringWithLineHight:(CGFloat)lineHeight string:(NSString *)string;

+ (NSString *)getTextWithSim:(NSString *)simText fantText:(NSString *)fantText;
+ (UIColor *)getWhiteColor:(NSString *)whiteColor NightColor:(NSString *)nightColor;
//上一次静音提醒的时间，24小时一次
+ (void)saveNewTime;
+ (NSString *)getLastTime;

/** 获取文件MD5值 */
+ (NSString*)getFileMD5WithPath:(NSString*)path;
+ (void)setSHAKE:(BOOL)need;
+ (BOOL)needShake;
/**
 是否启动引导页

 @return 是否
 */
+(NSString *)getNowTimeTimestamp;
+ (BOOL)CanShowLeader;
+ (void)saveVersion;
+(NSString *)getNowTime;
//如果图片url一样，图片不同，那要设置这个属性，特别注意
+ (void)setImageIfSameUrl;
+ (BOOL)isFirstLoginOnThisDeveicesub;
+ (void)setMarkOfLoginsub;

+ (BOOL)isFirstLoginOnThisDeveicesubHasPlay;
+ (void)setMarkOfLoginsubPlay;

//判断是否需要二次登录
+ (void)saveNeedSecondCheckForLogin:(NSString *)need;
+ (BOOL)needSecondCheckForLogin;

+ (BOOL)isFirstLoginOnThisDeveice;
+ (void)setMarkOfLogin;
+ (void)savePlayType:(NSString *)type;
+ (NSString *)getPlayType;
+ (NSString *)getIDFA;
+ (void)setneedConnect:(BOOL)need;
+ (BOOL)needConnect;
+ (BOOL)isFirstLoginOnThisDeveiceForSX;
+ (void)setMarkForClick;
+ (void)setMarkForSend;
+ (BOOL)isFirstSendOnThisDeveice;

+ (BOOL)hudongisOpen;
+ (void)setHUDONG:(NSString *)status;
+ (void)setMarkForSendMovie;
+ (BOOL)isFirstSendMovieOnThisDeveice;
+ (BOOL)isAutoPlayer;
+ (void)setAutoPlayer:(NSString *)autoStr;
+ (NSInteger)isFirstShowRoom;
+ (void)setFirstShowRoom:(NSString *)autoStr;
+ (NSString *)getuserId;
+ (BOOL)isFirstinThisDeveice;
+ (void)setMarkOfincenter;
+ (void)setVoiceOpenVoice;
+ (BOOL)isOpenVoice;
//是否是第一次开启闹钟
+ (BOOL)isFirstOpenClock;
+ (void)setMarkForOpenClock;

+ (BOOL)isFirstinThisDeveiceMain;
+ (void)setMarkOfincenterMain;

//是否是第一次发台词
+ (BOOL)isFirstTcOnThisDeveice;
+ (void)setMarkForTc;
/**
 切换语言
 */
+ (void)setLangue;
+ (void)changeToSimple;
+ (void)changeToTaiwan;
+ (BOOL)isSimpleLau;
+ (void)changeThemeWith:(NSString *)theme;
+ (BOOL)isWhiteTheme;
+ (NSString *)getThemeColorWithKey:(NSString *)key;
+ (BOOL)hasDefaultTheme;
+ (NSString *)getThemeImageNameWithKey:(NSString *)key;

+ (NSString *)getLocalStrWith:(NSString *)key;
+ (NSInteger)getLocalType;
//数组转json字符串
+ (NSString *)arrayToJSONString:(NSMutableArray *)array;

+ (NSArray *)arraryWithJsonString:(NSString *)jsonString;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (void)saveSessionWith:(NoticeSaveName *)usrM;
+ (NSString *)getUserNameWith:(NSString *)sessionId;
+ (void)removeNameWith:(NSString *)sessionId;
+ (void)savePushStatus:(NSString *)status;
+ (BOOL)getPushStatus;

+ (void)saveChatPushStatus:(NSString *)status;
//+ (BOOL)getChatPushStatus;

+ (void)saveTopicArr:(NSArray *)arrary;
+ (NSMutableArray *)getTopicArr;

+ (void)saveMoveArr:(NSArray *)arrary;
+ (NSMutableArray *)getMovieArr;

+ (void)saveBookArr:(NSArray *)arrary;
+ (NSMutableArray *)getBookArr;

+ (void)saveSongArr:(NSArray *)arrary;
+ (NSMutableArray *)getSongArr;

+ (void)saveNowDateWithYYYYmmDD;
+ (BOOL)isSameDate;

+ (NSInteger)Showpic;
+ (void)setFirstShowpic:(NSString *)autoStr;
+ (BOOL)Showpic1;

+ (void)setFirstShowpic1;

+ (BOOL)Showpic2;

+ (void)setFirstShowpic2;
/** 返回时间格式
 appointStr: 指定的时间格式
 */
+ (NSString *)timeDataAppointFormatterWithTime:(NSInteger)timeInterval appointStr:(NSString *)appointStr;
//核实日期是今天还是昨天
+ (NSString *)checkTheDate:(NSInteger)timeInterval;
//几分钟前，几小时前，日期
+ (NSString *)updateTimeForRow:(NSString *)createTimeString;
+ (NSString *)getDayFromNow:(NSString *)createTimeString;
+ (NSString *)getHourFormNow:(NSString *)createTimeString;
+ (NSString *)updateTimeForRowNear:(NSString *)str;
+ (NSString *)updateTimeForRowWorld:(NSString *)str;

+ (BOOL)isFirstShowmh;

+ (void)setFirstShowmh;

+ (void)saveGroupTitle:(NSString *)title assocId:(NSString *)assocId;
+ (NSString *)getGroupTitleWithAssocId:(NSString *)assocId;

+ (void)saveSysTime:(NSString *)time;
+ (NSString *)getSusTime;
+ (void)saveSysTitle:(NSString *)title;
+ (NSString *)getSysTitle;

+ (void)savefriendTime:(NSString *)time;
+ (NSString *)getfriendTime;
+ (void)saveSysfriend:(NSString *)title;
+ (NSString *)getSysfriend;

+ (void)saveotherTime:(NSString *)time;
+ (NSString *)getotherTime;
+ (void)saveotherTitle:(NSString *)title;
+ (NSString *)getotherTitle;

+ (void)saveassocTime:(NSString *)time;
+ (NSString *)getassocTime;
+ (void)saveassocTitle:(NSString *)title;
+ (NSString *)getassocTitle;
+ (NSString *)hasChinese:(NSString *)str;
+ (void)setVoiceOpen:(BOOL)open;
+ (BOOL)isOpen;
+ (void)saveYunxinId:(NSString *)yunxinId;
+ (NSString *)getYunxinId;

+ (void)outLoginClearData;

+ (NSMutableArray *)getPsychologyArrary;

+ (void)saveType:(NSInteger)type;
+ (NSInteger)getType;

+ (BOOL)isFirstinThisDeveiceWorld;//第一次进入首页第二视图
+ (void)setMarkOfincenterWorld;

+ (BOOL)isFirstinThisDeveiceThirdVC;//第一次进入首页第三视图
+ (void)setMarkOfincenterThirdVC;

+ (void)setCotentVoiceOpen:(BOOL)open;
+ (BOOL)isCotentOpen;

+ (BOOL)isFirstCloseAutoPlayer;

+ (void)setIsFirstAutoPlayer;

+ (BOOL)isFirstOpenAutoPlayer;

+ (void)setIsFirstOpenAutoPlayer;

//缓存心情列表选择音频还是文字
+ (NSInteger)voiceType;
+ (void)setVoiceType:(NSString *)type;

+ (BOOL)isFirstCloseVoiceShow;
+ (void)setIsFirstCloseVoiceShow;

+ (BOOL)isFirstClosetextShow;

+ (void)setIsFirstClosetextShow;

//播放速率缓存
+ (NSInteger)voicePlayRate;
+ (void)voicePlayRate:(NSString *)type;


+ (void)saveNearTopicArr:(NSArray *)arrary;
+ (NSMutableArray *)getNearTopicArr;

+ (NSString *)updateTimeForRowVoice:(NSString *)str;

+ (BOOL)isFirstdeleteZJOnThisDeveice;

+ (void)setMarkFordeleteZJ;

+ (BOOL)isFirstknowdhZJOnThisDeveice;

+ (void)setMarkForknowdhZJ;

+ (BOOL)isFirstknowdhdeledhOnThisDeveice;

+ (void)setMarkForknowdeledh;



+ (BOOL)isFirstknowpeiypinglOnThisDeveice;

+ (void)setMarkForknowpeiypingl;
+ (NSArray *)getSeparatedLinesFromLabel:(NSString *)text width:(CGFloat)width font:(UIFont *)font textHeight:(CGFloat )textHeight;
//返回文案
+(NSAttributedString *)setLabelSpacewithValue:(NSString*)str withFont:(UIFont*)font;

//获取指定文字间距和行间距的文案高度
+(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width;

+ (BOOL)isFirstinclickTUYACenter;
+ (void)setMarkclickTUYACenter;

+ (BOOL)isKnowSendMovie;
+ (void)setKnowSendMovie;

+ (BOOL)isKnowSendBook;
+ (void)setKnowSendBook;

+ (BOOL)isKnowSendSong;
+ (void)setKnowSendSong;

+ (void)saveBookTitle:(NSString *)title;

+ (NSString *)getBookTitle;

+ (void)saveBookTime:(NSString *)time;
+ (NSString *)getBookTime;

+ (BOOL)isFirstLogininOnThisDeveice;
+ (void)setMarkForlogin;

+ (BOOL)isFirstbgmOnThisDeveice;

+ (void)setMarkForbgmSend;

+ (BOOL)isFirstworldOnThisDeveice;
+ (void)setMarkForworldSend;

+ (NSInteger)getFastButton;
+ (void)setfastButtonWith:(NSInteger)type;

+ (BOOL)isFirstownOnThisDeveice;
+ (void)setMarkForownSend;

+ (BOOL)isFirstchangeimgOnThisDeveice;
+ (void)setimgForZj;

+ (BOOL)isFirsttextOnThisDeveice;
+ (void)setsendFortext;

//白噪声卡送人搜索记录
+ (void)saveSearchArr:(NSArray *)arrary;
+ (NSMutableArray *)getSearchArr;

//社团聊天消息搜索记录
+ (void)saveSearchGroupArr:(NSArray *)arrary;
+ (NSMutableArray *)getSearchgroupArr;
+ (NSString *)getLocalImageNameCN:(NSString *)cn;

//私聊消息发送失败缓存
+ (void)saveChatArr:(NSArray *)arr chatId:(NSString *)userId;
+ (NSMutableArray *)getChatArrarychatId:(NSString *)userId;

+ (void)savehsChatArr:(NSArray *)arr chatId:(NSString *)userId;
+ (NSMutableArray *)gethsChatArrarychatId:(NSString *)userId;
+ (void)saveGroupChatArr:(NSArray *)arr chatId:(NSString *)userId;
+ (NSMutableArray *)getGroupChatArrarychatId:(NSString *)userId;

+ (NSString *)getDaoishi:(NSString *)getTime;

+ (UIViewController *)getTopViewController;

+ (BOOL)isHidePlayThisDeveiceThirdVC;//是否异常播放助手
+ (void)setHidePlay:(NSString *)status;


+ (void)saveTeamChatArr:(NSArray *)arr chatId:(NSString *)userId;

+ (NSMutableArray *)getTeamChatArrArrarychatId:(NSString *)userId;
@end

NS_ASSUME_NONNULL_END
