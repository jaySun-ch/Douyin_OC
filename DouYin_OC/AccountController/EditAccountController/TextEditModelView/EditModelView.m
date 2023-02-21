//
//  EditModelView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/6.
//

#import "EditModelView.h"

@interface EditModelView()<UITextFieldDelegate,YYTextViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIButton *SaveButton;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UITextField *textfiled;
@property (nonatomic,strong) UILabel *sublabel;
@property (nonatomic,strong) UILabel *countLimit;
@property (nonatomic,strong) YYTextView *textview;
@end

@implementation EditModelView

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self.navigationController;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self SetNavigationBar];
    [self initSubViews];
}


-(void)SetNavigationBar{
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissview)]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    self.SaveButton = [[UIButton alloc] init];
    [self.SaveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.SaveButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.SaveButton setEnabled:NO];
    [self.SaveButton setAlpha:0.3];
    [self.SaveButton addTarget:self action:@selector(Save) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:self.SaveButton]];
}

-(void)Save{
    ClientData *data = [AppUserData GetCurrenUser];
    if([self.title isEqualToString:@"修改简介"]){
        if(![data.introduce isEqualToString:self.textview.text]){
            [self SaveChange];
        }
    }else if([self.title isEqualToString:@"修改名字"]){
        if(![data.username isEqualToString:self.textfiled.text]){
            [self SaveChange];
        }
    }else{
        if(![data.uid isEqualToString:self.textfiled.text]){
            [self SaveChange];
        }
    }
}

-(void)SaveChange{
    ClientData *data = [AppUserData GetCurrenUser];
    ChangeClientMessageRequest *request = [ChangeClientMessageRequest new];
    request.PhoneNumber = [AppUserData GetCurrenUser].phoneNumber;
    if([self.title isEqualToString:@"修改简介"]){
        data.introduce = self.textview.text;
        request.ChangeMessageName = @"introduce";
        request.ChangeContend = self.textview.text;
    }else if([self.title isEqualToString:@"修改名字"]){
        data.username = self.textfiled.text;
        request.ChangeMessageName = @"username";
        request.ChangeContend = self.textfiled.text;
    }else{
        data.uid = self.textfiled.text;
        request.ChangeMessageName = @"uid";
        request.ChangeContend = self.textfiled.text;
    }
    [UIWindow ShowLoadNoAutoDismiss];
    [ClientData SaveUserToServerWithRequest:request responsedata:^(SuccessResponse *responsedata) {
        if(responsedata == nil){
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"保存失败,请重试"];
            }];
        }else{
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"保存成功"];
                [AppUserData SavCurrentUser:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
        }
    }];
   
}

-(void)initSubViews{
    if([self.title isEqualToString:@"修改简介"]){
        [self initChangeIntroduce];
    }else if([self.title isEqualToString:@"修改名字"]){
        [self initChangeName];
    }else{
        [self initChangeUid];
    }
    
    [self performSelector:@selector(showKeyBoard) withObject:nil afterDelay:0.5f];
}

-(void)initChangeIntroduce{
    self.textview = [[YYTextView alloc] init];
    self.textview.delegate = self;
    [self.textview setScrollEnabled:NO];
    [self.textview setFont:[UIFont systemFontOfSize:18.0]];
    [self.textview setPlaceholderText:@"添加简介,让大家更好的认识你"];
    [self.textview setText:[AppUserData GetCurrenUser].introduce];
    [self.view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view).inset(10);
        make.width.mas_equalTo(ScreenWidth - 20);
        make.height.mas_equalTo(300);
    }];
}

-(void)initChangeName{
    self.label = [[UILabel alloc] init];
    [self.label setText:@"我的名字"];
    [self.label setTextColor:[UIColor lightGrayColor]];
    [self.label setFont:[UIFont systemFontOfSize:13.0]];
    [self.view addSubview:self.label];
    
    self.textfiled = [[UITextField alloc] init];
    [self.textfiled setPlaceholder:@"记得填写昵称"];
    [self.textfiled setDelegate:self];
    [self.textfiled setText:[AppUserData GetCurrenUser].username];
    [self.view addSubview:self.textfiled];
    
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = [UIColor colorNamed:@"lightgray"];
    [self.view addSubview:lineview];
    
    self.sublabel = [[UILabel alloc]init];
    [self.sublabel setTextColor:[UIColor lightGrayColor]];
    [self.sublabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.sublabel setText:@"名字30天内可以修改4次，2023-01-25前还可以修改4次"];
    [self.view addSubview:self.sublabel];
    
    self.countLimit = [[UILabel alloc] init];
    [self.countLimit setTextColor:[UIColor lightGrayColor]];
    [self.countLimit setFont:[UIFont systemFontOfSize:13.0]];
    [self.countLimit setText:[NSString stringWithFormat:@"%ld/16",[AppUserData GetCurrenUser].username.length]];
    [self.view addSubview:self.countLimit];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).inset(100);
        make.left.equalTo(self.view).inset(10);
        make.height.mas_equalTo(15);
    }];
    
    [self.textfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).inset(10);
        make.left.equalTo(self.view).inset(10);
        make.right.equalTo(self.view).inset(10);
        make.height.mas_equalTo(30);
    }];
    
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textfiled.mas_bottom).inset(5);
        make.left.equalTo(self.view).inset(10);
        make.right.equalTo(self.view).inset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.sublabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview.mas_bottom).inset(10);
        make.left.equalTo(self.view).inset(10);
        make.height.mas_equalTo(15);
    }];
    
    [self.countLimit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview.mas_bottom).inset(10);
        make.right.equalTo(self.view).inset(10);
        make.height.mas_equalTo(15);
    }];
}

-(void)initChangeUid{
    self.label = [[UILabel alloc] init];
    [self.label setText:@"修改抖音号"];
    [self.label setTextColor:[UIColor lightGrayColor]];
    [self.label setFont:[UIFont systemFontOfSize:13.0]];
    [self.view addSubview:self.label];
    self.textfiled = [[UITextField alloc] init];
    [self.textfiled setPlaceholder:@""];
    [self.textfiled setDelegate:self];
    [self.textfiled setText:[AppUserData GetCurrenUser].uid];
    [self.view addSubview:self.textfiled];
    
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = [UIColor colorNamed:@"lightgray"];
    [self.view addSubview:lineview];
    
    self.sublabel = [[UILabel alloc]init];
    [self.sublabel setTextColor:[UIColor lightGrayColor]];
    [self.sublabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.sublabel setText:@"只允许包含字母、数字、下划线和点，180天内仅能修改一次"];
    [self.view addSubview:self.sublabel];
    
    self.countLimit = [[UILabel alloc] init];
    [self.countLimit setTextColor:[UIColor lightGrayColor]];
    [self.countLimit setFont:[UIFont systemFontOfSize:13.0]];
    [self.countLimit setText:[NSString stringWithFormat:@"%ld/16",[AppUserData GetCurrenUser].uid.length]];
    [self.view addSubview:self.countLimit];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).inset(100);
        make.left.equalTo(self.view).inset(10);
        make.height.mas_equalTo(15);
    }];
    
    [self.textfiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).inset(10);
        make.left.equalTo(self.view).inset(10);
        make.right.equalTo(self.view).inset(10);
        make.height.mas_equalTo(30);
    }];
    
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textfiled.mas_bottom).inset(5);
        make.left.equalTo(self.view).inset(10);
        make.right.equalTo(self.view).inset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.sublabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview.mas_bottom).inset(10);
        make.left.equalTo(self.view).inset(10);
        make.height.mas_equalTo(15);
    }];
    
    [self.countLimit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview.mas_bottom).inset(10);
        make.right.equalTo(self.view).inset(10);
        make.height.mas_equalTo(15);
    }];
}

-(void)showKeyBoard{
    if([self.title isEqualToString:@"修改简介"]){
        [self.textview becomeFirstResponder];
    }else{
        [self.textfiled becomeFirstResponder];
    }
}

- (void)textFieldDidChangeSelection:(UITextField *)textField{
    
    if([self.title isEqualToString:@"修改名字"]){
        [self.countLimit setText:[NSString stringWithFormat:@"%ld/20",textField.text.length]];
        if([textField.text isEqualToString:[AppUserData GetCurrenUser].username]){
            [self.SaveButton setAlpha:0.3];
            [self.SaveButton setEnabled:NO];
//            [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        }else{
            [self.SaveButton setAlpha:1];
            [self.SaveButton setEnabled:YES];
//            [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
        }
    }
    
    if([self.title isEqualToString:@"修改抖音号"]){
        [self.countLimit setText:[NSString stringWithFormat:@"%ld/16",textField.text.length]];
        if([textField.text isEqualToString:[AppUserData GetCurrenUser].uid]){
            [self.SaveButton setAlpha:0.3];
            [self.SaveButton setEnabled:NO];
//            [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        }else{
            [self.SaveButton setAlpha:1];
            [self.SaveButton setEnabled:YES];
//            [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
        }
    }
}

-(void)ShowAlertController{
    if([self.title isEqualToString:@"修改简介"]){
        if([self.textview.text isEqualToString:[AppUserData GetCurrenUser].introduce]){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self ShowSaveAlert];
        }
    }else if([self.title isEqualToString:@"修改名字"]){
        if([self.textfiled.text isEqualToString:[AppUserData GetCurrenUser].username]){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self ShowSaveAlert];
        }
    }else if([self.title isEqualToString:@"修改抖音号"]){
        if([self.textfiled.text isEqualToString:[AppUserData GetCurrenUser].uid]){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self ShowSaveAlert];
        }
    }
}



-(void)ShowSaveAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"是否保存修改" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self Save];
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)textViewDidChange:(YYTextView *)textView{
    if([self.title isEqualToString:@"修改简介"]){
        if([textView.text isEqualToString:[AppUserData GetCurrenUser].introduce]){
            [self.SaveButton setAlpha:0.3];
            [self.SaveButton setEnabled:NO];
        }else{
            [self.SaveButton setAlpha:1];
            [self.SaveButton setEnabled:YES];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([self.title isEqualToString:@"修改简介"]){
        if([self.textview.text isEqualToString:[AppUserData GetCurrenUser].introduce]){
            return YES;
        }else{
            [self ShowSaveAlert];
            return NO;
        }
    }else if([self.title isEqualToString:@"修改名字"]){
        if([self.textfiled.text isEqualToString:[AppUserData GetCurrenUser].username]){
            return YES;
        }else{
            [self ShowSaveAlert];
            return NO;
        }
    }else{
        if([self.textfiled.text isEqualToString:[AppUserData GetCurrenUser].uid]){
            return YES;
        }else{
            [self ShowSaveAlert];
            return NO;
        }
    }
}



-(void)dismissview{
    [self ShowAlertController];
}

@end
