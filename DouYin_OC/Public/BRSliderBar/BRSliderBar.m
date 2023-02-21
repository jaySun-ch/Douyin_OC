//
//  PublicSearchResultSliderBar.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//

#import "BRSliderBar.h"

#define ButtonWidth 50
#define ButtonSpaceWith 20
@interface BRSliderBar()
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) NSArray<NSString *> *array;
@property (nonatomic,strong) UIButton *MyFriendButton;
@property (nonatomic,strong) UIButton *NewFriendButton;
@property (nonatomic,strong) UIButton *AddFriendButton;
@property (nonatomic,strong) UIView *LineView;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) UIButton *fliterButton;
@end


@implementation BRSliderBar
- (instancetype)initWithFrame:(CGRect)frame Style:(BRSliderBarStyle)Style TitleArray:(NSArray<NSString *> *)TitleArray{
    self = [super initWithFrame:frame];
    if(self){
        self.clipsToBounds = YES;
        [self setUserInteractionEnabled:YES];
        self.tintColor = [UIColor blackColor];
        self.currentIndex = 0;
        self.array = TitleArray;
       
        if(Style == BRSliderBarWithScroll){
            [self initStyleWithScroll];
        }else if(Style == BRSliderBarWithfilter){
            [self initStyleWithFliter];
        }else if(Style == BRSliderBarNormal){
            [self initSetyleWithNormal];
        }
    }
    return self;
}

-(void)initSetyleWithNormal{
    CGFloat width = self.size.width / self.array.count;
    CGFloat SizeX = 0;
    for(NSInteger i = 1;i<self.array.count+1;i++){
        UIButton *button = [[UIButton alloc] init];
        button.size = CGSizeMake(width, 20);
        button.origin = CGPointMake(SizeX,(self.frame.size.height - 20) / 2);
        button.tag = i;
        [button setTitle:self.array[i-1] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:18.0 weight:UIFontWeightMedium]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(DidTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        SizeX += (width);
    }
    
    self.LineView = [[UIView alloc] init];
    self.LineView.backgroundColor = [UIColor blackColor];
    self.LineView.size = CGSizeMake(25, 2);
    [self.LineView setBottom:self.frame.size.height - 1];
    [self addSubview:self.LineView];
}

-(void)initStyleWithScroll{
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollview.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.scrollview];
    CGFloat SizeX = 20;
    for(NSInteger i = 1;i<self.array.count+1;i++){
        UIButton *button = [[UIButton alloc] init];
        button.size = CGSizeMake(ButtonWidth, 20);
        button.origin = CGPointMake(SizeX,(self.frame.size.height - 20) / 2);
        button.tag = i;
        [button setTitle:self.array[i-1] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(DidTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollview addSubview:button];
        SizeX += (ButtonWidth +ButtonSpaceWith); // 80是自身的宽度 10是每个button之间的距离
    }
    self.scrollview.contentSize  = CGSizeMake(SizeX, self.frame.size.height);
    
    self.LineView = [[UIView alloc] init];
    self.LineView.backgroundColor = [UIColor blackColor];
    self.LineView.size = CGSizeMake(60, 2);
    [self.LineView setBottom:self.frame.size.height - 1];
    [self.scrollview addSubview:self.LineView];
}


-(void)initStyleWithFliter{
    [self initStyleWithScroll];
    self.fliterButton = [[UIButton alloc] init];
    [self.fliterButton setImage:[UIImage imageNamed:@"Rrl_s_049"] forState:UIControlStateNormal];
    self.fliterButton.backgroundColor = [UIColor whiteColor];
    CGFloat size = self.frame.size.height / 4;
    self.fliterButton.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.fliterButton.layer.shadowOffset = CGSizeMake(-self.size.height / 2,0);
    self.fliterButton.layer.shadowRadius = 10;
    self.fliterButton.layer.shadowOpacity = 1;
    self.fliterButton.imageEdgeInsets = UIEdgeInsetsMake(size,size,size,size);
    self.fliterButton.size = CGSizeMake(self.size.height, self.size.height);
    [self.fliterButton setRight:self.right];
    [self addSubview:self.fliterButton];
}

-(void)DidTapButton:(UIButton *)sender{
    if(_delegate){
        [_delegate BRSliderDidTapOnButtonWithTag:sender.tag];
    }
    [self setIndex:sender.tag];
}

-(void)setIndex:(NSInteger)currentIndex{
    self.currentIndex = currentIndex;
    if(self.LineColor != nil){
        self.LineView.backgroundColor = self.LineColor;
    }
    if(self.fliterButton != nil){
        [UIView animateWithDuration:0.2f animations:^{
            if(currentIndex > 3){
                self.fliterButton.transform = CGAffineTransformMakeTranslation(150, 0);
            }else{
                self.fliterButton.transform = CGAffineTransformMakeTranslation(0, 0);
            }
        }];
    }
   
    if(self.scrollview != nil){
        for(NSInteger i = 1;i<self.array.count+1;i++){
            UIButton *button = (UIButton *)[self.scrollview viewWithTag:i];
            if(i == currentIndex){
                [self.scrollview scrollRectToVisible:CGRectMake(button.origin.x - ButtonWidth * 4, button.origin.y,ButtonWidth * 8, 20) animated:YES];
                if(self.SelectColor != nil){
                    [button setTitleColor:self.SelectColor forState:UIControlStateNormal];
                }else{
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                [UIView animateWithDuration:0.6f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.LineView setCenterX:button.centerX];
                } completion:nil];
            }else{
                if(self.NormalColor != nil){
                    [button setTitleColor:self.NormalColor forState:UIControlStateNormal];
                }else{
                    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
            }
        }
    }else{
        for(NSInteger i = 1;i<self.array.count+1;i++){
            UIButton *button = (UIButton *)[self viewWithTag:i];
            if(i == currentIndex){
                if(self.SelectColor != nil){
                    [button setTitleColor:self.SelectColor forState:UIControlStateNormal];
                }else{
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                [UIView animateWithDuration:0.6f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.LineView setCenterX:button.centerX];
                } completion:nil];
            }else{
                if(self.NormalColor != nil){
                    [button setTitleColor:self.NormalColor forState:UIControlStateNormal];
                }else{
                    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
            }
        }
    }
}

@end
