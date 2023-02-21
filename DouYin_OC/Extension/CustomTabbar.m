//
//  CustomTabbar.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/14.
//

#import "CustomTabbar.h"

@implementation CustomTabbar

-(UIButton *)PlusButton{
    if(_PlusButton == nil){
        _PlusButton = [[UIButton alloc] init];
        [_PlusButton setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];
        _PlusButton.frame = CGRectMake(0, 0, 40, 40);
        _PlusButton.tintColor = [UIColor whiteColor];
        [_PlusButton addTarget:self action:@selector(respondsToPlusButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PlusButton;
}

-(UIButton *)FristButton{
    if(_FristButton == nil){
        _FristButton = [[UIButton alloc] init];
        [_FristButton setTitle:@"首页" forState:normal];
        [_FristButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_FristButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_FristButton setSelected:YES];
        [_FristButton addTarget:self action:@selector(respondsToFirstButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _FristButton;
}

- (UIButton *)SecondButton{
    if(_SecondButton == nil){
        _SecondButton = [[UIButton alloc] init];
        [_SecondButton setTitle:@"朋友" forState:normal];
        [_SecondButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_SecondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_SecondButton addTarget:self action:@selector(respondsToSencondButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _SecondButton;
}

- (UIButton *)ThirdButton{
    if(_ThirdButton == nil){
        _ThirdButton = [[UIButton alloc] init];
        [_ThirdButton setTitle:@"消息" forState:normal];
        [_ThirdButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_ThirdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_ThirdButton addTarget:self action:@selector(respondsToThirdButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ThirdButton;
}

- (UIButton *)FourthButton{
    if(_FourthButton == nil){
        _FourthButton = [[UIButton alloc] init];
        [_FourthButton setTitle:@"我" forState:normal];
        [_FourthButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_FourthButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_FourthButton addTarget:self action:@selector(respondsToFourthButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _FourthButton;
}

-(void)respondsToPlusButton{
    if([self.delegate respondsToSelector:@selector(tabbarDidClickCustomPlusButton:)]){
        [self.myDelegate tabbarDidClickCustomPlusButton:self];
    }
}

-(void)respondsToFirstButton{
    if([self.delegate respondsToSelector:@selector(tabbarDidClickCustomHomePageButton:)]){
//        NSLog(@"1");
        [self.myDelegate tabbarDidClickCustomHomePageButton:self];
    }
}

-(void)respondsToSencondButton{
    if([self.delegate respondsToSelector:@selector(tabbarDidClickCustomFriendPageButton:)]){
//        NSLog(@"2");
        [self.myDelegate tabbarDidClickCustomFriendPageButton:self];
    }
}

-(void)respondsToThirdButton{
    if([self.delegate respondsToSelector:@selector(tabbarDidClickCustomNoitfyButton:)]){
//        NSLog(@"3");
        [self.myDelegate tabbarDidClickCustomNoitfyButton:self];
    }
}

-(void)respondsToFourthButton{
    if([self.delegate respondsToSelector:@selector(tabbarDidClickCustomAccountButton:)]){
//        NSLog(@"4");
        [self.myDelegate tabbarDidClickCustomAccountButton:self];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self addSubview:self.FristButton];
        [self addSubview:self.SecondButton];
        [self addSubview:self.PlusButton];
        [self addSubview:self.ThirdButton];
        [self addSubview:self.FourthButton];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.PlusButton.center = CGPointMake(self.frame.size.width / 2,10);
    CGFloat w = CGRectGetWidth(self.frame) / 5;
    CGFloat index = 0;
    for(UIView *childView in self.subviews){
        Class class = NSClassFromString(@"UIButton");
        if([childView isKindOfClass:class]){
            childView.frame = CGRectMake(w * index,10, w, 30);
            index ++;
        }
    }
    return;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(!self.clipsToBounds && !self.hidden && self.alpha > 0){
        UIView *result = [super hitTest:point withEvent:event];
        if(result){
            return result;
        }else{
            for(UIView *subview in self.subviews.reverseObjectEnumerator){
                CGPoint subpoint = [subview convertPoint:point toView:self];
                result = [subview hitTest:subpoint withEvent:event];
                if(result){
                    return result;
                }
            }
        }
    }
    return nil;
}

@end
