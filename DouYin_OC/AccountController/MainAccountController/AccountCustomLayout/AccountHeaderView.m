//
//  AccountHeaderView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/28.
//

#import "AccountHeaderView.h"
#import "EditAccountConrtoller.h"
#import "AddMainFriendController.h"

@interface AccountHeaderView()
@property (nonatomic,strong) UIView *continaerView;
@property (nonatomic,strong) UIImageView *BackgroundImage; // 背景图
@property (nonatomic,strong) UIImageView *ClientImage; // 头像
@property (nonatomic,strong) UILabel *ClientName; //名称
@property (nonatomic,strong) UIView *ClientdownButtonView;
@property (nonatomic,strong) UIImageView *ClientdownButton; //名称旁边的downbutton
@property (nonatomic,strong) UILabel *douyin_id; // 抖音号
@property (nonatomic,strong) CustomButtonView *likecount; // 点赞个数
@property (nonatomic,strong) CustomButtonView *firendcount; // 朋友个数
@property (nonatomic,strong) CustomButtonView *focuscount; // 关注个数
@property (nonatomic,strong) CustomButtonView *fanscount; // 粉丝个数
@property (nonatomic,strong) CustomeIntroduceView *introduce; // 个人介绍
@property (nonatomic,strong) UIScrollView *scrollview; // 用来装载自己的音乐等信息
@property (nonatomic,strong) CustomIconView *setview; //我的音乐
@property (nonatomic,strong) UIButton *addfriendButton; //添加朋友
@property (nonatomic,strong) UIButton *editdataButton; //编辑资料
@property (nonatomic,strong) UIView *BottomContianer;
@property (nonatomic,strong) UIView *LastBottomContianer;


@end

@implementation AccountHeaderView

- (instancetype)init{
    return [super init];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUserInteractionEnabled:YES];
        [self initSubViews];
        [self initConstraint];
    }
    return self;
}

-(void)initData{
    [_BackgroundImage setImageWithURL:[NSURL URLWithString:[AppUserData GetCurrenUser].BackGroundImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [_ClientImage setImageWithURL:[NSURL URLWithString:[AppUserData GetCurrenUser].ClientImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [_ClientName setText:[AppUserData GetCurrenUser].username];
    [_douyin_id setText:[NSString stringWithFormat:@"抖音号:%@",[AppUserData GetCurrenUser].uid]];
    [_likecount initWithData:[AppUserData GetCurrenUser].Likecount describe:@"获赞"];
    [_firendcount initWithData:[AppUserData GetCurrenUser].FriendList.count describe:@"朋友"];
    [_focuscount initWithData:[AppUserData GetCurrenUser].concernList.count describe:@"关注"];
    [_fanscount initWithData:[AppUserData GetCurrenUser].fansList.count describe:@"粉丝"];
    [_editdataButton setTitle:[NSString stringWithFormat:@"编辑资料 %ld%@",[[AppUserData GetCurrenUser] getCurrentProgress],@"%"] forState:UIControlStateNormal];
    [_introduce initData];
}

-(void)initSubViews{
    _BackgroundImage = [[UIImageView alloc] init];
    _BackgroundImage.tag = AccountHeadBackGround;
    [_BackgroundImage setUserInteractionEnabled:YES];
    [_BackgroundImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HandleTapGesture:)]];
   
    _ClientImage = [[UIImageView alloc]init];
    _ClientImage.layer.cornerRadius = 40;
    _ClientImage.clipsToBounds = YES;
    _ClientImage.contentMode = UIViewContentModeScaleAspectFill;
    [_ClientImage setUserInteractionEnabled:YES];
    _ClientImage.layer.borderWidth = 2;
    _ClientImage.tag = AccountHeadClientImage;
    [_ClientImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HandleTapGesture:)]];
    _ClientImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    

    _ClientName = [[UILabel alloc]init];
    [_ClientName setUserInteractionEnabled:YES];
    [_ClientName addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShowEditClientMessageController)]];
    [_ClientName setTextColor:[UIColor whiteColor]];
    [_ClientName setFont:[UIFont systemFontOfSize:22.0 weight:UIFontWeightMedium]];
  
    
    _ClientdownButton = [[UIImageView alloc]init];
    [_ClientdownButton setImage:[UIImage systemImageNamed:@"arrowtriangle.down.fill"]];
    [_ClientdownButton setTintColor:[UIColor whiteColor]];
    
    
    _ClientdownButtonView = [[UIView alloc] init];
    _ClientdownButtonView.layer.cornerRadius = 10;
    _ClientdownButtonView.tag = AccountHeadClientNameRightButton;
    [_ClientdownButtonView setUserInteractionEnabled:YES];
    [_ClientdownButtonView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HandleTapGesture:)]];
    [_ClientdownButtonView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2]];
    [_ClientdownButtonView addSubview:_ClientdownButton];
    
    
    _douyin_id = [[UILabel alloc] init];
    [_douyin_id setFont:[UIFont systemFontOfSize:13.0]];
    [_douyin_id setTextColor:[UIColor lightGrayColor]];
    
    _likecount = [[CustomButtonView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    
    _firendcount = [[CustomButtonView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    
    _focuscount = [[CustomButtonView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
  
    _fanscount = [[CustomButtonView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    
    _introduce = [[CustomeIntroduceView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, 100)];
    
    [_introduce addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShowEditClientMessageController)]];
    
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.alwaysBounceHorizontal = YES;
    
    _setview = [[CustomIconView alloc] initWithFrame:CGRectMake(15, 0, 100, 40) image:[UIImage systemImageNamed:@"music.note"] title:@"我的音乐" subtitle:@"已经收藏6首"];
    
    _addfriendButton = [[UIButton alloc] init];
    _addfriendButton.backgroundColor = [UIColor colorNamed:@"lightgray"];
    _addfriendButton.layer.cornerRadius = 5;
    [_addfriendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_addfriendButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_addfriendButton setUserInteractionEnabled:YES];
    [_addfriendButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        AddMainFriendController *newvc = [[AddMainFriendController alloc] init];
        newvc.currentIndex = 2;
        [UIWindow PushController:newvc];
    }];
    [_addfriendButton setTitle:@"添加朋友" forState:UIControlStateNormal];
    
    _editdataButton = [[UIButton alloc] init];
    _editdataButton.backgroundColor = [UIColor colorNamed:@"lightgray"];
    _editdataButton.layer.cornerRadius = 5;
    [_editdataButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [_editdataButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_editdataButton addTarget:self action:@selector(ShowEditClientMessageController) forControlEvents:UIControlEventTouchUpInside];

    _BottomContianer = [[UIView alloc] init];
    _BottomContianer.backgroundColor = [UIColor whiteColor];
    
    _LastBottomContianer = [[UIView alloc] init];
  
    _LastBottomContianer.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _LastBottomContianer.layer.shadowColor = [[UIColor blackColor] CGColor];
    _LastBottomContianer.layer.shadowOffset = CGSizeMake(0, -100);
    _LastBottomContianer.layer.shadowRadius = 50;
    _LastBottomContianer.layer.shadowOpacity = 0.7;
    
    // radius
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, 1000) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.BottomContianer.frame;
    maskLayer.path = maskPath.CGPath;
    self.BottomContianer.layer.mask = maskLayer;
    _tabbar = [[HeaderTabbar alloc] initWithArrayItem:@[@"作品",@"私密",@"收藏",@"喜欢"]];
    _continaerView = [[UIView alloc] init];
    _continaerView.backgroundColor = [UIColor clearColor];
}



-(void)initConstraint{
    [self addSubview:_BackgroundImage];
    [self addSubview:_LastBottomContianer];
    [_LastBottomContianer addSubview:_BottomContianer];
    [self addSubview:_continaerView];
    [_continaerView addSubview:_ClientImage];
    [_continaerView addSubview:_ClientName];
    [_continaerView addSubview:_douyin_id];
    [_continaerView addSubview:_ClientdownButtonView];
    [_continaerView addSubview:_likecount];
    [_continaerView addSubview:_firendcount];
    [_continaerView addSubview:_focuscount];
    [_continaerView addSubview:_fanscount];
    [_continaerView addSubview:_introduce];
    [_scrollview addSubview:_setview];
    [_continaerView addSubview:_scrollview];
    [_continaerView addSubview:_addfriendButton];
    [_continaerView addSubview:_editdataButton];
    [self addSubview:_tabbar];
    [self SetTopView];
    [self SetBottomView];
   
}

-(void)ShowEditClientMessageController{
    [UIWindow PushController:[EditAccountConrtoller new]];
}

-(void)SetTopView{
    [_BackgroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(self.frame.size.height / 2 );
    }];
    
    [_ClientImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).inset(15);
        make.bottom.equalTo(_BackgroundImage).inset(30);
        make.height.width.mas_equalTo(80);
    }];
    
    [_ClientName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ClientImage.mas_right).inset(13);
        make.top.equalTo(_ClientImage.mas_top).inset(18);
    }];
    
    [_ClientdownButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ClientName.mas_right).inset(4);
        make.centerY.equalTo(_ClientName);
        make.width.height.mas_equalTo(20);
    }];
    
    [_ClientdownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_ClientdownButtonView);
        make.width.height.mas_equalTo(10);
    }];
    
    [_douyin_id mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_ClientImage.mas_right).inset(13);
        make.top.equalTo(_ClientName.mas_bottom).inset(5);
    }];
    
}


-(void)SetBottomView{
    [_continaerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ClientImage.mas_top);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.equalTo(self);
    }];
    
    [_BottomContianer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.leading.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(self.frame.size.height / 2 + 10);
    }];
    
    [_likecount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BottomContianer.mas_top).inset(15);
        make.left.equalTo(_BottomContianer.mas_left).inset(15);
        make.height.mas_equalTo(30);
    }];
    
    [_firendcount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BottomContianer.mas_top).inset(15);
        make.left.equalTo(_likecount.mas_right).inset(15);
        make.height.mas_equalTo(30);
    }];
    
    [_focuscount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BottomContianer.mas_top).inset(15);
        make.left.equalTo(_firendcount.mas_right).inset(15);
        make.height.mas_equalTo(30);
    }];
    
    [_fanscount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_BottomContianer.mas_top).inset(15);
        make.left.equalTo(_focuscount.mas_right).inset(15);
        make.height.mas_equalTo(30);
    }];
    
    [_introduce mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_fanscount.mas_bottom).inset(10);
        make.left.equalTo(_BottomContianer.mas_left).inset(15);
        make.width.equalTo(_BottomContianer);
        make.height.mas_equalTo(50);
    }];
    
    [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_introduce.mas_bottom).inset(10);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(40);
    }];
    
    [_editdataButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollview.mas_bottom).inset(15);
        make.left.equalTo(self).inset(15);
        make.width.mas_equalTo((ScreenWidth - 40)/ 2);
        make.height.mas_equalTo(35);
    }];
    
    [_addfriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_scrollview.mas_bottom).inset(15);
        make.left.equalTo(_editdataButton.mas_right).inset(10);
        make.right.equalTo(self).inset(15);
        make.width.mas_equalTo((ScreenWidth - 40)/ 2);
        make.height.mas_equalTo(35);
    }];
    
    [_tabbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(40);
    }];
}

-(void)HandleTapGesture:(UITapGestureRecognizer *)gesture{
    NSLog(@"%ld",gesture.view.tag);
    if(_delegate){
        [_delegate OnTapView:gesture.view.tag];
    }
}
- (void)UpdatecontainerViewAlpha:(CGFloat) offsetY {
    CGFloat alphaRatio = offsetY/(380.0f - 44);
    self.continaerView.alpha = 1.0f - alphaRatio;
//    NSLog(@"%f alphaRatio",alphaRatio);
}

-(void)SelectPageChangeAlpha{
    self.continaerView.alpha = 1;
}

-(void)ScrollToPageIndex:(NSInteger)index{
    self.continaerView.alpha = 1;
    [self.tabbar ScrollToPageIndex:index];
}

-(void)ScaleBackGroundImage:(CGFloat) offsetY{
    CGFloat scaleRatio = fabs(offsetY)/200.0f;
    CGFloat overScaleHeight = (200.0f * scaleRatio)/2;
    _BackgroundImage.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(scaleRatio + 1.0f, scaleRatio + 1.0f), CGAffineTransformMakeTranslation(0, -overScaleHeight));
}
@end
