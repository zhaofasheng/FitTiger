//
//  NoticeCollectionDrawModel.m
//  NoticeXi
//
//  Created by li lei on 2020/6/16.
//  Copyright © 2020 zhaoxiaoer. All rights reserved.
//

#import "NoticeCollectionDrawModel.h"

@implementation NoticeCollectionDrawModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"collectionId":@"id"};
}

- (void)setArtwork:(NSDictionary *)artwork{
    _artwork = artwork;
    self.drawModel = [NoticeDrawList mj_objectWithKeyValues:artwork];
}
@end
