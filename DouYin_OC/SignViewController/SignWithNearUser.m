//
//  SignWithNearUser.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/18.
//

#import "SignWithNearUser.h"

@interface SignWithNearUser()
@property (nonatomic,strong) UILabel *mainTitle;
@property (nonatomic,strong) UIImageView *clientImage;
@property (nonatomic,strong) UILabel *clientName;
@property (nonatomic,strong) UIButton *SignButton;
@property (nonatomic,strong) UILabel *Privacy;
@property (nonatomic,strong) UIImageView *PrivacySureButton;
@property (nonatomic,strong) UIButton *downLabel;
@property (nonatomic,strong) UIBarButtonItem *backButton;
@property (nonatomic,strong) UIBarButtonItem *HelpButton;

@end

@implementation SignWithNearUser

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self SetNavigationBar];
    [self SetMainView];
}

-(void)SetNavigationBar{
    self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"] style:UIBarButtonItemStylePlain target:self action:@selector(GoBack)];
    [self.backButton setTintColor:[UIColor blackColor]];
    
    self.HelpButton = [[UIBarButtonItem alloc] initWithTitle:@"帮助与设置" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.HelpButton setTintColor:[UIColor blackColor]];
    
    [self.navigationItem setLeftBarButtonItem:self.backButton];
    [self.navigationItem setRightBarButtonItem:self.HelpButton];
}

-(void)GoBack{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}

-(void)SetMainView{
    
    self.mainTitle = [[UILabel alloc] init];
    [self.mainTitle setText:@"登陆看朋友内容"];
    [self.view addSubview:self.mainTitle];
    
    self.clientImage = [[UIImageView alloc] init];
    self.clientImage.layer.cornerRadius = 50;
    self.clientImage.clipsToBounds = YES;
    self.clientImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.clientImage setImageWithURL:[NSURL URLWithString:[AppUserData GetNearstSignUser].ClientImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [self.view addSubview:self.clientImage];

    
    self.clientName = [[UILabel alloc] init];
    [self.clientName setText:[AppUserData GetNearstSignUser].username];
    [self.view addSubview:self.clientName];
    
    self.SignButton = [[UIButton alloc] init];
    self.SignButton.layer.cornerRadius = 8;
    self.SignButton.backgroundColor = [UIColor redColor];
    [self.SignButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.SignButton addTarget:self action:@selector(Sign) forControlEvents:UIControlEventTouchUpInside];
    [self.SignButton setTitle:@"一键登录" forState:UIControlStateNormal];
    [self.view addSubview:self.SignButton];
    
    self.Privacy = [[UILabel alloc] init];
    [self.Privacy setTextColor:[UIColor lightGrayColor]];
    [self.Privacy setFont:[UIFont systemFontOfSize:12.0]];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = 5;
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"已阅读同意 用户协议 和 隐私政策"];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, @"已阅读同意 用户协议 和 隐私政策".length)];
    self.Privacy.attributedText = attrString;
    [self.Privacy setNumberOfLines:2];
    [self.view addSubview:self.Privacy];


    self.PrivacySureButton = [[UIImageView alloc] init];
    self.PrivacySureButton.tag = 0;
    [self.PrivacySureButton setTintColor:[UIColor lightGrayColor]];
    [self.PrivacySureButton setImage:[UIImage systemImageNamed:@"circle"]];
    [self.view addSubview:self.PrivacySureButton];
    
    UIView *privacyContinaer = [[UIView alloc] init];
    [privacyContinaer setUserInteractionEnabled:YES];
    [privacyContinaer addSubview:_Privacy];
    [privacyContinaer addSubview:_PrivacySureButton];
    [privacyContinaer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(AgreePriacy)]];
    [self.view addSubview:privacyContinaer];
    
    
    self.downLabel = [[UIButton alloc] init];
    [self.downLabel.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.downLabel setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.downLabel setTitle:@"以其他账号登陆" forState:UIControlStateNormal];
    [self.downLabel addTarget:self action:@selector(GoNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downLabel];
    
    
    [self.clientImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).inset(ScreenHeight/3);
        make.width.height.mas_equalTo(100);
    }];
    
    [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.clientImage.mas_top).inset(30);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    [self.clientName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.clientImage.mas_bottom).inset(15);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    [self.SignButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clientName.mas_bottom).inset(80);
        make.width.mas_equalTo(ScreenWidth-50);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    
    [privacyContinaer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.SignButton.mas_bottom).inset(5);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(ScreenWidth-50);
    }];
    
    [self.PrivacySureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(privacyContinaer);
        make.centerY.equalTo(privacyContinaer);
        make.height.width.mas_equalTo(18);
    }];
    
    
    [self.Privacy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.PrivacySureButton.mas_right).inset(3);
        make.centerY.equalTo(privacyContinaer);
        make.height.mas_equalTo(50);
    }];
    
    [self.downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).inset(50);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
}


-(void)Sign{
    if(self.PrivacySureButton.tag == 1){
        [AppUserData SignWithNearstUser];
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"HasSignIn"];
        [[PDSocketManager shared] ConnectToServerWithMyID:[AppUserData GetCurrenUser]._id completion:nil];
        [self GoBack];
    }else{
        [UIWindow showTips:@"请同意隐私政策"];
    }
}

-(void)GoNext{
    SignViewController *vc = [SignViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)AgreePriacy{
    if(self.PrivacySureButton.tag == 0){
        self.PrivacySureButton.tag = 1;
        [self.PrivacySureButton setImage:[UIImage systemImageNamed:@"checkmark.circle.fill"]];
        [self.PrivacySureButton setTintColor:[UIColor redColor]];
    }else{
        self.PrivacySureButton.tag = 0;
        [self.PrivacySureButton setImage:[UIImage systemImageNamed:@"circle"]];
        [self.PrivacySureButton setTintColor:[UIColor lightGrayColor]];
    }
}


@end
