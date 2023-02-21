//
//  SetViewController.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/17.
//

#import "SetViewController.h"
#import "SetChangeCurrentUserView.h"
@interface SetViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *IconImageData;
@property  (nonatomic,strong) NSArray *IconNameData;
@end


@implementation SetViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.IconNameData = @[
        @"账号与安全",
        @"隐私设置",
        @"通用设置",
        @"通知设置",
        @"聊天设置",
        @"播放设置",
        @"背景设置",
        @"长辈模式",
        @"字体大小",
        @"反馈与帮助",
        @"了解与管理广告推送",
        @"抖音规则中心",
        @"资质证照",
        @"用户协议",
        @"隐私政策及简明版",
        @"应用权限",
        @"个人信息管理",
        @"开源软件声明",
        @"关于抖音",
        @"清理缓存",
        @"切换账号",
        @"退出登陆",
    ];
    self.IconImageData = @[
        @"person",
        @"lock",
        @"gearshape",
        @"bell",
        @"ellipsis.bubble",
        @"livephoto.play",
        @"paintpalette",
        @"figure.wave.circle",
        @"textformat",
        @"square.and.pencil",
        @"calendar.day.timeline.leading",
        @"doc.text",
        @"checkmark.seal",
        @"book",
        @"lock.doc",
        @"key.viewfinder",
        @"person.crop.rectangle.stack",
        @"point.3.filled.connected.trianglepath.dotted",
        @"exclamationmark.circle",
        @"trash",
        @"arrow.left.arrow.right",
        @"iphone.and.arrow.forward"
    ];
    self.view.backgroundColor = [UIColor whiteColor];
    [self SetNavigationBar];
    [self initTableView];
}

#pragma 设置导航栏
-(void)SetNavigationBar{
    self.title = @"设置";
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(DisMissView)]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
}


-(void)DisMissView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma 设置TableView
-(void)initTableView{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleInsetGrouped];;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 2;
    }else if(section == 1){
        return 7;
    }else if(section == 2){
        return 11;
    }else{
        return 2;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *continaerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 25)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 40, 20)];
    [continaerView addSubview:label];
    [label setTextColor:[UIColor darkGrayColor]];
    [label setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
    if(section == 0){
        [label setText:@"账号"];
    }else if(section == 1){
        [label setText:@"通用"];
    }else if(section == 2){
        [label setText:@"关于"];
    }else{
        return nil;
    }
    return continaerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 3){
        return 5;
    }
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(indexPath.section == 0){
        [cell.imageView setImage:[UIImage systemImageNamed:self.IconImageData[indexPath.row]]];
        [cell.textLabel setText:self.IconNameData[indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.section == 1){
        [cell.imageView setImage:[UIImage systemImageNamed:self.IconImageData[indexPath.row + 2]]];
        [cell.textLabel setText:self.IconNameData[indexPath.row + 2]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if(indexPath.section == 2){
        [cell.imageView setImage:[UIImage systemImageNamed:self.IconImageData[indexPath.row + 9]]];
        [cell.textLabel setText:self.IconNameData[indexPath.row + 9]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row == 10){
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        [cell.imageView setImage:[UIImage systemImageNamed:self.IconImageData[indexPath.row + 20]]];
        [cell.textLabel setText:self.IconNameData[indexPath.row + 20]];
        if(indexPath.row == 1){
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [cell.imageView setTintColor:[UIColor blackColor]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 3 && indexPath.row == 0){
        SetChangeCurrentUserView *vc = [SetChangeCurrentUserView new];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.section == 3 && indexPath.row == 1){
        // 登出
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"退出?" message:[NSString stringWithFormat:@"@%@",[AppUserData GetCurrenUser].username] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UIWindow SignOutWithProgress];
        }];
        
        [vc addAction:action1];
        [vc addAction:action2];
        [self presentViewController:vc animated:YES completion:nil];
    }
}


@end
