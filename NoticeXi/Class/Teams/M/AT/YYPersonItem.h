
#import <Foundation/Foundation.h>

@interface YYPersonItem : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, strong) NSString *title;//索引用的字母
@property (nonatomic, assign) BOOL isAt;
@property (nonatomic, strong) NSMutableArray *personArr;

@property (nonatomic, strong) NSString *initial;
@property (nonatomic, strong) NSString *mass_nick_name;
@property (nonatomic, strong) NSString *avatar_url;
@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSArray *lists;


@property (nonatomic, strong) NSArray *members;
@property (nonatomic, strong) NSArray *administrators;
@end
