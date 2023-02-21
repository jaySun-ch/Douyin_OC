//
//  SignWithPasswordViewController.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/2.
//

#import "SignWithPasswordViewController.h"

@interface SignWithPasswordViewController()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *Title;
@property (nonatomic,strong) UITextField *phoneNumber;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UILabel *Privacy;
@property (nonatomic,strong) UIImageView *PrivacySureButton;
@property (nonatomic,strong) UIButton *MakeSureButton;
@property (nonatomic,strong) UIBarButtonItem *backButton;
@property (nonatomic,strong) UIBarButtonItem *HelpButton;
@property (nonatomic,strong) UILabel *findpassword;
@property (nonatomic,strong) UIButton *findPasswordButton;
@end


@implementation SignWithPasswordViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initSubViews];
}

-(void)initSubViews{
    self.Title = [[UILabel alloc] init];
    [self.Title setText:@"手机号密码登陆"];
    [self.Title setFont:[UIFont systemFontOfSize:22.0 weight:UIFontWeightBold]];
    [self.view addSubview:self.Title];
    self.phoneNumber = [[UITextField alloc] init];
    [self.phoneNumber setPlaceholder:@"请输入手机号"];
    self.phoneNumber.layer.cornerRadius = 5;
    [self.phoneNumber setBackgroundColor:[UIColor colorNamed:@"lightgray"]];
    [self.phoneNumber setKeyboardType:UIKeyboardTypeASCIICapableNumberPad];
    [self.phoneNumber setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)]];
    [self.phoneNumber setRightView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)]];
    [self.phoneNumber setLeftViewMode:UITextFieldViewModeAlways];
    [self.phoneNumber setRightViewMode:UITextFieldViewModeAlways];
    self.phoneNumber.delegate = self;
    [self.view addSubview:self.phoneNumber];
    
    self.password = [[UITextField alloc] init];
    [self.password setPlaceholder:@"请输入密码"];
    self.password.layer.cornerRadius = 5;
    [self.password setBackgroundColor:[UIColor colorNamed:@"lightgray"]];
    [self.password setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)]];
    [self.password setRightView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)]];
    [self.password setLeftViewMode:UITextFieldViewModeAlways];
    [self.password setRightViewMode:UITextFieldViewModeAlways];
    self.password.delegate = self;
    [self.view addSubview:self.password];
    
    self.Privacy = [[UILabel alloc] init];
    [self.Privacy setTextColor:[UIColor lightGrayColor]];
    [self.Privacy setFont:[UIFont systemFontOfSize:13.0]];
    [self.Privacy setText:@"已阅读同意 用户协议 和 隐私政策"];
    [self.Privacy setNumberOfLines:2];
//    [self.view addSubview:self.Privacy];

    
    self.PrivacySureButton = [[UIImageView alloc] init];
    self.PrivacySureButton.tag = 0;
    [self.PrivacySureButton setTintColor:[UIColor lightGrayColor]];
    [self.PrivacySureButton setImage:[UIImage systemImageNamed:@"circle"]];
//    [self.view addSubview:self.PrivacySureButton];
    
    
    self.MakeSureButton = [[UIButton alloc] init];
    self.MakeSureButton.layer.cornerRadius = 5;
    [self.MakeSureButton setEnabled:NO];
    [self.MakeSureButton setAlpha:0.3];
    [self.MakeSureButton setBackgroundColor:[UIColor redColor]];
    [self.MakeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.MakeSureButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.MakeSureButton addTarget:self action:@selector(SignIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.MakeSureButton];
    
    self.findpassword = [[UILabel alloc] init];
    [self.findpassword setFont:[UIFont systemFontOfSize:12.0]];
    [self.findpassword setTextColor:[UIColor lightGrayColor]];
    [self.findpassword setText:@"忘记了?"];
    [self.view addSubview:self.findpassword];
    
    self.findPasswordButton = [[UIButton alloc] init];
    [self.findPasswordButton setTitle:@"找回密码" forState:UIControlStateNormal];
    [self.findPasswordButton.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.findPasswordButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.findPasswordButton addTarget:self action:@selector(ResetPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.findPasswordButton];
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
    [self.backButton setTintColor:[UIColor blackColor]];
    
    self.HelpButton = [[UIBarButtonItem alloc] initWithTitle:@"帮助与设置" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.HelpButton setTintColor:[UIColor blackColor]];
    
    UIView *privacyContinaer = [[UIView alloc] init];
    [privacyContinaer setUserInteractionEnabled:YES];
    [privacyContinaer addSubview:_Privacy];
    [privacyContinaer addSubview:_PrivacySureButton];
    [privacyContinaer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AgreePriacy)]];
    [self.view addSubview:privacyContinaer];
    
    [self.Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.view).inset(120);
        make.height.mas_equalTo(20);
    }];
    
  
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.Title.mas_bottom).inset(20);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.height.mas_equalTo(40);
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.phoneNumber.mas_bottom).inset(10);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.height.mas_equalTo(40);
    }];
    
    [privacyContinaer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.password.mas_bottom).inset(10);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(ScreenWidth / 2);
    }];
    
    [self.PrivacySureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(privacyContinaer);
        make.top.equalTo(privacyContinaer);
        make.height.width.mas_equalTo(18);
    }];
    
    [self.Privacy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PrivacySureButton.mas_right).inset(3);
        make.top.equalTo(privacyContinaer);
        make.height.mas_equalTo(18);
    }];
    
    [self.MakeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.Privacy.mas_bottom).inset(10);
        make.height.mas_equalTo(40);
    }];
    
    [self.findpassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.MakeSureButton.mas_bottom).inset(10);
        make.height.mas_equalTo(20);

    }];
    
    [self.findPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.findpassword.mas_right).inset(2);
        make.top.equalTo(self.MakeSureButton.mas_bottom).inset(11);
        make.height.mas_equalTo(20);
    }];
    
    [self.navigationItem setLeftBarButtonItem:self.backButton];
    [self.navigationItem setRightBarButtonItem:self.HelpButton];
}

-(void)AgreePriacy{
    if( self.PrivacySureButton.tag == 0){
        self.PrivacySureButton.tag = 1;
        [self.PrivacySureButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
        [self.PrivacySureButton setTintColor:[UIColor redColor]];
    }else{
        self.PrivacySureButton.tag = 0;
        [self.PrivacySureButton setImage:[UIImage systemImageNamed:@"circle"]];
        [self.PrivacySureButton setTintColor:[UIColor lightGrayColor]];
    }
    
    if(![self.password.text isEqualToString:@""] && ![self.phoneNumber.text isEqualToString:@""] &&  self.PrivacySureButton.tag == 1){
        [self.MakeSureButton setEnabled:YES];
        [self.MakeSureButton setAlpha:1];
    }else{
        [self.MakeSureButton setEnabled:NO];
        [self.MakeSureButton setAlpha:0.3];
    }
}

-(void)ResetPassword{
    if([self.phoneNumber.text isEqualToString:@""]){
        [UIWindow showTips:@"手机号不可以为空"];
    }else{
        resetpasswordVerifyRequest *request = [resetpasswordVerifyRequest new];
        request.PhoneNumber = self.phoneNumber.text;
        [NetWorkHelper  getWithUrlPath:ResetPasswordVerifyPath request:request success:^(id data) {
            SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
            if([response.status isEqualToString:@"faliure"]){
                // 发送失败了
                [UIWindow showTips: response.msg];
            }else{
                [UIWindow showTips:[NSString stringWithFormat:@"已经发送短信到%@",self.phoneNumber.text]];
                ReSetPasswordWithMessage *resetPassword = [ReSetPasswordWithMessage new];
                resetPassword.PhoneNumber = self.phoneNumber.text;
                resetPassword.RealVerifyNumber = response.msg;
                [self.navigationController pushViewController:resetPassword animated:YES];
            }
        } faliure:nil];
    }
}

-(void)SignIn{
    [self.MakeSureButton setImage:[UIImage imageNamed:@"icon60LoadingMiddle"] forState:UIControlStateNormal];
    [self.MakeSureButton setTitle:@"验证中" forState:UIControlStateNormal];
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.MakeSureButton.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    SignInRequest *request = [SignInRequest new];
    request.username = self.phoneNumber.text;
    request.password = self.password.text;
    [NetWorkHelper getWithUrlPath:SignInPath request:request success:^(id data) {
        GetUserResponse *result = [[GetUserResponse alloc] initWithDictionary:data error:nil];
        if(result.msg != nil){
            ClientData *clientdata = [[ClientData alloc] initWithData:result.msg IsSign:YES];
            [AppUserData AddNewUser:clientdata];
            [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"HasSignIn"];
            [[PDSocketManager shared] ConnectToServerWithMyID:[AppUserData GetCurrenUser]._id completion:nil];
            [self performSelector:@selector(FinishSignIN) withObject:nil afterDelay:0.25f];
        }else{
            [UIWindow showTips:result.status];
            [self ResetButton];
        }
    }faliure:^(NSError *error) {
        [UIWindow showTips:@"服务器走神啦"];
        [self ResetButton];
    }];
}

-(void)ResetButton{
    [self.MakeSureButton.layer removeAllAnimations];
    [self.MakeSureButton setEnabled:YES];
    [self.MakeSureButton setAlpha:1];
    [self.MakeSureButton setImage:nil forState:UIControlStateNormal];
    [self.MakeSureButton setBackgroundColor:[UIColor redColor]];
    [self.MakeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.MakeSureButton setTitle:@"登录" forState:UIControlStateNormal];
}

-(void)FinishSignIN{
    [self.MakeSureButton.imageView.layer removeAllAnimations];
    [self.MakeSureButton setImage:[UIImage imageNamed:@"check_circle_white"] forState:UIControlStateNormal];
    [self.MakeSureButton setTintColor:[UIColor redColor]];
    [self.MakeSureButton setTitle:@"" forState:UIControlStateNormal];
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = @(0.0);
    scaleAnim.toValue = @(1.3);
    scaleAnim.toValue = @(1.0);
    scaleAnim.duration = 0.3f;
    [self.MakeSureButton.imageView.layer addAnimation:scaleAnim forKey:nil];
    [self performSelector:@selector(DimissController) withObject:nil afterDelay:0.8f];

}

-(void)DimissController{
    [self.navigationController dismissViewToRootController:YES completion:nil];
}


-(void)GoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if(![self.password.text isEqualToString:@""] && ![self.phoneNumber.text isEqualToString:@""] &&  self.PrivacySureButton.tag == 1){
        [self.MakeSureButton setEnabled:YES];
        [self.MakeSureButton setAlpha:1];
    }else{
        [self.MakeSureButton setEnabled:NO];
        [self.MakeSureButton setAlpha:0.3];
    }
}



@end
