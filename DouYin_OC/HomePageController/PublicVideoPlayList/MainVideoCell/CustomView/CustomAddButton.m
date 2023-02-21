//
//  AddButton.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/27.
//

#import "CustomAddButton.h"


@interface CustomAddButton ()<CAAnimationDelegate>

@end

@implementation CustomAddButton

- (instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, 20, 20)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self) {
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.backgroundColor = [UIColor redColor].CGColor;
        self.image = [UIImage imageNamed:@"icon_personal_add_little"];
        self.contentMode = UIViewContentModeCenter;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(beginAnimation)]];
    }
    return self;
}



-(void)beginAnimation {
    AudioServicesPlaySystemSound(1520);
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = self;
    animationGroup.duration = 1.0f;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAKeyframeAnimation *scaleAnim = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    [scaleAnim setValues:@[
                           [NSNumber numberWithFloat:1.0f],
                           [NSNumber numberWithFloat:0.7f],
                           [NSNumber numberWithFloat:0.7f],
                           [NSNumber numberWithFloat:0.7f],
                           [NSNumber numberWithFloat:1.0f],
                           [NSNumber numberWithFloat:1.0f],
                           [NSNumber numberWithFloat:1.0f],
                           [NSNumber numberWithFloat:0.0f]]];
    
    CAKeyframeAnimation * opacityAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    [opacityAnim setValues:@[
                             [NSNumber numberWithFloat:0.8f],
                             [NSNumber numberWithFloat:1.0f],
                             [NSNumber numberWithFloat:1.0f]]];
    
    [animationGroup setAnimations:@[scaleAnim,
                                    opacityAnim]];
    [self.layer addAnimation:animationGroup forKey:nil];
}


- (void)animationDidStart:(CAAnimation *)anim {
    self.userInteractionEnabled = NO;
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.backgroundColor = [UIColor redColor].CGColor;
    self.image = [UIImage imageNamed:@"iconSignDone"];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeCenter;
    [self setHidden:YES];
}


- (void)resetView {
    self.layer.backgroundColor = [UIColor redColor].CGColor;
    self.image = [UIImage imageNamed:@"icon_personal_add_little"];
    [self.layer removeAllAnimations];
    [self setHidden:NO];
}

@end
