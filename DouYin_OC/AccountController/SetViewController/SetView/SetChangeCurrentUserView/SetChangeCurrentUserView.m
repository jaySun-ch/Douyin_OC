//
//  SetChangeCurrentUserView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/18.
//

#import "SetChangeCurrentUserView.h"
#import "SignViewController.h"
#import "MainTableCell.h"
#import "AddTableCell.h"

#define CellHeight 80
@interface SetChangeCurrentUserView()<UITableViewDelegate,UITableViewDataSource,MainTableCellDelegate>
@property (nonatomic,strong) AppUserData * alluser;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,assign) BOOL IsEditMode;
@end

@implementation SetChangeCurrentUserView

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.alluser = [AppUserData GetAllUser];
    [self.tableview reloadData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.IsEditMode = NO;
    [self.navigationItem setHidesBackButton:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"切换账号";
    [self initTableView];
    [self SetNavigationBar];
}

-(void)SetNavigationBar{
    self.title = @"切换账号";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(DisMissView)]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(StartEditMode)]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
}

-(void)DisMissView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)StartEditMode{
    self.IsEditMode = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.title = @"账号管理";
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(FinishEdit)]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    [self.tableview reloadData];
    [self EditMode];
}

-(void)EditMode{
    AddTableCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.alluser.AllUser.count inSection:0]];
    cell.alpha = 0.5;
    for(NSInteger i = 0;i<self.alluser.AllUser.count;i++){
        MainTableCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(self.alluser.AllUser[i].IsSign){
            cell.alpha = 0.5;
        }
    }
}
-(void)FinishEdit{
    self.IsEditMode = NO;
    [self SetNavigationBar];
    [self.tableview reloadData];
}

- (void)DidTapOnRemoveButton:(NSIndexPath *)CellIndex{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定退出此账号吗？" message:@"以仅清除本地登陆记录,不会注销此账号" preferredStyle:UIAlertControllerStyleAlert];
    alert.view.tintColor = [UIColor blackColor];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [AppUserData RemoveUser:CellIndex.row];
        self.alluser = [AppUserData GetAllUser];
        [self.tableview deleteRow:CellIndex.row inSection:CellIndex.section withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableview reloadData];
        [self EditMode];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)initTableView{
    self.alluser = [AppUserData GetAllUser];
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth,ScreenHeight)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
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
        cell.delegate = self;
        cell.index = indexPath;
        if(!self.IsEditMode){
            cell.CheckButton.hidden = NO;
            cell.RemoveButton.hidden = YES;
            [cell setUserInteractionEnabled:YES];
            cell.alpha = 1;
        }else{
            if(self.alluser.AllUser[indexPath.row].IsSign){
                // 如果是当前登陆的
                cell.CheckButton.hidden = NO;
                cell.RemoveButton.hidden = YES;
                [cell setUserInteractionEnabled:NO];
            }else{
                cell.CheckButton.hidden = YES;
                cell.RemoveButton.hidden = NO;
                [cell setUserInteractionEnabled:YES];
            }
        }
        [cell SetData:self.alluser.AllUser[indexPath.row].ClientImageUrl name:self.alluser.AllUser[indexPath.row].username subtitle:[NSString stringWithFormat:@"%ld粉丝 . %ld朋友",self.alluser.AllUser[indexPath.row].fansList.count,self.alluser.AllUser[indexPath.row].FriendList.count] iscurrent:self.alluser.AllUser[indexPath.row].IsSign ? YES:NO];
        return cell;
    }else{
        AddTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        if(self.IsEditMode){
            [cell setUserInteractionEnabled:NO];
        }else{
            [cell setUserInteractionEnabled:YES];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(!self.IsEditMode){
        if(indexPath.row < self.alluser.AllUser.count){
            if(!self.alluser.AllUser[indexPath.row].IsSign){
                [UIWindow ShowProgreeViewWithTitle:@"正在切换账号中"];
                [AppUserData SignWithUser:indexPath.row];
                [self performSelector:@selector(PopToRoot) afterDelay:1.0f];
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
    
}

-(void)PopToRoot{
    [UIWindow DismissProgressViewNormal];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [UIWindow showTips:[NSString stringWithFormat:@"已经切换到%@的账号",[AppUserData GetCurrenUser].username]];

}
@end
