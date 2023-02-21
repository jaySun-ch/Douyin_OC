//
//  EditSchoolView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/8.
//

#import "EditSchoolView.h"
#import "EditSchoolTablCell.h"
#import "SelectSchoolView.h"
#import "SelectMajorView.h"
#import "SeletTimeView.h"

@interface EditSchoolView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UIButton *MakeSureButton;
@property (nonatomic,strong) NSArray *editarray;
@property (nonatomic,strong) NSString *lastSchool;
@end


@implementation EditSchoolView

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self.navigationController;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    EditSchoolTablCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    self.lastSchool = cell.message.text;
    if(![[AppUserData GetCurrenUser].school isEqualToString:cell.message.text]){
        // 没有change
        self.MakeSureButton.alpha = 1;
        [self.MakeSureButton setEnabled:YES];
    }else{
        self.MakeSureButton.alpha = 0.3;
        [self.MakeSureButton setEnabled:NO];
    }
    [self.tableview reloadData];
}


- (void)viewDidLoad{
    self.editarray = @[@"学校",@"院系",@"入学时间",@"学历",@"展示范围"];
    [super viewDidLoad];
    [self initTableView];
    [self initMakeSureButton];
    [self initNavigationBar];
}

-(void)initNavigationBar{
    self.title = @"添加学校";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(dissmissView)]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
}

-(void)dissmissView{
    if(self.MakeSureButton.isEnabled){
        [self ShowAlert];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)initTableView{
    self.tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableview registerClass:[EditSchoolTablCell class] forCellReuseIdentifier:@"editcell"];
    [self.view addSubview:self.tableview];
}

-(void)initMakeSureButton{
    self.MakeSureButton = [[UIButton alloc] init];
    self.MakeSureButton.backgroundColor = [UIColor redColor];
    [self.MakeSureButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.MakeSureButton setAlpha:0.3];
    [self.MakeSureButton setEnabled:NO];
    self.MakeSureButton.layer.cornerRadius = 5;
    [self.MakeSureButton addTarget:self action:@selector(SaveData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.MakeSureButton];
    [self.MakeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).inset(50);
        make.left.equalTo(self.view).inset(15);
        make.right.equalTo(self.view).inset(15);
        make.width.mas_equalTo(ScreenWidth-30);
        make.height.mas_equalTo(40);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 20;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 9,ScreenWidth - 20, 1)];
        lineview.backgroundColor =[UIColor colorNamed:@"lightgray"];
        [footerview addSubview:lineview];
        return footerview;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        EditSchoolTablCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editcell" forIndexPath:indexPath];
        if(indexPath.row == 0 && ![[AppUserData GetCurrenUser].school isEqualToString:@""]){
            [cell SetData:self.editarray[indexPath.row] message:[AppUserData GetCurrenUser].school];
        }else{
            [cell SetData:self.editarray[indexPath.row] message:@"点击设置"];
        }
        return cell;
    }else{
        EditSchoolTablCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editcell" forIndexPath:indexPath];
        [cell SetData:self.editarray.lastObject message:@"公开可见"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 0){
        SelectSchoolView *view = [SelectSchoolView new];
        [self.navigationController pushViewController:view animated:YES];
    }else if(indexPath.section == 0 && indexPath.row == 1){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if([cell.textLabel.text isEqualToString:@"点击设置"]){
            [UIWindow showTips:@"请先设置学校"];
        }else{
            SelectMajorView *view = [SelectMajorView new];
            [self.navigationController pushViewController:view animated:YES];
        }
    }else if(indexPath.section == 0 && indexPath.row == 2){
        SeletTimeView *view = [SeletTimeView new];
        [self presentPanModal:view];
    }else if(indexPath.section == 0 && indexPath.row == 3){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置学历" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"专科" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"本科" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"硕士" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"博士" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [alert addAction:action4];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"设置可见范围" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"公开可见" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"校友可见" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"仅自己可见" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(self.MakeSureButton.isEnabled){
        [self ShowAlert];
        return NO;
    }else{
        return YES;
    }
}

-(void)ShowAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"学校信息30天内只允许修改一次,是否保存修改" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert.view setTintColor:[UIColor blackColor]];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ClientData *data = [AppUserData GetCurrenUser];
        data.school = self.lastSchool;
        [AppUserData SavCurrentUser:data];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self SaveData];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)SaveData{
    ClientData *data = [AppUserData GetCurrenUser];
    ChangeClientMessageRequest *request = [ChangeClientMessageRequest new];
    request.PhoneNumber = [AppUserData GetCurrenUser].phoneNumber;
    request.ChangeMessageName = @"school";
    request.ChangeContend = data.school;
    [UIWindow ShowLoadNoAutoDismiss];
    [ClientData SaveUserToServerWithRequest:request responsedata:^(SuccessResponse *responsedata) {
        if(responsedata == nil){
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"保存失败,请重试"];
            }];
        }else{
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"保存成功"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }
    }];
}

@end
