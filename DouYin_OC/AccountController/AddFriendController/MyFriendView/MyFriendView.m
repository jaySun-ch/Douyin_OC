//
//  MyFriendView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//

#import "MyFriendView.h"
#import "RecommendClientCell.h"
#import "TalkViewController.h"


@interface MyFriendView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UISearchBarDelegate,RecommendClientCellDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *TopBar;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) MyFriendDetialResponse *alldata;
@property (nonatomic,strong) CustomLoadView *LoadView;

@end


@implementation MyFriendView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initTableView];
        [self initSearchBar];
    }
    return self;
}

-(void)ViewDidAppear{
    [self GetData];
}


-(void)GetData{
    if([AppUserData GetCurrenUser].FriendList.count != self.alldata.msg.count){
        [self.LoadView removeFromSuperview];
        self.LoadView = [[CustomLoadView alloc] init];
        self.LoadView.centerX = ScreenWidth / 2;
        [self.tableView addSubview:self.LoadView];
        GetClientNameAndImageRequest *quest = [GetClientNameAndImageRequest new];
        quest.MyID = [AppUserData GetCurrenUser]._id;
        [NetWorkHelper getWithUrlPath:GetFriendListDetialPath request:quest success:^(id data) {
            self.alldata = [[MyFriendDetialResponse alloc] initWithDictionary:data error:nil];
            NSLog(@"%@ MyFriendDetialResponse",self.alldata);
            [self.LoadView removeFromSuperview];
            [self.tableView reloadData];
        } faliure:^(NSError *error) {
            [UIWindow showTips:@"服务器走神了哦"];
        }];
    }
}


//-(void)PrintData{
//    [self.LoadView removeFromSuperview];
//    [self.tableView reloadData];
//    NSLog(@"%@ PrintData",self.alldata);
//}

#pragma 设置SearchBar
-(void)initSearchBar{
    self.TopBar = [[UIView alloc] init];
    self.TopBar.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.TopBar];
    
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.delegate  = self;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.searchTextField.delegate = self;
    self.searchBar.searchTextField.backgroundColor = [UIColor colorNamed:@"lightgray"];
    self.searchBar.placeholder = [NSString stringWithFormat:@"%ld位朋友",[AppUserData GetCurrenUser].FriendList.count];
    [self.TopBar addSubview:self.searchBar];
    
    [self.TopBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.TopBar);
        make.left.right.equalTo(self.TopBar).inset(15);
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    [self.searchBar setPlaceholder:@"搜索用户名字/抖音号"];
    for(UIView *subView in self.searchBar.subviews){
        for(UIView *subview2 in subView.subviews){
            // 这一层View
            for(UIView *subview3 in subview2.subviews){
                // 这一层分为Backgrounround 和 continaer
                if([subview3 isKindOfClass:UIButton.class]){
                    UIButton *button = (UIButton *)subview3;
                    [button setTitle:@"取消" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(CancleSearch) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
    return YES;
}

-(void)CancleSearch{
    [self.searchBar setPlaceholder:@"5位朋友"];
    [self.searchBar.searchTextField resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self CancleSearch];
    return YES;
}


#pragma 设置tableView
-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, self.size.width, self.size.height)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[RecommendClientCell class] forCellReuseIdentifier:@"recommend"];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.alldata.msg.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"朋友";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommendClientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommend" forIndexPath:indexPath];
    cell.delegate = self;
    [cell.clientImage setImageWithURL:[NSURL URLWithString:self.alldata.msg[indexPath.row].ClientImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [cell.clientName setText:self.alldata.msg[indexPath.row].username];
    [cell.subtitle setText:self.alldata.msg[indexPath.row].introduce];
    [cell SetCellWithType:RecommendClientCellChat];
    cell.MyIndex = indexPath;
    return cell;
}

- (void)DidTapWithTag:(NSInteger)tag index:(NSIndexPath *)index{
    if(tag == RecommendButtonChat){
        TalkViewController *vc = [[TalkViewController alloc] init];
        vc.ClientImagurl = self.alldata.msg[index.row].ClientImageUrl;
        vc.ClientName = self.alldata.msg[index.row].username;
        vc.ClientId = [AppUserData GetCurrenUser].FriendList[index.row].Id;
        [UIWindow PushController:vc];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
