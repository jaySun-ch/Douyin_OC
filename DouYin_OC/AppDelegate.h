//
//  AppDelegate.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/2.
//

#import <UIKit/UIKit.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIBackgroundTaskIdentifier _backIden;
}
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSTimer   *timer;
@property (strong, nonatomic) UIWindow *window;

@end

