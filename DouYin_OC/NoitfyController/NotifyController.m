//
//  NotifyController.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/14.
//

#import "NotifyController.h"
#import "CustomScrollCell.h"
#import "CustomTalk.h"
#import "TalkViewController.h"
#import "SearchController.h"
#import "AddMainFriendController.h"

#define NavigationBarHeight 90
NSString *const talkCell = @"TalkCell";
NSString *const imageScrollCell = @"imageScrollCell";


@interface NoitfyController()<UITableViewDelegate,UITableViewDataSource,BRNotificationCenterNotViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *NavigationBar;
@property (nonatomic,strong) UIImageView *plusButton;
@property (nonatomic,strong) UIImageView *searchButton;
@property (nonatomic,strong) UIImageView *promotButton;
@property (nonatomic,strong) MyFriendDetialResponse *alldata;
@property (nonatomic,strong) NSMutableArray<BRNotificationData *> *NotData ;
@end

@implementation NoitfyController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self GetData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    [self initNaivationBar];
    [[BRNotificationCenter shareCenter] setNotViewDelegate:self];
}

- (void)DidReceivedChatNotificationForNotView:(id)Message{
    SuccessResponse *response = Message;
    NSUInteger index = [self.alldata.msg indexOfObjectPassingTest:^BOOL(FriendListDetialData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.username isEqualToString:response.status]){
            NSLog(@"DidReceivedChatNotificationForNotView %@ %ld %@",response.status,idx,obj.username);
            return YES;
        }
        return NO;
    }];
    CustomTalkCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3+index inSection:1]];
    [cell.subTitle setText:response.msg];
    [cell.RedDot setHidden:NO];
    [cell.RedDot setText:[NSString stringWithFormat:@"%ld",[[BRNotificationCenter shareCenter] GetAllMessageCountByID:response.status]]];
}

- (void)DidReceivedNewFriendNotificationForNotView:(id)Message{
    SuccessResponse *response = Message;
    CustomTalkCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.subTitle setText:[NSString stringWithFormat:@"%@关注了你",response.status]];
    [cell.RedDot setHidden:NO];
    [cell.RedDot setText:[NSString stringWithFormat:@"%ld",[[BRNotificationCenter shareCenter] GetAllNewFriendCount]]];
}

-(void)GetData{
    GetClientNameAndImageRequest *quest = [GetClientNameAndImageRequest new];
    quest.MyID = [AppUserData GetCurrenUser]._id;
    [NetWorkHelper getWithUrlPath:GetFriendListDetialPath request:quest success:^(id data) {
        self.alldata = [[MyFriendDetialResponse alloc] initWithDictionary:data error:nil];
        [self.tableView reloadData];
        CustomTalkCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        NSArray<BRNotificationData*> *alldata = [[BRNotificationCenter shareCenter].AllNotData filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(BRNotificationData *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            if(evaluatedObject.NotType == BRNotificationNewFriend){
                return YES;
            }
            return NO;
        }]];
        if(alldata.count > 0){
            SuccessResponse *res = alldata.lastObject.NotContend;
            [cell.subTitle setText:[NSString stringWithFormat:@"%@关注了你",res.status]];
            [cell.RedDot setHidden:NO];
            [cell.RedDot setText:[NSString stringWithFormat:@"%ld",alldata.count]];
        }

        
        //更新所有消息列表
        
        for(NSInteger i = 3;i<self.alldata.msg.count + 3;i++){
            CustomTalkCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            SuccessResponse *res = [[BRNotificationCenter shareCenter].AllNotData filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(BRNotificationData *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                SuccessResponse *res  = evaluatedObject.NotContend;
                if(evaluatedObject.NotType == BRNotificationNewChatMessage && [res.status isEqualToString:cell.title.text]){
                    return YES;
                }
                return NO;
            }]].lastObject.NotContend;
            if(res!=nil){
                [cell.subTitle setText:res.msg];
                [cell.RedDot setHidden:NO];
                [cell.RedDot setText:[NSString stringWithFormat:@"%ld",[[BRNotificationCenter shareCenter] GetAllMessageCountByID:res.status]]];
            }
        }
    } faliure:^(NSError *error) {
        [UIWindow showTips:@"服务器走神了哦"];
    }];
}


-(void)initNaivationBar{
    self.NavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationBarHeight)];
    self.NavigationBar.backgroundColor = [UIColor whiteColor];
    self.NavigationBar.layer.borderWidth = 1;
    self.NavigationBar.layer.borderColor = [UIColor colorNamed:@"lightgray"].CGColor;
    self.plusButton = [[UIImageView alloc] init];
    self.searchButton = [[UIImageView alloc] init];
    [self.searchButton setUserInteractionEnabled:YES];
    [self.searchButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        SearchController *vc = [[SearchController alloc] init];
        [UIWindow PushController:vc animated:NO];
    }]];
    self.promotButton = [[UIImageView alloc] init];
    [self.plusButton setTintColor:[UIColor blackColor]];
    [self.searchButton setTintColor:[UIColor blackColor]];
    [self.promotButton setTintColor:[UIColor blackColor]];
    [self.plusButton setImage:[UIImage systemImageNamed:@"plus.circle"] ];
    [self.searchButton setImage:[UIImage systemImageNamed:@"magnifyingglass"]];
    [self.promotButton setImage:[UIImage systemImageNamed:@"bolt.circle"]];
    
    [self.NavigationBar addSubview:self.plusButton];
    [self.NavigationBar addSubview:self.searchButton];
    [self.NavigationBar  addSubview:self.promotButton];
    [self.view addSubview:self.NavigationBar];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.NavigationBar).inset(15);
        make.bottom.equalTo(self.NavigationBar).inset(10);
        make.height.width.mas_equalTo(25);
    }];
    
    [self.plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.NavigationBar).inset(15);
        make.bottom.equalTo(self.NavigationBar).inset(10);
        make.height.width.mas_equalTo(25);
    }];
    
    [self.promotButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.NavigationBar);
        make.bottom.equalTo(self.NavigationBar).inset(10);
        make.height.width.mas_equalTo(25);
    }];
    
}

-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavigationBarHeight, self.view.frame.size.width, self.view.frame.size.height - TabbarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[CustomScrollCell class] forCellReuseIdentifier:imageScrollCell];
    [self.tableView registerClass:[CustomTalkCell class] forCellReuseIdentifier:talkCell];
    [self.view addSubview:self.tableView];
}

#pragma SetTableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([AppUserData GetCurrenUser].FriendList.count == 0){
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([AppUserData GetCurrenUser].FriendList.count != 0 && section == 0){
        return 1;
    }
    return 3 + [AppUserData GetCurrenUser].FriendList.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([AppUserData GetCurrenUser].FriendList.count != 0 && indexPath.section == 0){
        return 110;
    }
    return 75;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && [AppUserData GetCurrenUser].FriendList.count != 0){
        CustomScrollCell *cell = [tableView dequeueReusableCellWithIdentifier:imageScrollCell forIndexPath:indexPath];
        [cell initWithData:self.alldata];
        return cell;
    }else{
        if(indexPath.row < 3){
            
            CustomTalkCell *cell = [tableView dequeueReusableCellWithIdentifier:talkCell forIndexPath:indexPath];
                       
            if(indexPath.row == 0){
                [cell.mainImage setImage:[UIImage imageNamed:@"icon-person"] ];
                [cell.title setText:@"新朋友"];
                [cell.subTitle setText:@"没有新通知"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if(indexPath.row == 1){
                [cell.mainImage setImage:[UIImage imageNamed:@"icon-flash"] ];
                [cell.title setText:@"互动消息"];
                [cell.subTitle setText:@"没有新通知"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            if(indexPath.row == 2){
                [cell.mainImage setImage:[UIImage imageNamed:@"icon-handle"] ];
                [cell.title setText:@"求更新"];
                [cell.subTitle setText:@"没有新通知"];
           }
            
            [cell.RedDot setHidden:YES];
                  
            return cell;
        }else{
            CustomTalkCell *cell = [tableView dequeueReusableCellWithIdentifier:talkCell forIndexPath:indexPath];
            [cell.mainImage setImageWithURL:[NSURL URLWithString:self.alldata.msg[indexPath.row-3].ClientImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
            [cell.title setText:self.alldata.msg[indexPath.row-3].username];
            [cell.subTitle setText:@"没有新消息"];
            return cell;
        }
       
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0  && indexPath.section == 1){
        AddMainFriendController *newvc = [[AddMainFriendController alloc] init];
        newvc.currentIndex = 1;
        [UIWindow PushController:newvc];
    }
    if(indexPath.row >= 3){
        TalkViewController *controller = [[TalkViewController alloc] init];
        controller.ClientName = self.alldata.msg[indexPath.row-3].username;
        controller.ClientId = self.alldata.msg[indexPath.row-3].Id;
        controller.ClientImagurl = self.alldata.msg[indexPath.row-3].ClientImageUrl;
        [UIWindow PushController:controller];
    }
}

@end
