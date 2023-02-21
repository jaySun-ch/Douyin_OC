//
//  TalkViewController.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//

#import "TalkViewController.h"
#import "TalkTopBar.h"
#import "TalkDownBar.h"
#import "TalkDownUpBar.h"
#import "TableCellTalkText.h"
#import "TableCellTalkImage.h"
#import "TableCellTalkCenter.h"
#import "TableCellHeightHelper.h"


#define SafeBottomAreaHeight 40
#define DownBarHeight 55
#define TopBarHeight 90
#define DownUpBarHeight 40

@interface TalkViewController()<UITableViewDelegate,UITableViewDataSource,TalkDownBarDelegate,TalkTopBarDelegate,PDSocketChatDelegate>
@property (nonatomic,strong) TalkTopBar *TopBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TalkDownBar *downBar;
@property (nonatomic,strong) NSMutableArray<OneMessageData *> *message;
@property (nonatomic,assign) CGFloat KeyboardHeight;
@property (nonatomic,strong) TalkDownUpBar *downUpBar;
@end

@implementation TalkViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[PDSocketManager shared] SetChatDeleagetWithDelgate:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.message = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboadrWillshow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboadrWillDissMiss:) name:UIKeyboardWillHideNotification object:nil];
    [self initTableView];
    [self initTopBarAndBottonBar];
}


-(void)initTopBarAndBottonBar{
    self.TopBar = [[TalkTopBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, TopBarHeight)];
    self.TopBar.delegate = self;
    [self.TopBar SetData:self.ClientImagurl name:self.ClientName];
    [self.view addSubview:self.TopBar];
    self.downBar = [[TalkDownBar alloc] initWithFrame:CGRectMake(0,ScreenHeight - SafeBottomAreaHeight - DownBarHeight , ScreenWidth, DownBarHeight)];
    self.downBar.delegate = self;
    self.downBar.TalkID = self.ClientId;
    [self.view addSubview:self.downBar];
    self.downUpBar = [[TalkDownUpBar alloc]initWithFrame:CGRectMake(0, ScreenHeight - SafeBottomAreaHeight - DownBarHeight - DownUpBarHeight, ScreenWidth, DownUpBarHeight)];
    self.downUpBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.downUpBar];
}

#pragma TopBar的delegate事件
- (void)TopBarDidTapOnView:(NSInteger)view{
    if(view == TalkTopBarBackButton){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma 键盘监听事件
-(void)KeyboadrWillshow:(NSNotification *)center{
    self.KeyboardHeight = [center keyBoardHeight];
    [UIView animateWithDuration:0.1f animations:^{
        self.tableView.size = CGSizeMake(ScreenWidth, ScreenHeight - TopBarHeight - self.downBar.size.height - self.KeyboardHeight);
    }];
    NSLog(@"%f %f %f tableViewheight",self.tableView.size.height, self.downBar.size.height,self.tableView.contentSize.height);
    [self TableViewScrollToBotton:YES];
    self.downUpBar.alpha = 0;
    [UIView animateWithDuration:0.1f animations:^{
        self.downBar.origin = CGPointMake(0,ScreenHeight - self.KeyboardHeight - self.downBar.size.height);
    }];
}


-(void)KeyboadrWillDissMiss:(NSNotificationCenter *)center{
    [UIView animateWithDuration:0.1f animations:^{
        self.downUpBar.frame = CGRectMake(0, ScreenHeight - SafeBottomAreaHeight - self.downBar.size.height - DownUpBarHeight, ScreenWidth, DownBarHeight);
        self.downBar.origin = CGPointMake(0,ScreenHeight - SafeBottomAreaHeight - self.downBar.size.height);
        self.tableView.size = CGSizeMake(ScreenWidth, ScreenHeight - TopBarHeight - self.downBar.size.height - DownUpBarHeight - SafeAreaBottomHeight);
        self.downUpBar.alpha = 1;
    }completion:nil];
}

#pragma TalkDownBar的delegate方法
- (void)DidChangeTextViewHeight:(CGFloat)height{
    if(height > DownBarHeight){
        [UIView animateWithDuration:0.1f animations:^{
            self.downBar.size =  CGSizeMake(ScreenWidth, height + 10);
            self.downBar.origin = CGPointMake(0,ScreenHeight - self.KeyboardHeight - self.downBar.size.height);
        }];
    }else{
        [UIView animateWithDuration:0.1f animations:^{
            self.downBar.size =  CGSizeMake(ScreenWidth, DownBarHeight);
            self.downBar.origin = CGPointMake(0,ScreenHeight - self.KeyboardHeight - DownBarHeight);
        }];
    }
}


- (void)DidSendMessage:(NSString *)Message{
    OneMessageData *message1 = [[OneMessageData alloc] init];
    message1.dataType = TalkMessageDataText;
    message1.My_id = [AppUserData GetCurrenUser]._id;
    message1.SendMessage = Message;
    message1.state = MessageSending;
    [self AddMessageToTableView:message1];
}

#pragma 公用的调用刷新TableView方法
-(void)AddMessageToTableView:(OneMessageData *)Message {
    [self.message addObject:Message];
    NSLog(@"%ld DidSendMessage",self.message.count-1);
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self.tableView reloadData];
    }];
    [self.tableView beginUpdates];
    [self.tableView insertRow:self.message.count - 1 inSection:0 withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView reloadRow:self.message.count - 1 inSection:0 withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [CATransaction commit];
    [self TableViewScrollToBotton:YES];
}

#pragma 从服务端接受的对方发送的消息
- (void)DidReceiveChatMessageWithReceived:(NSArray * _Nonnull)received {
    NSDictionary *dict = received.lastObject;
    SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:dict error:nil];
    OneMessageData *message1 = [[OneMessageData alloc] init];
    message1.dataType = TalkMessageDataText;
    message1.My_id = response.status;
    message1.SendMessage = response.msg;
    [self AddMessageToTableView:message1];
}

- (void)DidSendChatMessageWithCallBack:(NSString * _Nonnull)callBack {
    if([callBack isEqual:@"NO ACK"]){
        // 如果返回的结果为空
        self.message.lastObject.state = MessageSendFaliure;
    }else{
        // 如果返回成功
        self.message.lastObject.state = MessageSendSuccess;
    }
    [self.tableView reloadRow:self.message.count - 1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (void)DidReceiveChatInputStateWithReceived:(NSArray * _Nonnull)received {
 
}


- (void)DidReceiveOtherMessage{
    [self.TopBar.label setText:[NSString stringWithFormat:@"%ld",[[BRNotificationCenter shareCenter] GetNotificationCountWithoutID:self.ClientName]]];
}

//- (void)DidSendJoinRoomWithCallBack:(NSString *)callBack{
//    if([callBack isEqualToString:@"NO ACK"]){
//        if(self.IsConcernFirst){
//            [[PDSocketManager shared] JoinRoomWithRoomID:[NSString stringWithFormat:@"%@+%@",[[AppUserData GetCurrenUser]]._id,self.ClientId]];
//        }else{
//            [[PDSocketManager shared] JoinRoomWithRoomID:[NSString stringWithFormat:@"%@+%@",self.ClientId,[[AppUserData GetCurrenUser]]._id]];
//        }
//    }
//}

- (void)DidReadMyMessageWithDidRead:(NSString *)didRead{
//    if([didRead isEqualToString:[[AppUserData GetCurrenUser]].phoneNumber]){
//        self.message.lastObject.state = MessageHasRead;
//        [self.tableView reloadRow:self.message.count - 1 inSection:0 withRowAnimation:UITableViewRowAnimationNone];
//    }
}



#pragma 设置TableView
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,TopBarHeight, ScreenWidth,ScreenHeight - TopBarHeight - DownBarHeight - DownUpBarHeight - SafeAreaBottomHeight)];
    self.tableView.automaticallyAdjustsScrollIndicatorInsets = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.downBar DisMissKeyBoard];
    }]];
    [self.tableView setAllowsSelection:NO];
    [self.tableView registerClass:[TableCellTalkText class] forCellReuseIdentifier:@"TalkText"];
    [self.tableView registerClass:[TableCellTalkImage class] forCellReuseIdentifier:@"TalkImage"];
    [self.tableView registerClass:[TableCellTalkCenter class] forCellReuseIdentifier:@"TalkCenter"];
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    [self TableViewScrollToBotton:NO];
}

-(void)TableViewScrollToBotton:(BOOL)animated{
    if(self.message.count != 0){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.message.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.message.count;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    // 返回精确的高度
//    OneMessageData *currentdata  = self.message[indexPath.row];
//    if(currentdata.dataType == TalkMessageDataText){
////        if(indexPath.row == self.message.count - 1){
////            return ([TableCellHeightHelper GetCellHeightWithString:self.message[indexPath.row].SendMessage]);
////        }
//        return [TableCellHeightHelper GetCellHeightWithString:self.message[indexPath.row].SendMessage];
//    }else if(currentdata.dataType == TalkMessageDataImage){
////        if(indexPath.row == self.message.count - 1){
////            return ([TableCellHeightHelper GetCellHeightWithImageRadio:currentdata.ImageRadio]);
////        }
//        return [TableCellHeightHelper GetCellHeightWithImageRadio:currentdata.ImageRadio];
//    }else{
//        return 30;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OneMessageData *currentdata  = self.message[indexPath.row];
    if(currentdata.dataType == TalkMessageDataText){
        //        if(indexPath.row == self.message.count - 1){
        //            return ([TableCellHeightHelper GetCellHeightWithString:self.message[indexPath.row].SendMessage]);
        //        }
        return [TableCellHeightHelper GetCellHeightWithString:self.message[indexPath.row].SendMessage];
    }else if(currentdata.dataType == TalkMessageDataImage){
        //        if(indexPath.row == self.message.count - 1){
        //            return ([TableCellHeightHelper GetCellHeightWithImageRadio:currentdata.ImageRadio]);
        //        }
        return [TableCellHeightHelper GetCellHeightWithImageRadio:currentdata.ImageRadio];
    }else{
        return 30;
    }
}



// cell的类型 1.朋友类型 2.自己类型 3.中立类型  内容分为 图片 视频 文本
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OneMessageData *currentdata  = self.message[indexPath.row];
    if(currentdata.dataType == TalkMessageDataText){
        TableCellTalkText *cell = [tableView dequeueReusableCellWithIdentifier:@"TalkText" forIndexPath:indexPath];
        if([currentdata.My_id isEqualToString:[AppUserData GetCurrenUser]._id]){
            [cell initWithModel:NO Message:currentdata.SendMessage ];
            if(indexPath.row == self.message.count - 1){
                if(currentdata.state  == MessageSending){
                    [cell.StatLable setText:@"发送中"];
                }else if(currentdata.state == MessageHasRead){
                    [cell.StatLable setText:@"已读"];
                }else if(currentdata.state == MessageSendFaliure){
                    [cell.StatLable setText:@"失败"];
                }else{
                    [cell.StatLable setText:@"已发送"];
                }
            }
        }else{
            [cell initWithModel:YES Message:currentdata.SendMessage];
        }
        return cell;
    }else if(currentdata.dataType == TalkMessageDataImage){
        TableCellTalkImage *cell = [tableView dequeueReusableCellWithIdentifier:@"TalkImage" forIndexPath:indexPath];
        if([currentdata.My_id isEqualToString:[AppUserData GetCurrenUser].phoneNumber]){
            [cell initWithModel:NO imageurl:currentdata.SendImageUrl ImageRadio:currentdata.ImageRadio];
        }else{
            [cell initWithModel:YES imageurl:currentdata.SendImageUrl ImageRadio:currentdata.ImageRadio];
        }
        return cell;
    }else{
        TableCellTalkCenter *cell = [tableView dequeueReusableCellWithIdentifier:@"TalkCenter" forIndexPath:indexPath];
        [cell SetCenterText:currentdata.SendMessage];
        return cell;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.downBar DisMissKeyBoard];
}

-(BOOL)TableViewIsOnBottom{
    CGFloat height = self.tableView.frame.size.height;
    CGFloat contentYoffset = self.tableView.contentOffset.y;
    CGFloat distanceFromBottom = self.tableView.contentSize.height - contentYoffset < self.tableView.frame.size.height;
    if (distanceFromBottom < height) {
        return YES;
    }else{
        return NO;
    }
}

-(void)initMessage{
    NSMutableArray<OneMessageData *> *AllMessage = [NSMutableArray array];
    OneMessageData *message1 = [[OneMessageData alloc] init];
    message1.dataType = TalkMessageDataText;
    message1.My_id = @"19956270227";
    message1.SendMessage = @"你好呀";
    
    OneMessageData *message2 = [[OneMessageData alloc] init];
    message2.dataType = TalkMessageDataText;
    message2.My_id = @"18342788992";
    message2.SendMessage = @"hhh 你好 你好捏";
    
    OneMessageData *message3 = [[OneMessageData alloc] init];
    message3.dataType = TalkMessageDataText;
    message3.My_id = @"18342788992";
    message3.SendMessage = @"分享一下在ios开发中 二维码的生成方式,生成二维码的时候 我们需要借助 libqrencode 第三方库 来帮助我们实现";
    
    OneMessageData *message4 = [[OneMessageData alloc] init];
    message4.dataType = TalkMessageDataText;
    message4.My_id = @"19956270227";
    message4.SendMessage = @"真的吗 真的是太棒了吧 哈哈哈哈 之前一字没怎么用过哎 好耶";
    
    OneMessageData *message5 = [[OneMessageData alloc] init];
    message5.dataType = TalkMessageDataText;
    message5.My_id = @"19956270227";
    message5.SendMessage = @"在百度中找到并下载 libqrencode,将 libqrencode 导入到我们的程序中,为程序拖拽一个按钮(button),文本框(Text Field),图片视图(Image View) 并将其与ViewController.m 关联";
    
    OneMessageData *message6 = [[OneMessageData alloc] init];
    message6.dataType = TalkMessageDataText;
    message6.My_id = @"18342788992";
    message6.SendMessage = @"对对对 这个真的很棒的哈哈哈哈";
    
    OneMessageData *message7 = [[OneMessageData alloc] init];
    message7.dataType = TalkMessageDataText;
    message7.My_id = @"19956270227";
    message7.SendMessage = @"抱紧你 却抓不住一点点 那一些我看见了 你的说没有从前";
    
    OneMessageData *message8 = [[OneMessageData alloc] init];
    message8.dataType = TalkMessageDataText;
    message8.My_id = @"18342788992";
    message8.SendMessage = @"金刚石出自古代火山的筒状火成砾岩（火山筒），它嵌在一种比较柔软的、暗色的碱性岩石中，称为“蓝土”或“含钻石的火成岩”，1870年在南非的吉姆伯利城，首次发现这样的火山筒。";
    
    OneMessageData *message9 = [[OneMessageData alloc] init];
    message9.dataType = TalkMessageDataImage;
    message9.My_id = @"18342788992";
    message9.SendImageUrl = @"http://172.20.10.2:3000/public/images/uploadimage/file-1670645803053.jpg";
    message9.ImageRadio = 1;
    
    
    OneMessageData *message10 = [[OneMessageData alloc] init];
    message10.dataType = TalkMessageDataText;
    message10.My_id = @"18342788992";
    message10.SendMessage = @"三种其他形式的碳被大规模制造并广泛运用于工业：它们是焦炭、炭黑和活性炭。";
    
    
    OneMessageData *message11 = [[OneMessageData alloc] init];
    message11.dataType = TalkMessageDataImage;
    message11.My_id = @"19956270227";
    message11.SendImageUrl = @"http://172.20.10.2:3000/public/images/uploadimage/file-1670596718272.jpg";
    message11.ImageRadio = 2.16;
    
    OneMessageData *message12 = [[OneMessageData alloc] init];
    message12.dataType = TalkMessageDataText;
    message12.My_id = @"19956270227";
    message12.SendMessage = @"hhh 我真的要笑死哈哈哈哈";
    
    OneMessageData *message13 = [[OneMessageData alloc] init];
    message13.dataType = TalkMessageDataImage;
    message13.My_id = @"18342788992";
    message13.SendImageUrl = @"http://172.20.10.2:3000/public/images/uploadimage/file-1670645803053.jpg";
    message13.ImageRadio = 1;
    
    OneMessageData *message14 = [[OneMessageData alloc] init];
    message14.dataType = TalkMessageDataImage;
    message14.My_id = @"18342788992";
    message14.SendImageUrl = @"http://172.20.10.2:3000/public/images/uploadimage/file-1670596737286.jpg";
    message14.ImageRadio = 0.56;
    
    
    OneMessageData *message15 = [[OneMessageData alloc] init];
    message15.dataType = TalkMessageDataCenter;
    message15.SendMessage = @"12:20";
    
    
    [AllMessage addObject:message1];
    [AllMessage addObject:message2];
    [AllMessage addObject:message3];
    [AllMessage addObject:message4];
    [AllMessage addObject:message5];
    [AllMessage addObject:message6];
    [AllMessage addObject:message7];
    [AllMessage addObject:message15];
    [AllMessage addObject:message8];
    [AllMessage addObject:message9];
    [AllMessage addObject:message10];
    [AllMessage addObject:message11];
    [AllMessage addObject:message12];
    [AllMessage addObject:message13];
    [AllMessage addObject:message14];
    
    
    //    self.message = [[MultiTalkMessageData alloc] initWithtalkRoomname:nil AllMessage:AllMessage TalkId:nil];
}



@end


