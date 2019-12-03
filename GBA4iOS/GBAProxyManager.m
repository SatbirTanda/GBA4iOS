//
//  GBAProxyManager.m
//  GBA4iOS
//
//  Created by Tanda, Satbir (S.S.) on 12/3/19.
//  Copyright © 2019 Riley Testut. All rights reserved.
//

#import "GBAProxyManager.h"
#import "GBAEmulationViewController.h"
#import <SmartDeviceLink/SmartDeviceLink.h>

static NSString* const AppName = @"GBA";
static NSString* const AppId = @"1234";

@interface GBAProxyManager () <SDLManagerDelegate>
@property (nonatomic, strong) SDLManager* sdlManager;
@end

@implementation GBAProxyManager

+ (instancetype)sharedInstance {
    static GBAProxyManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GBAProxyManager alloc] init];
    });

    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    // Used for USB Connection
    SDLLifecycleConfiguration* lifecycleConfiguration = [SDLLifecycleConfiguration defaultConfigurationWithAppName:AppName fullAppId:AppId];

    // Used for TCP/IP Connection
//    SDLLifecycleConfiguration* lifecycleConfiguration = [SDLLifecycleConfiguration debugConfigurationWithAppName:AppName fullAppId:AppId  ipAddress:@"<#IP Address#>" port:<#Port#>];

    UIImage* appImage = [UIImage imageNamed:@"Software_Update_Icon"];
    if (appImage) {
        SDLArtwork* appIcon = [SDLArtwork persistentArtworkWithImage:appImage name:@"GBA" asImageFormat:SDLArtworkImageFormatJPG /* or SDLArtworkImageFormatPNG */];
        lifecycleConfiguration.appIcon = appIcon;
    }

    lifecycleConfiguration.shortAppName = @"GBA";
    lifecycleConfiguration.appType = SDLAppHMITypeNavigation;

    SDLStreamingMediaConfiguration *streamConfig = [SDLStreamingMediaConfiguration autostreamingInsecureConfigurationWithInitialViewController:[[GBAEmulationViewController alloc] init]];
    streamConfig.allowReplayKit = YES;
    streamConfig.customVideoEncoderSettings = @{(NSString *)kVTCompressionPropertyKey_ExpectedFrameRate: @60};

    SDLConfiguration* configuration = [SDLConfiguration configurationWithLifecycle:lifecycleConfiguration lockScreen:[SDLLockScreenConfiguration enabledConfiguration] logging:[SDLLogConfiguration defaultConfiguration] streamingMedia:streamConfig fileManager:[SDLFileManagerConfiguration defaultConfiguration]];

    self.sdlManager = [[SDLManager alloc] initWithConfiguration:configuration delegate:self];

    return self;
}

- (void)connect {
    [self.sdlManager startWithReadyHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            // Your app has successfully connected with the SDL Core
        }
    }];
}

#pragma mark SDLManagerDelegate
- (void)managerDidDisconnect {
    NSLog(@"Manager disconnected!");
}

- (void)hmiLevel:(SDLHMILevel *)oldLevel didChangeToLevel:(SDLHMILevel *)newLevel {
    NSLog(@"Went from HMI level %@ to HMI Level %@", oldLevel, newLevel);
}

@end
