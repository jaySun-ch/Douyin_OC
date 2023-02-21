//
//  CustomLoadView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/7.
//

#import " CustomLoadView.h"

#define CircleWidth 10

@interface CustomLoadView()
@property (nonatomic,strong) UIView *redCircle;
@property (nonatomic,strong) UIView *blueCircle;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) double progress1;
@property (nonatomic,assign) double progress2;
@property (nonatomic,assign) double progress3;
@property (nonatomic,assign) double progress4;
@end

@implementation CustomLoadView

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0,CircleWidth * 2 + 6,30)];
    if(self){
        self.progress1 = 1;
        self.progress2 = 1;
        self.backgroundColor = [UIColor clearColor];
        self.redCircle = [[UIView alloc] init];
        self.redCircle.backgroundColor = [UIColor redColor];
        self.redCircle.alpha = 0.8;
        self.blueCircle = [[UIView alloc]init];
        self.blueCircle.backgroundColor = [UIColor cyanColor];
        self.redCircle.layer.cornerRadius = CircleWidth / 2;
        self.blueCircle.layer.cornerRadius = CircleWidth / 2;
        self.blueCircle.alpha = 0.8;
        [self addSubview:self.redCircle];
        [self addSubview:self.blueCircle];
        [self.redCircle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).inset(2);
            make.width.height.mas_equalTo(CircleWidth);
        }];
        [self.blueCircle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.redCircle.mas_right).inset(2);
            make.width.height.mas_equalTo(CircleWidth);
        }];
        
        NSLog(@"%f %f ad",self.blueCircle.bounds.origin.x,self.blueCircle.bounds.origin.y);
//        [self Animation];
        [self AddCoreAnimationRed];
        [self AddCoreAnimationBlue];
    }
    return self;
}


-(void)Animation{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5f repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(self.progress2 == 1){
            self.progress2 = 0;
            self.progress3 = 1.1;
            self.progress4 = 1.0;
        }else{
            self.progress2 = 1;
            self.progress3 = 1.0;
            self.progress4 = 1.1;
        }
        self.progress1 = 0;
        NSLog(@"%f",self.progress1);
        [UIView animateWithDuration:0.5f animations:^{
            self.redCircle.transform3D = CATransform3DTranslate(CATransform3DMakeScale(self.progress3,self.progress3,1), 10 * self.progress2,0,1 * self.progress1);
            self.blueCircle.transform3D = CATransform3DTranslate(CATransform3DMakeScale(self.progress4,self.progress4,1), -10 * self.progress2,0,-1 * self.progress1);
        }];
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}


-(void)AddCoreAnimationRed{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 0.8f;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.beginTime = CACurrentMediaTime();
    group.repeatCount = MAXFLOAT;
    
    CAKeyframeAnimation *keyanimation1 = [CAKeyframeAnimation animation];
    keyanimation1.keyPath = @"transform.scale";
    [keyanimation1 setValues:@[
        [NSNumber numberWithFloat:1.0],
        [NSNumber numberWithFloat:1.5],
        [NSNumber numberWithFloat:1.0],
        [NSNumber numberWithFloat:0.8],
        [NSNumber numberWithFloat:1.0]
    ]];
    
    CAKeyframeAnimation *keyanimation2 = [CAKeyframeAnimation animation];
    keyanimation2.keyPath = @"transform.rotation.z";
    [keyanimation2 setValues:@[
        [NSNumber numberWithFloat:0],
        [NSNumber numberWithFloat:M_PI / 2],
        [NSNumber numberWithFloat:0],
        [NSNumber numberWithFloat:-M_PI / 2],
        [NSNumber numberWithFloat:0],
    ]];
    
    
    CAKeyframeAnimation *keyanimaion3 = [CAKeyframeAnimation animation];
    keyanimaion3.keyPath = @"position";
    [keyanimaion3 setValues:@[
        [NSValue valueWithCGPoint:CGPointMake(2, 15)],
        [NSValue valueWithCGPoint:CGPointMake(8, 15)],
        [NSValue valueWithCGPoint:CGPointMake(14, 15)],
        [NSValue valueWithCGPoint:CGPointMake(8, 15)],
        [NSValue valueWithCGPoint:CGPointMake(2, 15)]
    ]];

    
    CAKeyframeAnimation *keyanimaion4 = [CAKeyframeAnimation animation];
    keyanimaion4.keyPath = @"zPosition";
    [keyanimaion4 setValues:@[
        @(99),
        @(99),
        @(99),
        @(1),
        @(99),
    ]];
    
    [group setAnimations:@[keyanimation1,keyanimation2,keyanimaion3,keyanimaion4]];
    
    [self.redCircle.layer addAnimation:group forKey:@"newanimation"];
}

-(void)AddCoreAnimationBlue{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 0.8f;
    group.removedOnCompletion = NO;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.fillMode = kCAFillModeForwards;
    group.beginTime = CACurrentMediaTime();
    group.repeatCount = MAXFLOAT;
    
    CAKeyframeAnimation *keyanimation1 = [CAKeyframeAnimation animation];
    keyanimation1.keyPath = @"transform.scale";
    [keyanimation1 setValues:@[
        [NSNumber numberWithFloat:1.0],
        [NSNumber numberWithFloat:0.8],
        [NSNumber numberWithFloat:1.0],
        [NSNumber numberWithFloat:1.5],
        [NSNumber numberWithFloat:1.0],
    ]];
    
    CAKeyframeAnimation *keyanimation2 = [CAKeyframeAnimation animation];
    keyanimation2.keyPath = @"transform.rotation.z";
    [keyanimation2 setValues:@[
        [NSNumber numberWithFloat:0],
        [NSNumber numberWithFloat:-M_PI / 2],
        [NSNumber numberWithFloat:0],
        [NSNumber numberWithFloat:M_PI / 2],
        [NSNumber numberWithFloat:0]
    ]];
    
    CAKeyframeAnimation *keyanimaion3 = [CAKeyframeAnimation animation];
    keyanimaion3.keyPath = @"position";
    [keyanimaion3 setValues:@[
        [NSValue valueWithCGPoint:CGPointMake(14, 15)],
        [NSValue valueWithCGPoint:CGPointMake(8, 15)],
        [NSValue valueWithCGPoint:CGPointMake(2, 15)],
        [NSValue valueWithCGPoint:CGPointMake(8, 15)],
        [NSValue valueWithCGPoint:CGPointMake(14, 15)]
    ]];
    
    CAKeyframeAnimation *keyanimaion4 = [CAKeyframeAnimation animation];
    keyanimaion4.keyPath = @"zPosition";
    [keyanimaion4 setValues:@[
        @(99),
        @(1),
        @(99),
        @(99),
        @(99),
    ]];
    [group setAnimations:@[keyanimation1,keyanimation2,keyanimaion3,keyanimaion4]];
    [self.blueCircle.layer addAnimation:group forKey:@"newanimation"];
}

-(void)StartAnimation{
    
}

-(void)dismissAnimation{
    [self.layer removeAllAnimations];
}

@end

