//
//  AudioSpectrumPlayer.h
//  AudioSpectrumDemo
//
//  Created by user on 2019/5/8.
//  Copyright © 2019 adu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AudioSpectrumPlayerDelegate <NSObject>

- (void)playerDidGenerateSpectrum:(NSArray *)spectrums;
- (void)playFailWithPath:(NSString *)path;
- (void)playFinish;
- (void)playStart;
@end

@interface AudioSpectrumPlayer : NSObject

@property (nonatomic, weak) id <AudioSpectrumPlayerDelegate> delegate;

- (void)playWithFileName:(NSString *)fileName;
- (void)stop;
- (void)pause:(BOOL)pause;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) BOOL isPlaying;
@end

NS_ASSUME_NONNULL_END
