
#import <Foundation/Foundation.h>

@interface ClockModel : NSObject

@property (nonatomic, copy) NSDate *date;

//am,pm
@property (nonatomic, copy) NSString *timeText;
//时间
@property (nonatomic, copy) NSString *timeClock;
//标签
@property (nonatomic, copy) NSString *tagStr;
//铃声
@property (nonatomic, copy) NSString *music;

//重复、标识符
@property (nonatomic, copy) NSString *repeatStr;
@property (nonatomic, copy) NSString *identifer;

@property (nonatomic, strong) NSArray *repeatStrs;
@property (nonatomic, strong) NSArray *identifers;//重复 闹钟 的标识符
//@property (nonatomic, strong) NSDateComponents *dateComponents;

@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) BOOL isLater;
@property (nonatomic, assign) BOOL repeats;

//添加闹钟
- (void)addUserNotification;
//移除闹钟
- (void)removeUserNotification;

- (NSDate *)date;
- (void)setDate:(NSDate *)date;

@end
