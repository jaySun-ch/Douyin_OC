//
//  AppDelegate.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/2.
//


#import "AppDelegate.h"
#import "NetWorkHelper.h"
#import "TabbarController.h"


@interface AppDelegate ()
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    MainTabbarController *controller = [[MainTabbarController alloc] init];
    UINavigationController *RootController = [[UINavigationController alloc] initWithRootViewController:controller];
    [RootController setNavigationBarHidden:YES];
    [_window setRootViewController:RootController];
    [_window makeKeyAndVisible];
    
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:nil];
    [NetWorkHelper startListening];
    [[PDSocketManager shared] ConnectToServerWithMyID:[AppUserData GetCurrenUser]._id completion:nil];
    if([NSUserDefaults.standardUserDefaults objectForKey:@"HasSignIn"] == nil){
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"HasSignIn"];
    }

    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    [UIWindow DissMissSliderBar];
}
- (void)applicationDidEnterBackground:(UIApplication *)application{
    [self beginTask];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        self.number = 0;
        if (@available(iOS 10.0, *)) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f repeats:YES block:^(NSTimer * _Nonnull timer) {
                [[PDSocketManager shared] ConnectToServerWithMyID:[AppUserData GetCurrenUser]._id completion:nil];
            }];
        } else {
            // Fallback on earlier versions
        }
}


/// app进入后台后保持运行
- (void)beginTask {
    _backIden = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //如果在系统规定时间3分钟内任务还没有完成，在时间到之前会调用到这个方法
        [self endBack];
    }];
}
 
/// 结束后台运行，让app挂起
- (void)endBack {
    //切记endBackgroundTask要和beginBackgroundTaskWithExpirationHandler成对出现
    [[UIApplication sharedApplication] endBackgroundTask:_backIden];
    _backIden = UIBackgroundTaskInvalid;
}
@end
