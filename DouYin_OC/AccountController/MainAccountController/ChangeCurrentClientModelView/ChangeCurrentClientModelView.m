//
//  ChangeCurrentClientModelView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//


#import "ChangeCurrentClientModelView.h"
#import "SignViewController.h"
#import "MainTableCell.h"
#import "AddTableCell.h"

#define CellHeight 80
@interface ChangeCurrentClientModelView()<HWPanModalPresentable,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) AppUserData * alluser;
@property (nonatomic,strong) UITableView *tableview;

@end

@implementation ChangeCurrentClientModelView

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
}

-(void)initTableView{
    self.alluser = [AppUserData GetAllUser];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, (self.alluser.AllUser.count + 1) * CellHeight)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview setScrollEnabled:NO];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[MainTableCell class] forCellReuseIdentifier:@"cell1"];
    [self.tableview registerClass:[AddTableCell class] forCellReuseIdentifier:@"cell2"];
    [self.view addSubview:self.tableview];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,10, 40, 4)];
    lineView.layer.cornerRadius = 2;
    lineView.centerX = ScreenWidth / 2;
    lineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.alluser.AllUser.count+1;
}

- (BOOL)showDragIndicator{
    return false;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row < self.alluser.AllUser.count){
        MainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell SetData:self.alluser.AllUser[indexPath.row].ClientImageUrl name:self.alluser.AllUser[indexPath.row].username subtitle:[NSString stringWithFormat:@"%ld粉丝 . %ld朋友",self.alluser.AllUser[indexPath.row].fansList.count,self.alluser.AllUser[indexPath.row].FriendList.count] iscurrent:self.alluser.AllUser[indexPath.row].IsSign ? YES:NO];
        return cell;
    }else{
        AddTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row < self.alluser.AllUser.count){
        if(!self.alluser.AllUser[indexPath.row].IsSign){
            [AppUserData SignWithUser:indexPath.row];
            [self dismissViewControllerAnimated:YES completion:^{
                [UIWindow showTips:[NSString stringWithFormat:@"已经切换到%@的账号",self.alluser.AllUser[indexPath.row].username]];
            }];
        }
    }else{
        if(self.alluser.AllUser.count < 3){
            UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:[SignViewController new]];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            [UIWindow showTips:@"最多只能添加三个账号哦"];
        }
    }
}

-(PanModalHeight)longFormHeight{
    return PanModalHeightMake(PanModalHeightTypeContent,((self.alluser.AllUser.count + 1) * CellHeight + 10));
}
@end
