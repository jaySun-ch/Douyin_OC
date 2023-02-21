//
//  NewFriendView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//

#import "NewFriendView.h"
#import "RecommendClientCell.h"


@interface NewFriendView()<UITableViewDelegate,UITableViewDataSource>
// 粉丝列表 展示谁关注了你
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NewFriendDetialResponse *alldata;
@property (nonatomic,strong)  CustomLoadView *LoadView;


@end


@implementation NewFriendView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initTableView];
        
    }
    return self;
}

-(void)ViewDidAppear{
    [self GetData];
}

-(void)GetData{
    if([AppUserData GetCurrenUser].fansList.count != self.alldata.msg.count){
        [self.LoadView removeFromSuperview];
        self.LoadView = [[CustomLoadView alloc] init];
        self.LoadView.centerX = ScreenWidth / 2;
        [self addSubview:self.LoadView];
        GetClientNameAndImageRequest *quest = [GetClientNameAndImageRequest new];
        quest.MyID = [AppUserData GetCurrenUser]._id;
        [NetWorkHelper getWithUrlPath:GetFansListDetialPath request:quest success:^(id data) {
            self.alldata = [[NewFriendDetialResponse alloc] initWithDictionary:data error:nil];
            NSLog(@"%@ NewFriendDetialResponse",data);
            [self.LoadView removeFromSuperview];
            [self.tableView reloadData];
        } faliure:^(NSError *error) {
            [UIWindow showTips:@"服务器走神了哦"];
        }];
    }
}


-(void)PrintData{
    [self.LoadView removeFromSuperview];
    [self.tableView reloadData];
    NSLog(@"%@ PrintData",self.alldata);
}

#pragma 设置tableView
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.size.width, self.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[RecommendClientCell class] forCellReuseIdentifier:@"recommend"];
    [self addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.alldata.msg.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommendClientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommend" forIndexPath:indexPath];
    [cell.clientImage setImageWithURL:[NSURL URLWithString:self.alldata.msg[indexPath.row].ClientImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [cell.clientName setText:self.alldata.msg[indexPath.row].username];
    [cell.subtitle setText:[NSString stringWithFormat:@"关注了你 %@",[self.alldata.msg[indexPath.row].CreateDate GetConcernTime]]];
    // 经常聊天的是戳一戳 相互关注的是已关注 还没有关注的是关注/回关
    if(self.alldata.msg[indexPath.row].isFriend){
        // 代表了你们相互关注了
        [cell SetCellWithType:RecommendClientCellHasConcern];//戳一戳
    }else{
        [cell SetCellWithType:RecommendClientCellConcern];
        [cell.concernButton setTitle:@"回关" forState:UIControlStateNormal];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
