//
//  TopBar.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//

#import "TalkTopBar.h"

#define Center 50
@interface TalkTopBar()
@property (nonatomic,strong) UIView *contendView;
@property (nonatomic,strong) UIImageView *backbutton;

@property (nonatomic,strong) UIImageView *clientImage;
@property (nonatomic,strong) UILabel *clientname;
@property (nonatomic,strong) UIImageView *phoneButton;
@property (nonatomic,strong) UIImageView *VideoButton;
@property (nonatomic,strong) UIImageView *moreButton;
@end

@implementation TalkTopBar
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorNamed:@"lightgray"].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.tintColor = [UIColor blackColor];
        self.contendView = [[UIView alloc] init];
        [self addSubview:self.contendView];
        
        self.backbutton = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"]];
        [self.backbutton setUserInteractionEnabled:YES];
        [self.backbutton setTag:TalkTopBarBackButton];
        [self.backbutton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HandleTapGesture:)]];
        [self.contendView  addSubview:self.backbutton];
        
        self.label = [[UILabel alloc] init];
//        self.label.contentMode = UIViewContentModeCenter;
        self.label.textAlignment = UITextAlignmentCenter;
        self.label.textColor = [UIColor blackColor];
        self.label.layer.cornerRadius = 9;
        self.label.clipsToBounds = YES;
        self.label.backgroundColor = [UIColor colorNamed:@"lightgray"];
        [self.label setFont:[UIFont systemFontOfSize:12.0]];
        [self.contendView  addSubview:self.label];
        
        self.clientImage = [[UIImageView alloc] init];
        self.clientImage.clipsToBounds = YES;
        self.clientImage.layer.cornerRadius = 19;
        [self.contendView  addSubview:self.clientImage];
        
        self.clientname = [[UILabel alloc] init];
        [self.clientname setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        [self.contendView  addSubview:self.clientname];
        
        self.phoneButton = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"phone"]];
        self.phoneButton.contentMode = UIViewContentModeScaleAspectFit;
        [self.contendView  addSubview:self.phoneButton];
        
        self.VideoButton = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"video"]];
        self.VideoButton.contentMode = UIViewContentModeScaleAspectFit;
        [self.contendView  addSubview:self.VideoButton];
        
        self.moreButton = [[UIImageView alloc]initWithImage:[UIImage systemImageNamed:@"ellipsis"]];
        self.moreButton.contentMode = UIViewContentModeScaleAspectFit;
        [self.contendView  addSubview:self.moreButton];
        
        [self.contendView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).inset(45);
            make.bottom.equalTo(self);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(self.size.height - 45);
            make.width.mas_equalTo(self.size.width);
        }];
        
        [self.backbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contendView).inset(10);
            make.centerY.equalTo(self.contendView);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(25);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backbutton.mas_right).inset(5);
            make.centerY.equalTo(self.contendView);
            make.width.height.mas_equalTo(18);
        }];
        
        [self.clientImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label.mas_right).inset(5);
            make.centerY.equalTo(self.contendView);
            make.width.height.mas_equalTo(38);
        }];
        
        [self.clientname mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clientImage.mas_right).inset(5);
            make.centerY.equalTo(self.contendView);
            make.height.mas_equalTo(20);
        }];
        
        [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(10);
            make.centerY.equalTo(self.contendView);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(25);
        }];
        
        [self.VideoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.moreButton.mas_left).inset(10);
            make.centerY.equalTo(self.contendView);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(30);
        }];
        
        [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.VideoButton.mas_left).inset(10);
            make.centerY.equalTo(self.contendView);
            make.width.mas_equalTo(25);
            make.height.mas_equalTo(25);
        }];
    }
    return self;
}


-(void)HandleTapGesture:(UITapGestureRecognizer *)gesture{
    if(_delegate){
        [_delegate TopBarDidTapOnView:gesture.view.tag];
    }
}


-(void)SetData:(NSString *)imageurl name:(NSString *)name{
    [self.clientImage setImageWithURL:[NSURL URLWithString:imageurl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [self.clientname setText:name];
}
@end
