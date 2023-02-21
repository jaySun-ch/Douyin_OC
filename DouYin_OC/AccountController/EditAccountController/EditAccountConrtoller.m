//
//  EditAccountConrtoller.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/4.
//

#import "EditAccountConrtoller.h"
#import "EditButtonCell.h"
#import "EditAccountHeaderCell.h"
#import "ChangeBackGroundView.h"
#import "CustomImagePicker.h"
#import "EditModelView.h"
#import "DatePickerView.h"
#import "LoactionPicker.h"
#import "EditSchoolView.h"


NSString *const HeadCell = @"HeaderCell";
NSString *const NormalCell = @"NormalCell";


@interface EditAccountConrtoller()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,EditAccountHeaderDelegate,ChangeBackGroundViewDelegate>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UIButton *backbutton;
@property (nonatomic,strong) UIButton *rightbutton;
@property (nonatomic,strong) UIBarButtonItem *backitem;
@property (nonatomic,strong) UIBarButtonItem *rightitem;
@property (nonatomic,strong) NSArray  *array;
@property (nonatomic,strong) EditAccountHeaderCell *header;
@property (nonatomic,strong) ChangeBackGroundView *changeClientBackgroundView;
@property (nonatomic,strong) UIView *bigClientImageView;

@end


@implementation EditAccountConrtoller

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableview reloadData];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.array = @[@"名字",@"简介",@"性别",@"生日",@"所在地",@"学校",@"抖音号",@"主页背景",@"二维码",@"编辑服务"];
    [self initTableView];
}


-(void)initTableView{
    self.tableview = [[UITableView alloc] initWithFrame:self.view.frame];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.tableview registerClass:[EditAccountHeaderCell class] forCellReuseIdentifier:HeadCell];
    [self.tableview registerClass:[EditButtonCell class] forCellReuseIdentifier:NormalCell];
    [self.view addSubview:self.tableview];
    
    self.backbutton = [[UIButton alloc]init];
    [self.backbutton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    [self.backbutton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    self.backbutton.layer.cornerRadius = 15;
    self.backbutton.frame = CGRectMake(0, 0, 30, 30);
    [self.backbutton setTintColor:[UIColor whiteColor]];
    [self.backbutton addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
    self.backitem = [[UIBarButtonItem alloc] initWithCustomView:self.backbutton];
    
    self.rightbutton = [[UIButton alloc] init];
    [self.rightbutton setImage:[UIImage systemImageNamed:@"camera"] forState:UIControlStateNormal];
    [self.rightbutton setTitle:@"更换背景" forState:UIControlStateNormal];
    [self.rightbutton addTarget:self action:@selector(ShowSelectBackGroundViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.rightbutton setTintColor:[UIColor whiteColor]];
    [self.rightbutton.titleLabel setFont:[UIFont systemFontOfSize:13.5]];
    [self.rightbutton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [self.rightbutton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
    self.rightbutton.layer.cornerRadius = 15;
    CGSize size = [self.rightbutton.titleLabel.text singleLineSizeWithText:[UIFont systemFontOfSize:13.5]];
    self.rightbutton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.rightbutton.frame = CGRectMake(0, 0,size.width + size.height + 30,size.height + 15);
    
    self.rightitem = [[UIBarButtonItem alloc] initWithCustomView:self.rightbutton];
//    self.rightitem.width = size.width + size.height;
    
    [self.navigationItem setLeftBarButtonItem:self.backitem];
    [self.navigationItem setRightBarButtonItem:self.rightitem];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y >= 0){
        CGFloat WhitealphaRatio =  0.3f - (scrollView.contentOffset.y)/30;
        CGFloat WhitealphaRatio2 =  1.0f - (scrollView.contentOffset.y)/10;
        if(scrollView.contentOffset.y <= 1){
            if(![self.title isEqualToString:@""]) {
                self.title = @"";
            }
            [self.backbutton setTintColor:[UIColor whiteColor]];
        }else{
            if(![self.title isEqualToString:@"编辑个人资料"]) {
                self.title = @"编辑个人资料";
            }
            [self.backbutton setTintColor:[UIColor blackColor]];
        }
        self.rightbutton.alpha = WhitealphaRatio2;
        self.backbutton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:WhitealphaRatio];
    }else{
        [_header ScaleBackGroundImage:scrollView.contentOffset.y];
        self.title = @"";
        [self.backbutton setTintColor:[UIColor whiteColor]];
        self.backbutton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.rightbutton.alpha = 1;
    }
    NSLog(@"offsetY %f",scrollView.contentOffset.y);
}

- (void)DismissBackGroundView:(BOOL)isUp{
    [self DismissChangeBackgroundMode:isUp];
}

- (void)onUserActionTap:(NSInteger)tag{

    if(tag == HeaderClientBackground){
        //background
        [self initChangeBackgroundView];
    }else if(tag == HeaderClientImage){
        [self ShowAlert];
    }
}

-(void)ShowAlert{
    CustomAlertSheetView *alert =  [[CustomAlertSheetView alloc] initWithActionCount:4];
    CustomAlertAction *action1 = [[CustomAlertAction alloc] initWithStyle:@"拍一张" image:nil style:CustomAlertActionStyleDefalut SetImageRight:NO handle:^{
        
    }];
    
    CustomAlertAction *action2 = [[CustomAlertAction alloc] initWithStyle:@"相册选择" image:nil style:CustomAlertActionStyleDefalut SetImageRight:NO handle:^{
        [self ShowSelectClientImageViewController];
    }];
    
    CustomAlertAction *action3 = [[CustomAlertAction alloc] initWithStyle:@"查看大图" image:nil style:CustomAlertActionStyleDefalut SetImageRight:NO handle:^{
        [self ShowBigClientImage];
    }];
    
    CustomAlertAction *action4 = [[CustomAlertAction alloc] initWithStyle:@"取消" image:nil style:CustomAlertActionStyleCancel SetImageRight:NO handle:^{
        NSLog(@"123");
    }];
    
    [alert addCustomActions:action1];
    [alert addCustomActions:action2];
    [alert addCustomActions:action3];
    [alert addCustomActions:action4];
    [self presentPanModal:alert];
}


-(void)ShowBigClientImage{
    self.bigClientImageView = [[UIView alloc] initWithFrame:self.view.frame];
    self.bigClientImageView.backgroundColor = [UIColor blackColor];
    self.bigClientImageView.clipsToBounds = YES;
//    [self.navigationController setNavigationBarHidden:YES];
    [self.bigClientImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DismissBigClientImage)]];
    UIImageView *clientImage = [[UIImageView alloc]init];
    [clientImage setImageWithURL:[NSURL URLWithString:[AppUserData GetCurrenUser].ClientImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [clientImage setFrame:CGRectMake(0, 0, ScreenWidth,ScreenWidth)];
    clientImage.contentMode = UIViewContentModeScaleAspectFill;
    clientImage.center = self.bigClientImageView.center;
    [self.bigClientImageView addSubview:clientImage];
    
    UIButton *downButton = [[UIButton alloc] init];
    [downButton setImage:[UIImage systemImageNamed:@"arrow.down.to.line"] forState:UIControlStateNormal];
    [downButton setTintColor:[UIColor whiteColor]];
    [downButton setBackgroundColor:[UIColor darkGrayColor]];
    [downButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [CustomImagePicker SaveImageToPhotos:clientImage.image];
    }];
    [downButton setFrame:CGRectMake(ScreenWidth - 50,ScreenHeight - 100,30, 30)];
    
    [self.bigClientImageView addSubview:downButton];
    
    [self.view addSubview:self.bigClientImageView];
    self.bigClientImageView.alpha = 0;
    [UIView animateWithDuration:0.3f animations:^{
        self.bigClientImageView.alpha = 1;
    }];
}

-(void)DismissBigClientImage{
    [UIView animateWithDuration:0.3f animations:^{
        self.bigClientImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bigClientImageView removeFromSuperview];
//        [self.navigationController setNavigationBarHidden:NO];
    }];
}

-(void)initChangeBackgroundView{
    self.changeClientBackgroundView = [[ChangeBackGroundView alloc] initWithFrame:self.view.frame];
    self.changeClientBackgroundView.delegate = self;
    self.changeClientBackgroundView.alpha = 0;
    self.changeClientBackgroundView.backgroundImage.transform = CGAffineTransformMakeTranslation(0, -ScreenHeight/2);
    [self.view addSubview:self.changeClientBackgroundView];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.changeClientBackgroundView.alpha = 1;
        self.changeClientBackgroundView.backgroundImage.transform = CGAffineTransformMakeTranslation(0, 0);
        self.rightbutton.alpha = 0;
        UIButton *dismissButton = [[UIButton alloc] init];
        dismissButton.frame = CGRectMake(0, 0, 30, 30);
        [dismissButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
        [dismissButton setTintColor:[UIColor whiteColor]];
        [dismissButton addTarget:self action:@selector(DismissChangeBackgroundMode) forControlEvents:UIControlEventTouchUpInside];
        self.backitem = [[UIBarButtonItem alloc] initWithCustomView:dismissButton];
        [self.navigationItem setLeftBarButtonItem:self.backitem];
    } completion:nil];
}

-(void)DismissChangeBackgroundMode:(BOOL)isUp{
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.rightbutton.alpha = 1;
        if(isUp){
            self.changeClientBackgroundView.backgroundImage.transform = CGAffineTransformMakeTranslation(0, ScreenHeight);
        }else{
            self.changeClientBackgroundView.backgroundImage.transform = CGAffineTransformMakeTranslation(0, -ScreenHeight/2);
        }
        self.backbutton = [[UIButton alloc]init];
        [self.backbutton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
        [self.backbutton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        self.backbutton.layer.cornerRadius = 15;
        self.backbutton.frame = CGRectMake(0, 0, 30, 30);
        [self.backbutton setTintColor:[UIColor whiteColor]];
        [self.backbutton addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
        self.backitem = [[UIBarButtonItem alloc] initWithCustomView:self.backbutton];
        [self.navigationItem setLeftBarButtonItem:self.backitem animated:NO];
        self.changeClientBackgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.changeClientBackgroundView removeFromSuperview];
    }];
}

- (void)ShowSelectBackGroundViewController{
    CustomImagePicker *newvc = [CustomImagePicker new];
    newvc.modalPresentationStyle = UIModalPresentationPageSheet;
    [newvc.view setBackgroundColor:[UIColor whiteColor]];
    newvc.type = PickerImageClientBackground;
    [self presentViewController:newvc animated:YES completion:nil];
}

- (void)ShowSelectClientImageViewController{
    CustomImagePicker *newvc = [CustomImagePicker new];
    newvc.modalPresentationStyle = UIModalPresentationPageSheet;
    [newvc.view setBackgroundColor:[UIColor whiteColor]];
    newvc.type = PickerImageClientImage;
    [self presentViewController:newvc animated:YES completion:nil];
}

-(void)DismissChangeBackgroundMode{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.rightbutton.alpha = 1;
        self.changeClientBackgroundView.backgroundImage.transform = CGAffineTransformMakeTranslation(0, -ScreenHeight/2);
        self.backbutton = [[UIButton alloc]init];
        [self.backbutton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
        [self.backbutton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];
        self.backbutton.layer.cornerRadius = 15;
        self.backbutton.frame = CGRectMake(0, 0, 30, 30);
        [self.backbutton setTintColor:[UIColor whiteColor]];
        [self.backbutton addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
        self.backitem = [[UIBarButtonItem alloc] initWithCustomView:self.backbutton];
        [self.navigationItem setLeftBarButtonItem:self.backitem animated:NO];
        self.changeClientBackgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.changeClientBackgroundView removeFromSuperview];
    }];
}


-(void)GoBack{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    
    if(indexPath.section == 0 && indexPath.row == 1){
        EditModelView *newvc = [[EditModelView alloc] init];
        newvc.title = @"修改名字";
        [self.navigationController pushViewController:newvc animated:YES];
    }
    
    if(indexPath.section == 0 && indexPath.row == 2){
        EditModelView *newvc = [[EditModelView alloc] init];
        newvc.title = @"修改简介";
        [self.navigationController pushViewController:newvc animated:YES];
    }
    
    if(indexPath.section == 1 && indexPath.row == 0){
        [self showChangeSexAlert];
    }
    
    if(indexPath.section == 1 && indexPath.row == 1){
        // Date
        DatePickerView *newvc = [DatePickerView new];
        [self presentPanModal:newvc];
    }
    
    if(indexPath.section == 1 && indexPath.row == 2){
        //Location
        LoactionPicker *newvc = [LoactionPicker new];
        [self presentPanModal:newvc];
    }
    
    if(indexPath.section == 1 && indexPath.row == 3){
        //学校
        EditSchoolView *view = [EditSchoolView new];
        [self.navigationController pushViewController:view animated:YES];
    }
    
    if(indexPath.section == 2 && indexPath.row == 0){
        EditModelView *newvc = [[EditModelView alloc] init];
        newvc.title = @"修改抖音号";
        [self.navigationController pushViewController:newvc animated:YES];
    }
    
    if(indexPath.section == 2 && indexPath.row == 1){
        [self initChangeBackgroundView];
    }
    
    if(indexPath.section == 2 && indexPath.row == 2){
        UIViewController *newvc = [UIViewController new];
        newvc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:newvc animated:YES];
    }
    
    if(indexPath.section == 2 && indexPath.row == 3){
        UIViewController *newvc = [UIViewController new];
        newvc.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:newvc animated:YES];
    }
    
}

-(void)reloadProgressView{
    EditAccountHeaderCell *cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell UpdateProgress];
}

-(void)showChangeSexAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(![[AppUserData GetCurrenUser].sex isEqualToString:@"男"]){
            [self ChangeSex:@"男"];
        }
        [self reloadProgressView];
        [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(![[AppUserData GetCurrenUser].sex isEqualToString:@"女"]){
            [self ChangeSex:@"女"];
        }
        [self reloadProgressView];
        [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"暂不设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(![[AppUserData GetCurrenUser].sex isEqualToString:@""]){
            [self ChangeSex:@""];
        }
        [self reloadProgressView];
        [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [alert addAction:action4];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)ChangeSex:(NSString *)sex{
    ClientData *data = [AppUserData GetCurrenUser];
    data.sex = sex;
    [AppUserData SavCurrentUser:data];
    ChangeClientMessageRequest *request = [ChangeClientMessageRequest new];
    request.PhoneNumber = [AppUserData GetCurrenUser].phoneNumber;
    request.ChangeMessageName = @"sex";
    request.ChangeContend = data.sex;
    [UIWindow ShowLoadNoAutoDismiss];
    [ClientData SaveUserToServerWithRequest:request responsedata:^(SuccessResponse *responsedata) {
        if(responsedata == nil){
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"保存失败,请重试"];
            }];
        }else{
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"保存成功"];
                [AppUserData  SavCurrentUser:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 3;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 && indexPath.section == 0){
        return 260;
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 && indexPath.section == 0){
        EditAccountHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:HeadCell forIndexPath:indexPath];
        _header = cell;
        cell.delegate = self;
        [cell initSubView];
        return cell;
    }else{
        EditButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.section == 2){
            [cell initWithTitleAndMessage:self.array[6 + indexPath.row] message:@"花海"];
        }else{
            [cell initWithTitleAndMessage:self.array[indexPath.section*3 + indexPath.row - 1] message:@"花海"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section < 2){
        return 50.0;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section < 2){
        UIView *fotterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        background.backgroundColor = [UIColor whiteColor];
        [fotterView addSubview:background];
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(15, 19, ScreenWidth - 30, 1)];
        lineview.backgroundColor = [UIColor systemGray5Color];
        [fotterView addSubview:lineview];
        return fotterView;
    }else{
        return nil;
    }
  
}

@end
