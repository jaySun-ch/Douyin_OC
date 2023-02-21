//
//  ReSetPasswordWithMessage.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/2.
//

#import "ReSetPasswordWithMessage.h"

@interface ReSetPasswordWithMessage()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *Title;
@property (nonatomic,strong) UILabel *SubTitle;
@property (nonatomic,strong) UITextField *VerifyNumber;
@property (nonatomic,strong) UITextField *newpassword;
@property (nonatomic,strong) UILabel *Privacy;
@property (nonatomic,strong) UIImageView *PrivacySureButton;
@property (nonatomic,strong) UIButton *MakeSureButton;
@property (nonatomic,strong) UIBarButtonItem *backButton;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger HoverTime;
@property (nonatomic,strong) UIButton *RightView;
@end


@implementation ReSetPasswordWithMessage

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initSubViews];
}

-(void)initSubViews{
    self.Title = [[UILabel alloc] init];
    [self.Title setText:@"找回密码"];
    [self.Title setFont:[UIFont systemFontOfSize:22.0 weight:UIFontWeightBold]];
    [self.view addSubview:self.Title];
    
    self.SubTitle = [[UILabel alloc] init];
    [self.SubTitle setText:[NSString stringWithFormat:@"验证码已经发送到 %@。密码需要8-20位，至少含字母、数字、字符的任意两种",self.PhoneNumber]];
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
    
    self.newpassword = [[UITextField alloc] init];
    [self.newpassword setPlaceholder:@"请输入密码"];
    self.newpassword.layer.cornerRadius = 5;
    [self.newpassword setBackgroundColor:[UIColor colorNamed:@"lightgray"]];
    [self.newpassword setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)]];
    [self.newpassword setRightView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)]];
    [self.newpassword setLeftViewMode:UITextFieldViewModeAlways];
    [self.newpassword setRightViewMode:UITextFieldViewModeAlways];
    self.newpassword.delegate = self;
    [self.view addSubview:self.newpassword];
    
    self.Privacy = [[UILabel alloc] init];
    [self.Privacy setTextColor:[UIColor lightGrayColor]];
    [self.Privacy setFont:[UIFont systemFontOfSize:13.0]];
    [self.Privacy setText:@"已阅读同意 用户协议 和 隐私政策"];
    [self.Privacy setNumberOfLines:2];

    
    self.PrivacySureButton = [[UIImageView alloc] init];
    self.PrivacySureButton.tag = 0;
    [self.PrivacySureButton setTintColor:[UIColor lightGrayColor]];
    [self.PrivacySureButton setImage:[UIImage systemImageNamed:@"circle"]];
    
    
    self.MakeSureButton = [[UIButton alloc] init];
    self.MakeSureButton.layer.cornerRadius = 5;
    [self.MakeSureButton setEnabled:NO];
    [self.MakeSureButton setAlpha:0.3];
    [self.MakeSureButton setBackgroundColor:[UIColor redColor]];
    [self.MakeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.MakeSureButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.MakeSureButton addTarget:self action:@selector(FinishChangePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.MakeSureButton];
    
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
    [self.backButton setTintColor:[UIColor blackColor]];
    
    
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
    
    [self.SubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.Title.mas_bottom).inset(10);
        make.left.equalTo(self.view).inset(LeftPadding);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.height.mas_equalTo(40);
    }];
    
  
    [self.VerifyNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.SubTitle.mas_bottom).inset(20);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.height.mas_equalTo(40);
    }];
    
    [self.newpassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.VerifyNumber.mas_bottom).inset(10);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.height.mas_equalTo(40);
    }];
    
    [privacyContinaer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.newpassword.mas_bottom).inset(10);
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
    
    [self.navigationItem setLeftBarButtonItem:self.backButton];
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
    resetpasswordVerifyRequest *request = [resetpasswordVerifyRequest new];
    request.PhoneNumber = self.PhoneNumber;
    [NetWorkHelper  getWithUrlPath:ResetPasswordVerifyPath request:request success:^(id data) {
        SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
        if([response.status isEqualToString:@"faliure"]){
            // 发送失败了
            [UIWindow showTips: response.msg];
        }else{
            [UIWindow showTips:[NSString stringWithFormat:@"已经发送短信到%@",self.PhoneNumber]];
            self.RealVerifyNumber = response.msg;
            [self StartTiming];
        }
    } faliure:nil];
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
    
    if(![self.VerifyNumber.text isEqualToString:@""] && ![self.newpassword.text isEqualToString:@""] &&   self.PrivacySureButton.tag == 1){
        [self.MakeSureButton setEnabled:YES];
        [self.MakeSureButton setAlpha:1];
    }else{
        [self.MakeSureButton setEnabled:NO];
        [self.MakeSureButton setAlpha:0.3];
    }
}

-(void)FinishChangePassword{
    if(self.RealVerifyNumber == nil){
        [UIWindow showTips:@"验证码已过期，请重新发送"];
    }else{
        resetpasswordRequest *request = [resetpasswordRequest new];
        request.PhoneNumber = self.PhoneNumber;
        request.newpassword = self.newpassword.text;
        [self ChangePassword];
        [NetWorkHelper getWithUrlPath:ResetPasswordPath request:request success:^(id data) {
            SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
            if([response.status isEqualToString:@"faliure"]){
                [UIWindow showTips:@"修改密码失败,请重试"];
                [self ResetButton];
            }else{
                [self performSelector:@selector(ShowVerifyMessageViewController) withObject:nil afterDelay:0.25f];
            }
        } faliure:^(NSError *error) {
            [UIWindow showTips:@"服务器走神啦"];
            [self ResetButton];
        }];
    }
}

-(void)ChangePassword{
    [self.MakeSureButton setImage:[UIImage imageNamed:@"icon60LoadingMiddle"] forState:UIControlStateNormal];
    [self.MakeSureButton setTitle:@"修改密码中" forState:UIControlStateNormal];
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.MakeSureButton.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)ShowVerifyMessageViewController{
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

-(void)ResetButton{
    [self.MakeSureButton.layer removeAllAnimations];
    [self.MakeSureButton setEnabled:YES];
    [self.MakeSureButton setAlpha:1];
    [self.MakeSureButton setImage:nil forState:UIControlStateNormal];
    [self.MakeSureButton setBackgroundColor:[UIColor redColor]];
    [self.MakeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.MakeSureButton setTitle:@"完成" forState:UIControlStateNormal];
}

-(void)DimissController{
    [self.navigationController popViewControllerAnimated:YES];
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
    if(![self.VerifyNumber.text isEqualToString:@""] && ![self.newpassword.text isEqualToString:@""] &&   self.PrivacySureButton.tag == 1){
        [self.MakeSureButton setEnabled:YES];
        [self.MakeSureButton setAlpha:1];
    }else{
        [self.MakeSureButton setEnabled:NO];
        [self.MakeSureButton setAlpha:0.3];
    }
}

@end
