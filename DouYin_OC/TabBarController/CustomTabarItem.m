//
//  CustomTabarItem.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/15.
//

#import "CustomTabarItem.h"

@interface CustomTabarItem()
@property (nonatomic,strong) UIBezierPath * path;
@property (nonatomic,strong) CAShapeLayer * mask;
@end

@implementation CustomTabarItem

- (instancetype)init{
    self = [super init];
    return self;
}

- (instancetype)initWithTitle:(NSString *)titles{
    self = [super init];
//    self.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@",titles);
    self.labelText = [[UILabel alloc]init];
    self.labelText.textAlignment = NSTextAlignmentCenter;
    [self.labelText setText:titles];
    [self.labelText setFont:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]];
    [self addSubview:self.labelText];
//    self.labelText.backgroundColor = [UIColor grayColor];
    [self.labelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.mas_equalTo(18);
    }];
    
    self.badge = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    self.badge.backgroundColor = [UIColor redColor];
    self.badge.alpha = 0;
    [self.badge setFont:[UIFont systemFontOfSize:10.0]];
    [self.badge setTextColor:[UIColor whiteColor]];
    self.badge.textAlignment = NSTextAlignmentCenter;
    self.badge.clipsToBounds = YES;
    [self addSubview:self.badge];
   
    return self;
}

-(void)SetBadgeWithBadge:(NSInteger)badge{
    if(badge == 0){
        self.badge.alpha = 0;
    }else{
        self.badge.alpha = 1;
        [self.badge setText:[NSString stringWithFormat:@"%ld",badge]];
        CGSize TextSize = [self.badge.text singleLineSizeWithText:[UIFont systemFontOfSize:12.0]];
        CGFloat Width = TextSize.width + 3;
        if(Width < 15){
            self.badge.layer.cornerRadius = 15/2;
            [self.badge mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.labelText.mas_top).inset(3);
                make.centerX.equalTo(self.labelText.mas_right).inset(3);
                make.width.height.mas_equalTo(15);
            }];
        }else{
            self.badge.layer.cornerRadius = Width/2;
            [self.badge mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.labelText.mas_top).inset(-10);
                make.left.equalTo(self.labelText.mas_right).inset(-10);
                make.width.height.mas_equalTo(Width);
            }];
//            if(Width < 30){
//                self.badge.layer.cornerRadius = Width/2;
//                [self.badge mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.centerY.equalTo(self.labelText.mas_top).inset(3);
//                    make.centerX.equalTo(self.labelText.mas_right).inset(3);
//                    make.width.height.mas_equalTo(Width);
//                }];
//            }else{
//                
//            }
        }
        
    }
}


- (instancetype)initWithImage:(UIImage *)image{
    self = [super init];
//    self.backgroundColor = [UIColor redColor];
    self.CurrentImageView = [[UIImageView alloc] init];
    self.CurrentImageView.tintColor = self.tintColor;
    [self.CurrentImageView setImage:image];
    self.CurrentImageView.contentMode = UIViewContentModeScaleAspectFit;
    UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightBold];
    [self.CurrentImageView.image setValue:configuration forKey:@"configuration"];
    [self.CurrentImageView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.CurrentImageView];
    CGFloat width = (ScreenWidth - (6) * 10) / 5;
    self.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((width - 35)/2,(35 - 25)/2,35,28) cornerRadius:8.f];
    self.mask = [[CAShapeLayer alloc] init];
    _mask.lineWidth = 2;
    _mask.lineCap = kCALineCapSquare;
    _mask.strokeColor = [UIColor whiteColor].CGColor;
    _mask.fillColor = [UIColor clearColor].CGColor;
    _mask.path = _path.CGPath;
    [self.layer addSublayer:_mask];
    
    [self.CurrentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    return self;
}

-(void)changeImagecolor:(UIColor*)tintColor{
    self.CurrentImageView.tintColor = tintColor;
    if(_mask.strokeColor != tintColor.CGColor){
        [self.mask removeFromSuperlayer];
        _mask.strokeColor =  tintColor.CGColor;
        [self.layer addSublayer:_mask];
    }
}

- (void)setItemSelected:(BOOL)itemSelect tintColor:(UIColor*)tintColor{
    if(self.labelText != nil){
        if(itemSelect){
            [self.labelText setTextColor:tintColor];
        }else{
            [self.labelText setTextColor:[UIColor lightGrayColor]];
        }
    }
}
@end
