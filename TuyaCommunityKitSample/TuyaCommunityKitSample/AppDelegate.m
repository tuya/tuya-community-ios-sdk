//
//  AppDelegate.m
//  TuyaCommunityKitSample
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "AppDelegate.h"
#import "TuyaCommunityManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [TuyaSmartSDK.sharedInstance setDebugMode:YES];
//    [TuyaSmartSDK.sharedInstance startWithAppKey:@"<#Your App Key#>" secretKey:@"<#Your Secret Key#>"];
    self.window.rootViewController = TuyaCommunityManager.sharedInstance.mainViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
