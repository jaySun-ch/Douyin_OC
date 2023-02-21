//
//  CustomStarView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/19.
//
#import "CustomStarView.h"


static const NSInteger StarBefore  = 0x01;
static const NSInteger StarAfter   = 0x02;

@implementation CustomStarView

- (instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, 35, 35)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _starBefore = [[UIImageView alloc]initWithFrame:frame];
        _starBefore.contentMode = UIViewContentModeScaleAspectFit;
        _starBefore.image = [UIImage systemImageNamed:@"star.fill"];
       
        _starBefore.tintColor = [UIColor whiteColor];
        _starBefore.userInteractionEnabled = YES;
        _starBefore.tag = StarBefore;
        [_starBefore addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_starBefore];
        
        _starAfter = [[UIImageView alloc]initWithFrame:frame];
        _starAfter.contentMode = UIViewContentModeScaleAspectFit;
        _starAfter.image = [UIImage systemImageNamed:@"star.fill"];
        _starAfter.tintColor = [UIColor colorNamed:@"yellow"];
        _starAfter.userInteractionEnabled = YES;
        _starAfter.tag = StarAfter;
        [_starAfter setHidden:YES];
        [_starAfter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_starAfter];
        
        _starAfter.center = self.center;
        _starBefore.center = self.center;
    }
    return self;
}

-(void)handleGesture:(UITapGestureRecognizer *)sender {
    switch(sender.view.tag){
        case StarBefore:{
            [self startLikeAnim:YES];
            _isStar = YES;
            break;
        }
        case StarAfter:{
            [self startLikeAnim:NO];
            _isStar = NO;
            break;
        }
    }
}



-(void)startLikeAnim:(BOOL)isLike {
   
    _starBefore.userInteractionEnabled = NO;
    _starAfter.userInteractionEnabled = NO;
    if(isLike) {
        AudioServicesPlaySystemSound(1520);
        CGFloat length = 30;
        CGFloat duration = 0.5;
        for(int i=0;i<6;i++) {
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];
            layer.position = _starBefore.center;
            layer.fillColor = [UIColor colorNamed:@"yellow"].CGColor;
            
            UIBezierPath *startPath = [UIBezierPath bezierPath];
            [startPath moveToPoint:CGPointMake(-2, -length)];
            [startPath addLineToPoint:CGPointMake(2, -length)];
            [startPath addLineToPoint:CGPointMake(0, 0)];
            
            UIBezierPath *endPath = [UIBezierPath bezierPath];
            [endPath moveToPoint:CGPointMake(-2, -length)];
            [endPath addLineToPoint:CGPointMake(2, -length)];
            [endPath addLineToPoint:CGPointMake(0, -length)];

            layer.path = startPath.CGPath;
            layer.transform = CATransform3DMakeRotation(M_PI / 3.0f * i, 0.0, 0.0, 1.0);
            [self.layer addSublayer:layer];
            
            CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
            group.removedOnCompletion = NO;
            group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            group.fillMode = kCAFillModeForwards;
            group.duration = duration;
            
            CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnim.fromValue = @(0.0);
            scaleAnim.toValue = @(1.0);
            scaleAnim.duration = duration * 0.2f;
            
            CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnim.fromValue = (__bridge id)layer.path;
            pathAnim.toValue = (__bridge id)endPath.CGPath;
            pathAnim.beginTime = duration * 0.2f;
            pathAnim.duration = duration * 0.8f;
            
            [group setAnimations:@[scaleAnim, pathAnim]];
            [layer addAnimation:group forKey:nil];
        }
        
        CAShapeLayer *layer = [[CAShapeLayer alloc]init];
        layer.center = _starBefore.center;
        layer.lineWidth = 5;
        layer.strokeColor = [UIColor colorNamed:@"yellow"].CGColor;
        layer.strokeStart = 0;
        layer.strokeEnd = 50;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.path = [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(-25,-25, 50, 50)] CGPath];
        [self.layer addSublayer:layer];
        
        CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
        group.removedOnCompletion = NO;
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        group.fillMode = kCAFillModeForwards;
        group.duration = duration;
        
        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnim.fromValue = @(0.0);
        scaleAnim.toValue = @(1.0);
        scaleAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnim.fillMode = kCAFillModeForwards;
        scaleAnim.duration = duration;
        [layer addAnimation:scaleAnim forKey:nil];
        
        
        _starBefore.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.2f animations:^{
            // 先让之前的消失
            self.starBefore.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
        }completion:^(BOOL finished) {
            [self.starAfter setHidden:NO];
            self.starAfter.alpha = 0.0f;
            self.starAfter.transform = CGAffineTransformMakeScale( 0.5f, 0.5f);
            
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                 usingSpringWithDamping:0.6f
                  initialSpringVelocity:0.8f
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 layer.lineWidth = 0;
                                 self.starAfter.alpha = 1.0f;
                                 self.starAfter.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                             }
                             completion:^(BOOL finished) {
                                 self.starBefore.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                 self.starBefore.userInteractionEnabled = YES;
                                 self.starAfter.userInteractionEnabled = YES;
                             }];
        }];
        
       
    }else {
        _starAfter.alpha = 1.0f;
        _starAfter.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.15f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.starAfter.transform = CGAffineTransformMakeScale( 0.1f, 0.1f);
                         }
                         completion:^(BOOL finished) {
                             [self.starAfter setHidden:YES];
                             self.starBefore.userInteractionEnabled = YES;
                             self.starAfter.userInteractionEnabled = YES;
                         }];
    }
}


- (void)resetView{
    [_starBefore setHidden:NO];
    [_starAfter setHidden:YES];
    [self.layer removeAllAnimations];
}

@end

