#import "Global.h"
#import "HBDPRootListController.h"
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Foundation/NSDistributedNotificationCenter.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#include <notify.h>

static NSString *const kHBDPUpdateNowIdentifier = @"UpdateNow";
static NSString *const kHBDPSaveWallpaperIdentifier = @"SaveWallpaper";

@implementation HBDPRootListController

#pragma mark - Constants

+ (NSString *)hb_shareText {
    return [NSString stringWithFormat:@"I’m using DailyPaper to enjoy a different wallpaper on my %@ every day!", [UIDevice currentDevice].localizedModel];
}

+ (NSURL *)hb_shareURL {
    return [NSURL URLWithString:@"http://hbang.ws/dailypaper"];
}

+ (NSString *)hb_specifierPlist {
    return @"Root";
}

#pragma mark - UIViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(wallpaperDidUpdate:) name:HBDPWallpaperDidUpdateNotification object:nil];
        [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(wallpaperDidSave:) name:HBDPWallpaperDidSaveNotification object:nil];
    }

    return self;
}

- (void)viewDidLoad  {
    [super viewDidLoad];

    HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
    appearanceSettings.tintColor = [UIColor colorWithRed:241.f / 255.f green:148.f / 255.f blue:0 alpha:1];
    self.hb_appearanceSettings = appearanceSettings;
}

#pragma mark - Actions

// TODO: this feels really ugly :(

- (void)forceUpdate:(PSSpecifier *)sender {
	[self _postNotification:CFSTR("ws.hbang.dailypaper/ForceUpdate") forSpecifier:sender];
}

- (void)saveWallpaper:(PSSpecifier *)sender {
	[self _postNotification:CFSTR("ws.hbang.dailypaper/SaveWallpaper") forSpecifier:sender];
}

- (void)_postNotification:(CFStringRef)notification forSpecifier:(PSSpecifier *)specifier {
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notification, NULL, NULL, YES);

	PSTableCell *cell = [self cachedCellForSpecifier:specifier];
	cell.cellEnabled = NO;
}

#pragma mark - Callbacks

- (void)wallpaperDidUpdate:(NSNotification *)notification {
	[self _callbackReturnedWithError:notification.userInfo[kHBDPErrorKey] forIdentifier:kHBDPUpdateNowIdentifier];
}

- (void)wallpaperDidSave:(NSNotification *)notification {
	[self _callbackReturnedWithError:notification.userInfo[kHBDPErrorKey] forIdentifier:kHBDPSaveWallpaperIdentifier];
}

- (void)_callbackReturnedWithError:(NSError *)error forIdentifier:(NSString *)identifier {
    PSTableCell *cell = [self cachedCellForSpecifierID:identifier];
    cell.cellEnabled = YES;

    if (error) {
        NSString *message = [NSString stringWithFormat:@"%@\nMake sure you’re connected to the Internet and try again in a few minutes.", error.localizedDescription];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Couldn’t download your wallpaper because an error occurred." message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];

        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Memory management

- (void)dealloc {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

@end
