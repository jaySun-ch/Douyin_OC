//
//  CustomProgressView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/4.
//

#import "CustomProgressView.h"

@interface CustomProgressView()
@property (nonatomic,strong) UIView *progressView;
@property (nonatomic,strong) UIView *progressBackGround;
@property (nonatomic,strong) UILabel *ProgressCount;
@property (nonatomic,assign) NSInteger mainprogress;
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation CustomProgressView


- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, 110, 40)];
    if(self){
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
//    self.mainprogress = [[AppUserData GetCurrenUser] getCurrentProgress];
    [self setBackgroundColor:[UIColor colorNamed:@"lightgray"]];
    self.layer.cornerRadius = 10;
    self.ProgressCount = [[UILabel alloc] init];
    [self.ProgressCount setTextColor:[UIColor purpleColor]];
    [self.ProgressCount setFont:[UIFont systemFontOfSize:10.0]];
    [self addSubview:self.ProgressCount];
    
    self.progressBackGround = [[UIView alloc]init];
    self.progressBackGround.layer.cornerRadius = 5;
    self.progressBackGround.layer.cornerCurve = kCACornerCurveContinuous;
    [self.progressBackGround setBackgroundColor:[UIColor colorNamed:@"purple"]];
    self.progressBackGround.clipsToBounds = YES;
    [self addSubview:self.progressBackGround];
    
    self.progressView = [[UIView alloc] init];
    self.progressView.layer.cornerRadius = 5;
    self.progressView.layer.cornerCurve = kCACornerCurveContinuous;
    self.progressView.clipsToBounds = YES;
    [self.progressBackGround addSubview:self.progressView];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"资料完成度"];
    [label setFont:[UIFont systemFontOfSize:10.0]];
    [self addSubview:label];
    
    [self.progressBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).inset(10);
        make.top.equalTo(self).inset(10);
        make.width.mas_equalTo(self.frame.size.width - 20);
        make.height.mas_equalTo(10);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressBackGround.mas_bottom).inset(10);
        make.left.equalTo(self).inset(10);
        make.height.mas_equalTo(10);
    }];
    
    [self.ProgressCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progressBackGround.mas_bottom).inset(10);
        make.left.equalTo(label.mas_right);
        make.height.mas_equalTo(10);
    }];
}



-(void)UpdateProgress{
    self.progress = 0;
    NSLog(@"%ld mainprogress",self.mainprogress);
    if(![self.ProgressCount.text isEqualToString:[NSString stringWithFormat:@"%ld%@",[[AppUserData GetCurrenUser] getCurrentProgress],@"%"]]){
        [self.progressView removeFromSuperview];
//        [self.ProgressCount setText:@"0%"];
        CAGradientLayer *Gradientlayer = [CAGradientLayer layer];
        Gradientlayer.frame = CGRectMake(0, 0,[[AppUserData GetCurrenUser] getCurrentProgress] * self.frame.size.width / 100, 10);
        Gradientlayer.colors = @[(__bridge id)[UIColor colorNamed:@"darkpuple"].CGColor,(__bridge id)[UIColor colorNamed:@"pink"].CGColor];
        double a = [[AppUserData GetCurrenUser] getCurrentProgress] / 100;
        Gradientlayer.locations = @[@(a / 2)];
        Gradientlayer.startPoint = CGPointMake(0, 0);
        Gradientlayer.endPoint = CGPointMake(1, 0);
        Gradientlayer.cornerRadius = 5;
        Gradientlayer.cornerCurve = kCACornerCurveContinuous;
        [self.progressView.layer addSublayer:Gradientlayer];
        [self.progressBackGround addSubview:self.progressView];
        NSLog(@"%ld mainprogress",self.mainprogress);
        self.progressView.frame = CGRectMake(0, 0,(self.mainprogress * (self.frame.size.width - 20)) / 100,10);
        [self performSelector:@selector(StartAnimation) withObject:nil afterDelay:0.5f];
        self.mainprogress = [[AppUserData GetCurrenUser] getCurrentProgress];
    }
}

-(void)StartAnimation{
    [UIView animateWithDuration:1.0f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.progressView.frame = CGRectMake(0, 0, ([[AppUserData GetCurrenUser] getCurrentProgress] * (self.frame.size.width - 20)) / 100, 10);
    } completion:nil];
    self.timer = [NSTimer timerWithTimeInterval:0.01f target:self selector:@selector(TimeAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)TimeAction{
    self.progress += 1;
    [self.ProgressCount setText:[NSString stringWithFormat:@"%.0f%@",self.progress,@"%"]];
    if(self.progress == self.mainprogress){
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
