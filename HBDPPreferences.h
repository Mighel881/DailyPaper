#import <PhotoLibrary/PLStaticWallpaperImageViewController.h>

@interface HBDPPreferences : NSObject

@property (nonatomic, readonly) BOOL enabled;

@property (nonatomic, readonly) BOOL useRetina, useWiFiOnly;

@property (nonatomic, readonly) HBDPBingRegion region;
@property (nonatomic, readonly) PLWallpaperMode wallpaperMode;

+ (instancetype)mainPreferences;

@end
