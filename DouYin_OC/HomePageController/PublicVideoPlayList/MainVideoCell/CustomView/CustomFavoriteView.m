//
//  CustomFavoriteView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/17.
//

#import "CustomFavoriteView.h"

#define ColorThemeRed RGB(241.0, 47.0, 84.0, 1.0)

static const NSInteger LikeBefore  = 0x01;
static const NSInteger LikeAfter   = 0x02;

@implementation CustomFavoriteView

- (instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0,35, 35)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _favoriteBefore = [[UIImageView alloc]initWithFrame:frame];
        _favoriteBefore.image = [UIImage imageNamed:@"icon_home_like_before"];
        _favoriteBefore.userInteractionEnabled = YES;
        _favoriteBefore.tag = LikeBefore;
        [_favoriteBefore addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_favoriteBefore];
        
        _favoriteAfter = [[UIImageView alloc]initWithFrame:frame];
        _favoriteAfter.image = [UIImage imageNamed:@"icon_home_like_after"];
        _favoriteAfter.userInteractionEnabled = YES;
        _favoriteAfter.tag = LikeAfter;
        [_favoriteAfter setHidden:YES];
        [_favoriteAfter addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
        [self addSubview:_favoriteAfter];
        
        _favoriteAfter.center = self.center;
        _favoriteBefore.center = self.center;
    }
    return self;
}

-(void)handleGesture:(UITapGestureRecognizer *)sender {
    switch(sender.view.tag){
        case LikeBefore:{
            [self startLikeAnim:YES];
            _isFavorite = YES;
            break;
        }
        case LikeAfter:{
            [self startLikeAnim:NO];
            _isFavorite = NO;
            break;
        }
    }
}

-(void)startLikeAnim:(BOOL)isLike {
   
    _favoriteBefore.userInteractionEnabled = NO;
    _favoriteAfter.userInteractionEnabled = NO;
    if(isLike) {
        AudioServicesPlaySystemSound(1520);
        CGFloat length = 30;
        CGFloat duration = 0.5;
        for(int i=0;i<6;i++) {
            CAShapeLayer *layer = [[CAShapeLayer alloc]init];
            layer.position = _favoriteBefore.center;
            layer.fillColor = [UIColor systemPinkColor].CGColor;
            
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
        layer.center = _favoriteBefore.center;
        layer.lineWidth = 5;
        layer.strokeColor = [UIColor systemPinkColor].CGColor;
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
        
        
        _favoriteBefore.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.2f animations:^{
            // 先让之前的消失
            self.favoriteBefore.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
        }completion:^(BOOL finished) {
            [self.favoriteAfter setHidden:NO];
            self.favoriteAfter.alpha = 0.0f;
            self.favoriteAfter.transform = CGAffineTransformMakeScale( 0.5f, 0.5f);
            
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                 usingSpringWithDamping:0.6f
                  initialSpringVelocity:0.8f
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^{
                                 layer.lineWidth = 0;
                                 self.favoriteAfter.alpha = 1.0f;
                                 self.favoriteAfter.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                             }
                             completion:^(BOOL finished) {
                                 self.favoriteBefore.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                                 self.favoriteBefore.userInteractionEnabled = YES;
                                 self.favoriteAfter.userInteractionEnabled = YES;
                             }];
        }];
        
       
    }else {
        _favoriteAfter.alpha = 1.0f;
        _favoriteAfter.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        [UIView animateWithDuration:0.15f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.favoriteAfter.transform = CGAffineTransformMakeScale( 0.1f, 0.1f);
                         }
                         completion:^(BOOL finished) {
                             [self.favoriteAfter setHidden:YES];
                             self.favoriteBefore.userInteractionEnabled = YES;
                             self.favoriteAfter.userInteractionEnabled = YES;
                         }];
    }
}

- (void)resetView{
    [_favoriteBefore setHidden:NO];
    [_favoriteAfter setHidden:YES];
    [self.layer removeAllAnimations];
}

@end

