/**
 * Copyright(c) Live2D Inc. All rights reserved.
 *
 * Use of this source code is governed by the Live2D Open Software license
 * that can be found at https://www.live2d.com/eula/live2d-open-software-license-agreement_en.html.
 */

#import "AppDelegate.h"
#import "ViewController.h"
#import "LAppAllocator.h"
#import <iostream>
#import "LAppPal.h"
#import "LAppDefine.h"
#import "LAppLive2DManager.h"

// patch
static AppDelegate *s_instance = nil;

@interface AppDelegate ()

@property (nonatomic) LAppAllocator cubismAllocator; // Cubism SDK Allocator
@property (nonatomic) Csm::CubismFramework::Option cubismOption; // Cubism SDK Option
@property (nonatomic) bool isEnd; // APPを終了しているか
// patch
@property(nonatomic) LAppTextureManager *textureManager;
@end

@implementation AppDelegate

// patch
+ (instancetype)sharedInstance {
    return s_instance;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // patch
    s_instance = self;
    
    [self initializeCubism];
    
    // patch
    _textureManager = [[LAppTextureManager alloc] init];

    return YES;
}

- (void)initializeCubism
{
    _cubismOption.LogFunction = LAppPal::PrintMessageLn;
    _cubismOption.LoggingLevel = LAppDefine::CubismLoggingLevel;
    _cubismOption.LoadFileFunction = LAppPal::LoadFileAsBytes;
    _cubismOption.ReleaseBytesFunction = LAppPal::ReleaseBytes;

    Csm::CubismFramework::StartUp(&_cubismAllocator,&_cubismOption);

    Csm::CubismFramework::Initialize();

    Csm::CubismMatrix44 projection;

    LAppPal::UpdateTime();

}

- (bool)getIsEnd
{
    return _isEnd;
}

- (void)finishApplication
{
    // patch
    [_textureManager release];
    _textureManager = nil;

    [LAppLive2DManager releaseInstance];

    Csm::CubismFramework::Dispose();

    _isEnd = true;

    exit(0);
}

// patch
- (void)applicationWillTerminate:(UIApplication *)application {
    if (!_isEnd) {
        [LAppLive2DManager releaseInstance];
        Csm::CubismFramework::Dispose();
        _isEnd = true;
    }
}

// patch
- (LAppTextureManager *)getTextureManager {
    return _textureManager;
}

@end
