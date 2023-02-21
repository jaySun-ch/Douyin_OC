//
//  EditAccountHeaderCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/4.
//

#import "EditAccountHeaderCell.h"
#import "CustomProgressView.h"

@interface EditAccountHeaderCell()

@property (nonatomic,strong) UIImageView *backgroundImage;
@property (nonatomic,strong) UIView *continaer;
@property (nonatomic,strong) UIImageView *clientImage;
@property (nonatomic,strong) UIView *carmaerbackground;
@property (nonatomic,strong) UIImageView *carmaer;
@property (nonatomic,strong) UIButton *changeClientImageButton;
@property (nonatomic,strong) CustomProgressView *progreesView;
@end

@implementation EditAccountHeaderCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundImage = [[UIImageView alloc] init];
        self.backgroundImage.tag = HeaderClientBackground;
        [self.backgroundImage setUserInteractionEnabled:YES];
        [self.backgroundImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGesture:)]];
        [self.contentView addSubview:self.backgroundImage];
        
        self.continaer = [[UIView alloc]init];
        self.continaer.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.continaer];
        
        self.clientImage = [[UIImageView alloc] init];
        self.clientImage.layer.cornerRadius = 50;
        self.clientImage.clipsToBounds = YES;
        self.clientImage.contentMode = UIViewContentModeScaleAspectFill;
        self.clientImage.layer.borderWidth = 3;
        self.clientImage.layer.borderColor = [UIColor whiteColor].CGColor;
        
        
        self.carmaerbackground = [[UIView alloc] init];
        self.carmaerbackground.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3];
        self.carmaer = [[UIImageView alloc]initWithImage:[UIImage systemImageNamed:@"camera.fill"]];
        [self.carmaer setTintColor:[UIColor whiteColor]];
        [self.carmaerbackground addSubview:self.carmaer];
        [self.clientImage addSubview:self.carmaerbackground];
        [self.clientImage setUserInteractionEnabled:YES];
        self.clientImage.tag = HeaderClientImage;
        [self.clientImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapGesture:)]];
        [self.contentView addSubview:self.clientImage];
        
        self.changeClientImageButton = [[UIButton alloc] init];
        [self.changeClientImageButton setTitle:@"点击更换头像" forState:UIControlStateNormal];
        [self.changeClientImageButton.titleLabel setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
        [self.changeClientImageButton addTarget:self action:@selector(ShowSelect) forControlEvents:UIControlEventTouchUpInside];
        [self.changeClientImageButton setTitleColor:[UIColor colorNamed:@"linkcolor"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.changeClientImageButton];
        
        self.progreesView = [[CustomProgressView alloc] init];
        [self.continaer addSubview:self.progreesView];
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, 1000) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(12, 12)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.contentView.frame;
        maskLayer.path = maskPath.CGPath;
        self.continaer.layer.mask = maskLayer;
        
        [self.backgroundImage  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).inset(90);
            make.left.equalTo(self);
            make.width.mas_equalTo(ScreenWidth);
            make.height.mas_equalTo(200);
        }];
        
        [self.continaer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ScreenWidth);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(120);
        }];
        
        [self.clientImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(100);
            make.centerX.equalTo(self.continaer);
            make.centerY.equalTo(self.continaer.mas_top);
        }];
        
        [self.carmaerbackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(100);
        }];
        
        [self.carmaer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(40);
            make.center.equalTo(self.carmaerbackground);
        }];
        
        [self.changeClientImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.continaer);
            make.top.equalTo(self.clientImage.mas_bottom).inset(15);
            make.height.mas_equalTo(20);
        }];
        
        [self.progreesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.continaer).inset(10);
            make.right.equalTo(self.continaer).inset(10);
            make.width.mas_equalTo(110);
            make.height.mas_equalTo(50);
        }];
    }
    return self;
}


-(void)initSubView{
    [self.backgroundImage setImageWithURL:[NSURL URLWithString:[AppUserData GetCurrenUser].BackGroundImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [self.clientImage setImageWithURL:[NSURL URLWithString:[AppUserData GetCurrenUser].ClientImageUrl] options:YYWebImageOptionSetImageWithFadeAnimation];
    [self.progreesView UpdateProgress];
}

-(void)UpdateProgress{
    [self.progreesView UpdateProgress];
}

-(void)ShowSelect{
    if(_delegate){
        [_delegate onUserActionTap:HeaderClientImage];
    }
}

-(void)TapGesture:(UITapGestureRecognizer *)sender{
    if(_delegate){
        [_delegate onUserActionTap:sender.view.tag];
    }
}

-(void)OffsetBackGroundImage{
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.backgroundImage.transform = CGAffineTransformMakeTranslation(0, ScreenHeight / 2);
    } completion:nil];
}



-(void)ScaleBackGroundImage:(CGFloat) offsetY{
    CGFloat scaleRatio = fabs(offsetY)/200.0f;
    CGFloat overScaleHeight = (200.0f * scaleRatio)/2;
    if(scaleRatio < 0.2){
         self.backgroundImage.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0f, 1.0f), CGAffineTransformMakeTranslation(0, -overScaleHeight));
    }else{
        self.backgroundImage.transform = CGAffineTransformConcat(CGAffineTransformMakeScale((scaleRatio - 0.2) + 1.0f , (scaleRatio - 0.2) + 1.0f), CGAffineTransformMakeTranslation(0, -overScaleHeight));
    }
}


@end
