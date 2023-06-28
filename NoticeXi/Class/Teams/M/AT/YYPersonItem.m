

#import "YYPersonItem.h"

@implementation YYPersonItem

- (NSMutableArray *)personArr{
    if(!_personArr){
        _personArr = [[NSMutableArray alloc] init];
    }
    return _personArr;
}

- (void)setInitial:(NSString *)initial{
    _initial = initial;
    self.title = initial;
}

- (void)setMass_nick_name:(NSString *)mass_nick_name{
    _mass_nick_name = mass_nick_name;
    self.name = mass_nick_name;
}

- (void)setUser_id:(NSString *)user_id{
    _user_id = user_id;
    self.userId = user_id;
}

- (void)setLists:(NSArray *)lists{
    _lists = lists;
    for (NSDictionary *dic in lists) {
        [self.personArr addObject:[YYPersonItem mj_objectWithKeyValues:dic]];
    }
}
@end
