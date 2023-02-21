//
//  PlayProgreeBar.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/19.
//

#import "PlayProgreeBar.h"

@interface PlayProgreeBar()
@property (nonatomic,strong) UIView *ProgressBackground;
@property (nonatomic,strong) UIView *Dot;
@property (nonatomic,assign) CGFloat Progress;
@end


@implementation PlayProgreeBar


- (instancetype)init{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(GestureHandler:)]];
        self.Progress = 0;
        self.ProgressBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth * self.Progress, 3)];
        self.ProgressBackground.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
        [self addSubview:self.ProgressBackground];
        
        self.Dot = [[UIView alloc] initWithFrame:CGRectMake(1,0,4,4)];
        self.Dot.layer.cornerRadius = 2;
        self.Dot.centerX = self.Progress * ScreenWidth;
        self.Dot.centerY = self.ProgressBackground.centerY;
        
        self.Dot.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f block:^(NSTimer * _Nonnull timer) {
//
//            if(self.Progress == 0.95){
//                [self.timer invalidate];
//            }
//            self.Progress += 0.01;
//        } repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [self addSubview:self.Dot];
    }
    return self;
}

- (void)resetView{
    self.Progress = 0;
    self.ProgressBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth * self.Progress, 3)];
    self.Dot.centerX = self.Progress * ScreenWidth;
}

-(void)FocusOnPlaybar{
    if(self.ProgressBackground.height == 3){
        self.ProgressBackground.height = 5;
        self.Dot.size = CGSizeMake(10, 10);
        self.Dot.layer.cornerRadius = 5;
        self.ProgressBackground.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
        self.Dot.backgroundColor = [UIColor whiteColor];
        
    }else{
        self.ProgressBackground.height = 3;
        self.ProgressBackground.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
        self.Dot.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
        self.Dot.size = CGSizeMake(5, 5);
        self.Dot.layer.cornerRadius = 2.5;
    }
    self.Dot.centerY = self.ProgressBackground.centerY;

}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(ScreenWidth, 10);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    NSLog(@"%f %f pointInside",point.y,point.x);
    UIEdgeInsets changeInsets = UIEdgeInsetsMake(15,0,0, 15);
    CGRect myBounds = self.bounds;
    myBounds.origin.x = myBounds.origin.x;
    myBounds.origin.y = myBounds.origin.y - changeInsets.top;
    myBounds.size.width = myBounds.size.width;
    myBounds.size.height = myBounds.size.height + changeInsets.top + changeInsets.bottom;
    NSLog(@"%f %f pointInside",point.y,point.x);
    NSLog(@"%f %f %f %f pointInside",myBounds.origin.y,myBounds.origin.x,myBounds.size.width,myBounds.size.height);
    NSLog(CGRectContainsPoint(myBounds, point) ? @"In":@"Not IN");
    return CGRectContainsPoint(myBounds, point);
}

-(void)GestureHandler:(UIPanGestureRecognizer *)gesture{
    if(_delegate){
        [_delegate DidDragOnPlayBar:gesture.state];
    }
    if(gesture.state == UIGestureRecognizerStateChanged){
        CGPoint trans = [gesture locationInView:self];
        if(self.Progress >= 0 && self.Progress <= 1){
            CGFloat value = (trans.x / ScreenWidth);
            self.Progress =  value >= 1.0 ? 1.0 : value <= 0.0 ? 0.0 : value;
            NSLog(@"%f transGestureHandler",self.Progress);
            [self ChangeWithProgress:self.Progress];
            if(self.delegate){
                [self.delegate DidChangePlayBar:self.Progress];
            }
        }
        self.ProgressBackground.height = 5;
        self.Dot.size = CGSizeMake(10, 10);
        self.Dot.layer.cornerRadius = 5;
        self.ProgressBackground.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
        self.Dot.backgroundColor = [UIColor whiteColor];
    }else if(gesture.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.2f animations:^{
            if(self.delegate){
                [self.delegate EndDragToProgress:self.Progress];
            }
            self.ProgressBackground.height = 3;
            self.ProgressBackground.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
            self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
            self.Dot.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4];
            self.Dot.size = CGSizeMake(5, 5);
            self.Dot.layer.cornerRadius = 2.5;
        }];
    }
    self.Dot.centerY = self.ProgressBackground.centerY;
}



-(void)ChangeWithProgress:(CGFloat)Progress{
    [UIView animateWithDuration:0.05f animations:^{
        self.ProgressBackground.width = ScreenWidth * Progress;
        self.Dot.centerX = Progress * ScreenWidth;
    }];
}


@end
