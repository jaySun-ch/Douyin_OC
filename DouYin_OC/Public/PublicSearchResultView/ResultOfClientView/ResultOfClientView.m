//
//  ResultOfClientView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//

#import "ResultOfClientView.h"
#import "RecommendClientCell.h"

@interface ResultOfClientView()<UITableViewDelegate,UITableViewDataSource,RecommendClientCellDelegate,PDConcernSendSocketDelegate>
@property (nonatomic,strong) NSString *SearchText;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray<SearchClientData *> <SearchClientData> *data;
@property (nonatomic,strong) CustomLoadView *LoadView;
@end

@implementation ResultOfClientView

- (instancetype)initWithFrame:(CGRect)frame SearchText:(NSString *)SearchText{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self.tableView registerClass:[RecommendClientCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
        [self ReloadDataWith:SearchText];
        [[PDSocketManager shared] SetConcernSenddelegateWithDelgate:self];
    }
    return self;
}

-(void)ReloadDataWith:(NSString *)searchText{
    [self.LoadView removeFromSuperview];
    self.tableView.alpha = 0;
    self.LoadView = [CustomLoadView new];
    self.LoadView.center = CGPointMake(ScreenWidth / 2, self.size.height / 2);
    [self addSubview:self.LoadView];
    self.SearchText = searchText;
    SearchClientRequest *request= [SearchClientRequest new];
    request.searchText = self.SearchText;
    request.MyID = [AppUserData GetCurrenUser]._id;
    [NetWorkHelper getWithUrlPath:SearchClientPath request:request success:^(id data) {
        SearchClientResponse *response = [[SearchClientResponse alloc] initWithDictionary:data error:nil];
        if(response.msg.count != 0){
            self.data = response.msg;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.LoadView removeFromSuperview];
                [self.tableView reloadData];
                [self AnimationShow];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.LoadView removeFromSuperview];
                [self AnimationShow];
            });
        }
    } faliure:^(NSError *error) {
        [self.LoadView removeFromSuperview];
        [UIWindow showTips:@"服务器走神了哦"];
        [self AnimationShow];
    }];
}

-(void)AnimationShow{
    [UIView animateWithDuration:0.15f animations:^{
        self.tableView.alpha = 1;
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommendClientCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.MyIndex = indexPath;
    [cell.clientImage setImageWithURL:[NSURL URLWithString:self.data[indexPath.row].ClientImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [cell.clientName setText:self.data[indexPath.row].username];
    [cell.subtitle setText:[NSString stringWithFormat:@"粉丝量:%ld", self.data[indexPath.row].fanscount]];
    
    if([self.data[indexPath.row]._id isEqualToString:[AppUserData GetCurrenUser]._id] ){
        [cell SetCellWithType:-1];
    }else if(self.data[indexPath.row].HasConcern){
        [cell SetCellWithType:RecommendClientCellHasConcern];
    }else{
        [cell SetCellWithType:RecommendClientCellSearchConcern];
    }
    [cell.downLabel setText:[NSString stringWithFormat:@"抖音号:%@",self.data[indexPath.row].uid]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)DidTapWithTag:(NSInteger)tag index:(NSIndexPath*)index{
    if(tag == RecommendButtonConcern){
        [UIWindow ShowLoadNoAutoDismiss];
        AddConcernRequest *request = [AddConcernRequest new];
        request.MyID = [AppUserData GetCurrenUser]._id;
        request.ConcernObjectID = self.data[index.row]._id;
        [NetWorkHelper getWithUrlPath:AddConcernPath request:request success:^(id data) {
            SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
            if([response.status isEqualToString:@"faliure"]){
                [UIWindow DissMissLoadWithBlock:^{
                    [UIWindow showTips:@"关注失败"];
                }];

            }else{
                self.data[index.row].HasConcern = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIWindow DissMissLoadWithBlock:^{
                        [UIWindow showTips:@"关注成功"];
                    }];
                    // 将这个关注的人添加进入来
                    ClientData *data = [AppUserData GetCurrenUser];
                    ConcernListData *newConcern = [[ConcernListData alloc]init];
                    newConcern.CreateDate = [NSDate date];
                    newConcern.Id = self.data[index.row]._id;
                    NSMutableArray *newarry = [NSMutableArray arrayWithArray:data.concernList];
                    [newarry addObject:newConcern];
                    data.concernList = [newarry copy];
                    // 加入到关注列表里面来之后 还要判断这个是否在我的粉丝列表里面
                    if(data.fansList.count != 0){
                        for(ConcernListData *item in data.fansList){
                            if([item.Id isEqualToString:self.data[index.row]._id]){
                                // 代表这个人可以成为我的好友了
                                data.FriendList = [newarry copy];
                            }
                        }
                    }
                    [AppUserData SavCurrentUser:data];
                  
                    [self.tableView reloadRowAtIndexPath:index withRowAnimation:UITableViewRowAnimationNone];
                });
                [[PDSocketManager shared] SendObjectConcernWithConcernObjectId:self.data[index.row]._id MyID:[AppUserData GetCurrenUser]._id MyName:[AppUserData GetCurrenUser].username];
            }
        } faliure:^(NSError *error) {
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"关注失败"];
            }];
        }];
    }
}

- (void)DidSendConcernWithCallBack:(NSString *)callBack{
    if([callBack isEqualToString:@"DidReceived"]){
        [UIWindow showTips:@"关注成功"];
    }else{
        [UIWindow showTips:@"关注失败"];
    }
}

@end
