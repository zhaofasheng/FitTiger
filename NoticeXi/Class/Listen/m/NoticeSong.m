//
//  NoticeSong.m
//  NoticeXi
//
//  Created by li lei on 2019/4/18.
//  Copyright © 2019年 zhaoxiaoer. All rights reserved.
//

#import "NoticeSong.h"

@implementation NoticeSong
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"albumId":@"id"};
}

- (void)setSong_cover:(NSString *)song_cover{
    _song_cover = song_cover;
    self.album_cover = song_cover;
}
- (void)setSong_genre:(NSString *)song_genre{
    _song_genre = song_genre;
    self.album_genre = song_genre;
}
- (void)setSong_singer:(NSString *)song_singer{
    if (song_singer.length > 30) {
        _song_singer = [song_singer substringToIndex:20];
    }else{
        _song_singer = song_singer;
    }
    self.album_singer = _song_singer;
}
- (void)setFirst_voice:(NSDictionary *)first_voice{
    _first_voice = first_voice;
    self.voiceM = [NoticeVoiceModel mj_objectWithKeyValues:first_voice];
}
@end
