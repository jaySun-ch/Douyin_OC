//
//  SignViewController.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/2.
//

#import "SignViewController.h"
#import "SignWithPasswordViewController.h"


@interface SignViewController()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *Title;
@property (nonatomic,strong) UILabel *Privacy;
@property (nonatomic,strong) UIImageView *PrivacySureButton;
@property (nonatomic,strong) UITextField *phoneNumber;
@property (nonatomic,strong) UIButton *MakeSureButton;
@property (nonatomic,strong) UIButton *PasswordSignButton;
@property (nonatomic,strong) UIButton *otherSignOpationButton;
@property (nonatomic,strong) UIBarButtonItem *backButton;
@property (nonatomic,strong) UIBarButtonItem *HelpButton;


@end

@implementation SignViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor whiteColor]];
    [self initSubViews];
}

-(void)initSubViews{
    self.Title = [[UILabel alloc] init];
    [self.Title setText:@"登陆看朋友内容"];
    [self.Title setFont:[UIFont systemFontOfSize:22.0 weight:UIFontWeightBold]];
    [self.view addSubview:self.Title];
    
    self.Privacy = [[UILabel alloc] init];
    [self.Privacy setTextColor:[UIColor lightGrayColor]];
    [self.Privacy setFont:[UIFont systemFontOfSize:13.0]];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 5;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"已阅读同意 用户协议 和 隐私政策,运营商将对你提供的手机号进行验证"];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, @"已阅读同意 用户协议 和 隐私政策,运营商将对你提供的手机号进行验证".length)];
    self.Privacy.attributedText = attrString;
    [self.Privacy setNumberOfLines:2];
//    [self.view addSubview:self.Privacy];

  
    
    self.PrivacySureButton = [[UIImageView alloc] init];
    self.PrivacySureButton.tag = 0;
    [self.PrivacySureButton setTintColor:[UIColor lightGrayColor]];
    [self.PrivacySureButton setImage:[UIImage systemImageNamed:@"circle"]];
//    [self.view addSubview:self.PrivacySureButton];
    
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
    
    UILabel *Tips = [[UILabel alloc] init];
    [Tips setTextColor:[UIColor lightGrayColor]];
    [Tips setText:@"未注册的手机号验证通过后将自动注册"];
    [Tips setFont:[UIFont systemFontOfSize:13.0]];
    [self.view addSubview:Tips];
    
    self.MakeSureButton = [[UIButton alloc] init];
    self.MakeSureButton.layer.cornerRadius = 5;
    [self.MakeSureButton setEnabled:NO];
    [self.MakeSureButton setAlpha:0.3];
    [self.MakeSureButton setTitle:@"验证并登录" forState:UIControlStateNormal];
    [self.MakeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.MakeSureButton setBackgroundColor:[UIColor redColor]];
    [self.MakeSureButton addTarget:self action:@selector(GoVerifyViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.MakeSureButton];
    
    self.PasswordSignButton = [[UIButton alloc] init];
    [self.PasswordSignButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.PasswordSignButton setTintColor:[UIColor blackColor]];
    [self.PasswordSignButton setTitle:@"密码登陆" forState:UIControlStateNormal];
    [self.PasswordSignButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.PasswordSignButton setImage:[UIImage systemImageNamed:@"key.fill"] forState:UIControlStateNormal];
    [self.PasswordSignButton.layer setBorderColor:[UIColor systemGray5Color].CGColor];
    [self.PasswordSignButton.layer setBorderWidth:1];
    [self.PasswordSignButton.layer setCornerRadius:10];
    [self.PasswordSignButton addTarget:self action:@selector(GoSignWithPassWordView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.PasswordSignButton];
    
    self.otherSignOpationButton = [[UIButton alloc] init];
    [self.otherSignOpationButton setTintColor:[UIColor blackColor]];
    [self.otherSignOpationButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    [self.otherSignOpationButton.layer setBorderColor:[UIColor systemGray5Color].CGColor];
    [self.otherSignOpationButton.layer setBorderWidth:1];
    [self.otherSignOpationButton.layer setCornerRadius:20];
    [self.otherSignOpationButton addTarget:self action:@selector(ShowOtherOpations) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.otherSignOpationButton];
    
    
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
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
    
    [privacyContinaer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.Title.mas_bottom).inset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(ScreenWidth - 2*LeftPadding);
    }];
    
    [self.PrivacySureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(privacyContinaer);
        make.top.equalTo(privacyContinaer).inset(6);
        make.height.width.mas_equalTo(18);
    }];
    
    
    [self.Privacy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PrivacySureButton.mas_right).inset(3);
        make.right.equalTo(privacyContinaer);
        make.top.equalTo(privacyContinaer);
        make.height.mas_equalTo(50);
    }];
    
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.Privacy.mas_bottom).inset(10);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.height.mas_equalTo(40);
    }];
    
    [Tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.phoneNumber.mas_bottom).inset(5);
    }];
    
    [self.MakeSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(Tips.mas_bottom).inset(20);
        make.right.equalTo(self.view).inset(LeftPadding);
        make.height.mas_equalTo(40);
    }];
    
    [self.PasswordSignButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.MakeSureButton.mas_bottom).inset(20);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
    [self.otherSignOpationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).inset(LeftPadding);
        make.top.equalTo(self.MakeSureButton.mas_bottom).inset(20);
        make.width.height.mas_equalTo(40);
    }];
    
    [self.navigationItem setLeftBarButtonItem:self.backButton];
    [self.navigationItem setRightBarButtonItem:self.HelpButton];
}

-(void)ShowOtherOpations{
    CustomAlertSheetView *alert = [[CustomAlertSheetView alloc] initWithActionCount:4];
    CustomAlertAction *action1 = [[CustomAlertAction alloc] initWithStyle:@"QQ登陆" image:[UIImage imageNamed:@"icon_profile_share_qq"] style:CustomAlertActionStyleDefalut SetImageRight:NO handle:^{
        
    }];
    CustomAlertAction *action2 = [[CustomAlertAction alloc] initWithStyle:@"微信登陆" image:[UIImage imageNamed:@"icon_profile_share_wechat"] style:CustomAlertActionStyleDefalut SetImageRight:NO handle:^{
        
    }];
    
    CustomAlertAction *action3 = [[CustomAlertAction alloc] initWithStyle:@"微博登陆" image:[UIImage imageNamed:@"icon_profile_share_weibo"] style:CustomAlertActionStyleDefalut SetImageRight:NO handle:^{
        
    }];
    
    CustomAlertAction *action4 = [[CustomAlertAction alloc] initWithStyle:@"取消" image:nil style:CustomAlertActionStyleCancel SetImageRight:NO handle:nil];
    
    [alert addCustomActions:action1];
    [alert addCustomActions:action2];
    [alert addCustomActions:action3];
    [alert addCustomActions:action4];
    [self presentPanModal:alert];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void)GoVerifyViewController{
    [self.MakeSureButton setImage:[UIImage imageNamed:@"icon60LoadingMiddle"] forState:UIControlStateNormal];
    [self.MakeSureButton setTitle:@"发送验证码中" forState:UIControlStateNormal];
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 1.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.MakeSureButton.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self performSelector:@selector(ShowVerifyMessageViewController) withObject:nil afterDelay:0.5f];
}

-(void)ShowVerifyMessageViewController{
    SignInWithMessageRequest *request = [SignInWithMessageRequest new];
    request.PhoneNumber = self.phoneNumber.text;
    [NetWorkHelper getWithUrlPath:SignInWithMessagePath request:request success:^(id data) {
        SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
        if([response.status isEqualToString:@"faliure"]){
            [UIWindow showTips:response.msg];
            [self ResetButton];
        }else{
            VerifyMessageViewController *newvc = [VerifyMessageViewController new];
            newvc.PhoneNumber = self.phoneNumber.text;
            newvc.RealVerifyNumber = response.msg;
            newvc.status = response.status;
            [self.navigationController pushViewController:newvc animated:YES];
            [self.MakeSureButton.imageView.layer removeAllAnimations];
            [self.MakeSureButton setEnabled:NO];
            [self.MakeSureButton setAlpha:0.3];
            [self.MakeSureButton setTitle:@"验证并登录" forState:UIControlStateNormal];
            [self.MakeSureButton setImage:nil forState:UIControlStateNormal];
            [self.MakeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }faliure:^(NSError *error) {
        [self ResetButton];
        [UIWindow showTips:@"服务器走神啦"];
    }];
}

-(void)ResetButton{
    [self.MakeSureButton.layer removeAllAnimations];
    [self.MakeSureButton setEnabled:YES];
    [self.MakeSureButton setAlpha:1];
    [self.MakeSureButton setTitle:@"验证并登录" forState:UIControlStateNormal];
    [self.MakeSureButton setImage:nil forState:UIControlStateNormal];
    [self.MakeSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.MakeSureButton setBackgroundColor:[UIColor redColor]];
}

-(void)AgreePriacy{
    NSLog(@"1");
    if(self.PrivacySureButton.tag == 0){
        self.PrivacySureButton.tag = 1;
        [self.PrivacySureButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
        [self.PrivacySureButton setTintColor:[UIColor redColor]];
    }else{
        self.PrivacySureButton.tag = 0;
        [self.PrivacySureButton setImage:[UIImage systemImageNamed:@"circle"]];
        [self.PrivacySureButton setTintColor:[UIColor lightGrayColor]];
    }
    
    if(![self.phoneNumber.text isEqualToString:@""] &&  self.PrivacySureButton.tag == 1){
        [self.MakeSureButton setEnabled:YES];
        [self.MakeSureButton setAlpha:1];
    }else{
        [self.MakeSureButton setEnabled:NO];
        [self.MakeSureButton setAlpha:0.3];
    }
}

- (void)textFieldDidChangeSelection:(UITextField *)textField{
    if(![textField.text isEqualToString:@""] &&  self.PrivacySureButton.tag == 1){
        [self.MakeSureButton setEnabled:YES];
        [self.MakeSureButton setAlpha:1];
    }else{
        [self.MakeSureButton setEnabled:NO];
        [self.MakeSureButton setAlpha:0.3];
    }
}

-(void)GoBack{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController dismissViewToRootController:YES completion:nil];
    });
}

-(void)GoSignWithPassWordView{
    SignWithPasswordViewController *SignPassword = [SignWithPasswordViewController new];
    [self.navigationController pushViewController:SignPassword animated:YES];
}



@end
