//
//  VerifyMessageViewController.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/2.
//

#import "VerifyMessageViewController.h"

@interface VerifyMessageViewController()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *Title;
@property (nonatomic,strong) UILabel *SubTitle;
@property (nonatomic,strong) UITextField *VerifyNumber;
@property (nonatomic,strong) UIButton *MakeSureButton;
@property (nonatomic,strong) UIBarButtonItem *backButton;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger HoverTime;
@property (nonatomic,strong) UIButton *RightView;
@property (nonatomic,strong) UIBarButtonItem *HelpButton;
@end


@implementation VerifyMessageViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initSubViews];
}

-(void)initSubViews{
    self.Title = [[UILabel alloc] init];
    [self.Title setText:@"请输入验证码"];
    [self.Title setFont:[UIFont systemFontOfSize:22.0 weight:UIFontWeightBold]];
    [self.view addSubview:self.Title];
    
    self.SubTitle = [[UILabel alloc] init];
    [self.SubTitle setText:[NSString stringWithFormat:@"验证码已经发送到 %@。",self.PhoneNumber]];
    [self.SubTitle setNumberOfLines:2];
    [self.SubTitle setFont:[UIFont systemFontOfSize:13.0]];
    [self.SubTitle setTextColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.SubTitle];
    
    
    self.VerifyNumber = [[UITextField alloc] init];
    [self.VerifyNumber setPlaceholder:@"请输入验证码"];
    self.VerifyNumber.layer.cornerRadius = 5;
    [self.VerifyNumber setBackgroundColor:[UIColor colorNamed:@"lightgray"]];
    [self.VerifyNumber setKeyboardType:UIKeyboardTypeASCIICapableNumberPad];
    [self.VerifyNumber setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)]];
    [self.VerifyNumber setLeftViewMode:UITextFieldViewModeAlways];
    [self.VerifyNumber setRightViewMode:UITextFieldViewModeAlways];
    self.VerifyNumber.delegate = self;
    [self.view addSubview:self.VerifyNumber];
    
   
    self.MakeSureButton = [[UIButton alloc] init];
    self.MakeSureButton.layer.cornerRadius = 5;
    [self.MakeSureButton setEnabled:NO];
    [self.MakeSureButton setAlpha:0.3];
    [self.MakeSureButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.MakeSureButton setBackgroundColor:[UIColor redColor]];
    [self.MakeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.MakeSureButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.MakeSureButton addTarget:self action:@selector(SignIn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.MakeSureButton];
    
    
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
    [self.backButton setTintColor:[UIColor blackColor]];
    
    self.HelpButton = [[UIBarButtonItem alloc] initWithTitle:@"帮助与设置" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.HelpButton setTintColor:[UIColor blackColor]];
    

    
    [self.Title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.view).inset(120);
        make.height.mas_equalTo(20);
    }];
    
    [self.SubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Title.mas_bottom).inset(5);
        make.left.equalTo(self.view).inset(LeftPadding);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.height.mas_equalTo(40);
    }];
    
  
    [self.VerifyNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.SubTitle.mas_bottom).inset(5);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.MakeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.VerifyNumber.mas_bottom).inset(15);
        make.height.mas_equalTo(40);
    }];
    
    [self.navigationItem setLeftBarButtonItem:self.backButton];
    [self.navigationItem setRightBarButtonItem:self.HelpButton];
    [self StartTiming];
}

-(void)StartTiming{
    self.HoverTime = 120;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(UpdateTime) userInfo:nil repeats:YES];
    [self.timer fire];
}

-(void)UpdateTime{
    self.HoverTime -= 1;
    if(self.HoverTime == 0){
        self.RealVerifyNumber = nil;
        self.RightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [self.RightView setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
        [self.RightView setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.RightView.titleLabel  setFont:[UIFont systemFontOfSize:16.0]];
        [self.RightView setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.RightView addTarget:self action:@selector(ResendMessage) forControlEvents:UIControlEventTouchUpInside];
        [self.VerifyNumber setRightView:self.RightView];
        [self.timer invalidate];
    }else{
        self.RightView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
        [self.RightView setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [self.RightView setTitle:[NSString stringWithFormat:@"%ld",self.HoverTime] forState:UIControlStateNormal];
        [self.RightView.titleLabel  setFont:[UIFont systemFontOfSize:16.0]];
        [self.RightView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.VerifyNumber setRightView:self.RightView];
    }
}

-(void)ResendMessage{
    SignInWithMessageRequest *request = [SignInWithMessageRequest new];
    request.PhoneNumber = self.PhoneNumber;
    [NetWorkHelper getWithUrlPath:SignInWithMessagePath request:request success:^(id data) {
        SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
        if([response.status isEqualToString:@"faliure"]){
            [UIWindow showTips:response.msg];
            [self ResetButton];
        }else{
            [self StartTiming];
            self.RealVerifyNumber = response.msg;
        }
    }faliure:^(NSError *error) {
        [self ResetButton];
        [UIWindow showTips:@"服务器走神啦"];
    }];
   
}

-(void)SignIn{
    if(self.RealVerifyNumber == nil){
        [UIWindow showTips:@"验证码已过期，请重新发送"];
    }else{
        [self.MakeSureButton setImage:[UIImage imageNamed:@"icon60LoadingMiddle"] forState:UIControlStateNormal];
        [self.MakeSureButton setTitle:@"验证中" forState:UIControlStateNormal];
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
        rotationAnimation.duration = 1.5;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = MAXFLOAT;
        [self.MakeSureButton.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        if(self.RealVerifyNumber == self.VerifyNumber.text){
            if([self.status isEqualToString:@"SignUp"] ){
                SignUpRequest *request = [SignUpRequest new];
                request.phoneNumber = self.PhoneNumber;
                [NetWorkHelper getWithUrlPath:SignUpPath request:request success:^(id data) {
                    GetUserResponse *response = [[GetUserResponse alloc] initWithDictionary:data error:nil];
                    if([response.status isEqualToString:@"服务器繁忙"]){
                        [UIWindow showTips:@"服务器繁忙"];
                        [self ResetButton];
                    }else{
                        ClientData *clientdata = [[ClientData alloc] initWithData:response.msg IsSign:YES];
                        [AppUserData AddNewUser:clientdata];
                        [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"HasSignIn"];
                        [[PDSocketManager shared] ConnectToServerWithMyID:[AppUserData GetCurrenUser]._id completion:nil];
                        [self performSelector:@selector(FinishSignIn) withObject:nil afterDelay:0.25f];
                    }
                } faliure:^(NSError *error) {
                    [UIWindow showTips:@"服务器走神啦"];
                    [self ResetButton];
                }];
            }else{
                GetUserWithPhonnumberRequest *request = [GetUserWithPhonnumberRequest new];
                request.PhoneNumber = self.PhoneNumber;
                [NetWorkHelper getWithUrlPath:GetUserByphoneNumberPath request:request success:^(id data) {
                    GetUserResponse *response = [[GetUserResponse alloc] initWithDictionary:data error:nil];
                    if([response.status isEqualToString:@"faliure"]){
                        [UIWindow showTips:@"服务器繁忙"];
                        [self ResetButton];
                    }else{
                        ClientData *clientdata = [[ClientData alloc] initWithData:response.msg IsSign:YES];
                        [AppUserData AddNewUser:clientdata];
                        [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"HasSignIn"];
                        [[PDSocketManager shared] ConnectToServerWithMyID:[AppUserData GetCurrenUser]._id completion:nil];
                        [self performSelector:@selector(FinishSignIn) withObject:nil afterDelay:0.25f];
                    }
                }faliure:^(NSError *error) {
                    [UIWindow showTips:@"服务器走神啦"];
                    [self ResetButton];
                }];
                
            }
        }else{
            [UIWindow showTips:@"验证码错误,请重试"];
            [self ResetButton];
        }
    }
}

-(void)ResetButton{
    [self.MakeSureButton.layer removeAllAnimations];
    [self.MakeSureButton setEnabled:YES];
    [self.MakeSureButton setAlpha:1];
    [self.MakeSureButton setImage:nil forState:UIControlStateNormal];
    [self.MakeSureButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.MakeSureButton setBackgroundColor:[UIColor redColor]];
    [self.MakeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.MakeSureButton setTitle:@"登录" forState:UIControlStateNormal];
}

-(void)FinishSignIn{
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
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


-(void)ResetPassword{
    if([self.VerifyNumber.text isEqualToString:self.RealVerifyNumber]){
        [UIWindow showTips:@"修改成功"];
    }else{
        [UIWindow showTips:@"验证码不正确"];
    }
}

-(void)GoBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if(![self.VerifyNumber.text isEqualToString:@""]){
        [self.MakeSureButton setEnabled:YES];
        [self.MakeSureButton setAlpha:1];
    }else{
        [self.MakeSureButton setEnabled:NO];
        [self.MakeSureButton setAlpha:0.3];
    }
}

@end
