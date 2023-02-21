//
//  TabbarController.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/14.
//

#import "TabbarController.h"
#import "SignWithNearUser.h"
@interface MainTabbarController()<UITabBarControllerDelegate,CustomTabbarDelegate2,PDReceiveSocketDelegate,UNUserNotificationCenterDelegate>

@end

@implementation MainTabbarController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [self TabbarSetChildViewController];
    [[PDSocketManager shared] ConnectToServerWithMyID:[AppUserData GetCurrenUser]._id completion:nil];
    [[PDSocketManager shared] SetReceiveDeleagetWithDelgate:self];
}

- (void)DidReceiveConcernWithReceived:(NSArray *)received{
    // 别人关注了我 那是我的粉丝
    NSDictionary *dict = received.firstObject;
    SuccessResponse *res = [[SuccessResponse alloc] initWithDictionary:dict error:nil];
    [[BRNotificationCenter shareCenter] SendNotifitionWithContend:[NSString stringWithFormat:@"%@关注了你",res.status]];
    [[BRNotificationCenter shareCenter] AddNotDataWithType:BRNotificationNewFriend Message:res];
    ClientData *data = [AppUserData GetCurrenUser];
    NSMutableArray *newarr = [NSMutableArray arrayWithArray:data.concernList];
    NSMutableArray *newarr2 = [NSMutableArray arrayWithArray:data.FriendList];
    ConcernListData *newConcern = [[ConcernListData alloc]initWithId:res.msg CreateDate:[NSDate date]];
    [newarr addObject:newConcern];
    [newarr2 addObject:newConcern];
    data.concernList = [newarr copy];
    if(data.concernList.count != 0){
        for(ConcernListData *item in data.concernList){
            if([item.Id isEqualToString:res.msg]){
                data.FriendList = [newarr2 copy];
            }
        }
    }
    [AppUserData SavCurrentUser:data];
    [self.customTabBar SetBadgeWithbage:[[BRNotificationCenter shareCenter] GetNotificationCount] Index:3];
}

- (void)DidSendJoinRoomWithCallBack:(NSString *)callBack{
    NSLog(@"DidSendJoinRoomWithCallBack %@",callBack);
    if([callBack isEqualToString:@"NO ACK"]){
        [[PDSocketManager shared] JoinRoomWithRoomID:[AppUserData GetCurrenUser]._id];
    }
}

- (void)DidReceiveVistorWithReceived:(NSArray *)received{
    // 收到访客通知
}

- (void)DidReceiveVideoLikeWithReceived:(NSArray *)received{
    // 收到视频喜欢
}

- (void)DidReceiveCommentWithReceived:(NSArray *)received{
    // 收到评论通知
}

- (void)DidReceiveCommentLikeWithReceived:(NSArray *)received{
    // 收到评论喜欢通知
}

- (void)DidReceiveChatMessageWithReceived:(NSArray *)received{
    NSDictionary *dict = received.firstObject;
    SuccessResponse *res = [[SuccessResponse alloc] initWithDictionary:dict error:nil];
    [[BRNotificationCenter shareCenter] SendNotifitionWithContend:[NSString stringWithFormat:@"%@给你发送了一条消息",res.status]];
    [[BRNotificationCenter shareCenter] AddNotDataWithType:BRNotificationNewChatMessage Message:res];
    [self.customTabBar SetBadgeWithbage:[[BRNotificationCenter shareCenter] GetNotificationCount] Index:3];
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionBadge);
}



-(void) TabbarSetChildViewController{
    NSArray *ChildViewController = [NSArray array];
    ChildViewController = @[@"HomePageController",@"FriendController",@"UIViewController",@"NoitfyController",@"AccountController"];
    NSArray *title = @[@"首页",@"朋友",@"",@"消息",@"我"];
    NSMutableArray *VcArr = [NSMutableArray array];
    NSMutableArray *BarItemArr = [NSMutableArray array];
    for(int i = 0 ; i < ChildViewController.count;i++){
        Class typeController = NSClassFromString(ChildViewController[i]);
        UIViewController *vc = [[typeController alloc] init];
        vc.tabBarItem.tag = i;
        [VcArr addObject:vc];
        if(i == 2){
            [BarItemArr addObject:[[CustomTabarItem alloc]initWithImage:[UIImage systemImageNamed:@"plus"]]];
        }else{
            [BarItemArr addObject:[[CustomTabarItem alloc]initWithTitle:title[i]]];
        }
    };
    self.customTabBar = [[CustomTabbar2 alloc]initWithFrameAndtabItems:self.tabBar.frame tabItems:BarItemArr];
    self.delegate = self;
    self.customTabBar.myDelegate = self;
    [self setValue:self.customTabBar forKey:@"tabBar"];
    self.tabBar.translucent = NO;
    UITabBarAppearance *appearance = [UITabBarAppearance new];
    appearance.backgroundColor = [UIColor colorNamed:@"darkgray"];
    self.tabBar.standardAppearance = appearance;
    self.tabBar.scrollEdgeAppearance = appearance;
    self.viewControllers = VcArr;
    return;
}

-(void)ChangeTabbarColorWhite{
    UITabBarAppearance *appearance = [UITabBarAppearance new];
    appearance.backgroundColor = [UIColor whiteColor];
    self.tabBar.standardAppearance = appearance;
    self.tabBar.scrollEdgeAppearance = appearance;
}

-(void)ChangeTabbarColorGray{
    UITabBarAppearance *appearance = [UITabBarAppearance new];
    appearance.backgroundColor = [UIColor colorNamed:@"darkgray"];
    self.tabBar.standardAppearance = appearance;
    self.tabBar.scrollEdgeAppearance = appearance;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if([NSUserDefaults.standardUserDefaults boolForKey:@"HasSignIn"]){
        if(tabBar.selectedItem.tag < 2){
            [self.customTabBar setCurrentIndex:tabBar.selectedItem.tag tintColor:[UIColor whiteColor]];
        }else if(tabBar.selectedItem.tag > 2){
            [self.customTabBar setCurrentIndex:tabBar.selectedItem.tag tintColor:[UIColor blackColor]];
        }
    }else{
        if(tabBar.selectedItem.tag > 2){
            [self.customTabBar setCurrentIndex:0 tintColor:[UIColor whiteColor]];
        }
    }
    return;
}

- (void)tabbarDidClickCustomPlusButton:(CustomTabbar2 *)tabbar{
    NSLog(@"respondsToPlusButton");
    UIViewController *newvc = [[UIViewController alloc] init];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    [newvc.view addSubview:button];
    [self presentViewController:newvc animated:YES completion:nil];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSLog(@"%ld  good",(long)viewController.tabBarItem.tag);
    if([NSUserDefaults.standardUserDefaults boolForKey:@"HasSignIn"]){
        // 如果已经登陆了
        if(viewController.tabBarItem.tag == 2){
            UIViewController *newvc = [UIViewController new];
            newvc.view.backgroundColor = [UIColor greenColor];
            [self presentViewController:newvc animated:YES completion:nil];
            return NO;
        }else if(viewController.tabBarItem.tag == 3 || viewController.tabBarItem.tag == 4){
            [self ChangeTabbarColorWhite];
            return YES;
        }else{
            [self ChangeTabbarColorGray];
            return YES;
        }
//    }
    }else{
//         如果当前没有登陆的话
        if(viewController.tabBarItem.tag != 0){
            if([AppUserData GetNearstSignUser]){
                UINavigationController *newvc = [[UINavigationController alloc] initWithRootViewController:[[SignWithNearUser alloc]init]];
                newvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self presentViewController:newvc animated:YES completion:nil];
            }else{
                UINavigationController *newvc = [[UINavigationController alloc] initWithRootViewController:[[SignViewController alloc]init]];
                newvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self presentViewController:newvc animated:YES completion:nil];
            }
         
            return NO;
        }else{
            return YES;
        }
    }

}


@end
