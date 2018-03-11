#import "HBDPPreferences.h"
#import <Cephei/HBPreferences.h>

@implementation HBDPPreferences {
    HBPreferences *_preferences;
}

+ (instancetype)mainPreferences {
    static HBDPPreferences *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _preferences = [HBPreferences preferencesForIdentifier:@"ws.hbang.dailypaper"];

        [_preferences registerBool:&_enabled default:YES forKey:kHBDPEnabledKey];

        [_preferences registerInteger:(NSInteger *)&_region default:HBDPBingRegionWorldwide forKey:kHBDPRegionKey];
        [_preferences registerInteger:(NSInteger *)&_wallpaperMode default:PLWallpaperModeBoth forKey:kHBDPWallpaperModeKey];

        [_preferences registerBool:&_useRetina default:!IS_IPAD forKey:kHBDPUseRetinaKey];
        [_preferences registerBool:&_useWiFiOnly default:NO forKey:kHBDPUseWiFiOnlyKey];
    }

    return self;
}

@end
