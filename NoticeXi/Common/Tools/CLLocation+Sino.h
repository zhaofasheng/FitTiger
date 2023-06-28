

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Sino)

- (CLLocation*)locationMarsFromEarth;
//- (CLLocation*)locationEarthFromMars; // 未实现

- (CLLocation*)locationBearPawFromMars;
- (CLLocation*)locationMarsFromBearPaw;

@end
