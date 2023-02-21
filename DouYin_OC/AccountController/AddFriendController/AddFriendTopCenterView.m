//
//  AddFriendTopBar.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//

#import "AddFriendTopCenterView.h"

@interface AddFriendTopCenterView()
@property (nonatomic,strong) UIButton *MyFriendButton;
@property (nonatomic,strong) UIButton *NewFriendButton;
@property (nonatomic,strong) UIButton *AddFriendButton;
@property (nonatomic,strong) UIView *LineView;
@property (nonatomic,assign) NSInteger currentIndex;
@end


@implementation AddFriendTopCenterView

- (instancetype)initWithIndex:(NSInteger)index{
    self = [super init];
    if(self){
        [self setUserInteractionEnabled:YES];
//        self.backgroundColor = [UIColor redColor];
        self.currentIndex = index;
        self.tintColor = [UIColor blackColor];
        self.MyFriendButton = [[UIButton alloc] init];
        self.MyFriendButton.tag = 0;
        [self.MyFriendButton setTitle:@"朋友" forState:UIControlStateNormal];
        [self.MyFriendButton.titleLabel setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
        [self.MyFriendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.MyFriendButton addTarget:self action:@selector(DidTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.MyFriendButton];
        
        self.NewFriendButton = [[UIButton alloc] init];
        self.NewFriendButton.tag = 1;
        [self.NewFriendButton setTitle:@"新朋友" forState:UIControlStateNormal];
        [self.NewFriendButton.titleLabel setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
        [self.NewFriendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.NewFriendButton addTarget:self action:@selector(DidTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.NewFriendButton];
        
        self.AddFriendButton = [[UIButton alloc] init];
        self.AddFriendButton.tag = 2;
        [self.AddFriendButton setTitle:@"添加朋友" forState:UIControlStateNormal];
        [self.AddFriendButton.titleLabel setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
        [self.AddFriendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.AddFriendButton addTarget:self action:@selector(DidTapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.AddFriendButton];
        
        self.LineView = [[UIView alloc] init];
        self.LineView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.LineView];
        
        [self.NewFriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(80);
        }];
        
        [self.MyFriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.NewFriendButton.mas_left).inset(10);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(80);
        }];
        
        [self.AddFriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.NewFriendButton.mas_right).inset(10);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(80);
        }];
        
        if(self.currentIndex == 0){
            [self.LineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.AddFriendButton).inset(-10);
                make.centerX.equalTo(self.MyFriendButton);
                make.height.mas_equalTo(2);
                make.width.mas_equalTo(60);
            }];
        }else if(self.currentIndex == 1){
            [self.LineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.AddFriendButton).inset(-10);
                make.centerX.equalTo(self.NewFriendButton);
                make.height.mas_equalTo(2);
                make.width.mas_equalTo(60);
            }];
        }else{
            [self.LineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.AddFriendButton).inset(-10);
                make.centerX.equalTo(self.AddFriendButton);
                make.height.mas_equalTo(2);
                make.width.mas_equalTo(60);
            }];
        }
    }
    return self;
}

-(void)DidTapButton:(UIButton *)sender{
    if(_delegate){
        [_delegate DidChangeIndex:sender.tag];
    }
    [self setIndex:sender.tag];
}

-(void)ScrollWithLineView:(CGFloat)ScrollX{
    CGFloat newCenterX = self.LineView.centerX + ScrollX;
    [UIView animateWithDuration:0.1f animations:^{
        [self.LineView setCenterX:newCenterX];
    }];
}

-(void)setIndex:(NSInteger)currentIndex{
    self.currentIndex = currentIndex;
    if(currentIndex == 0){
        [self.MyFriendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.NewFriendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.AddFriendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.6f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseInOut animations:^{
             [self.LineView setCenterX:self.MyFriendButton.centerX];
        } completion:nil];
    }else if(currentIndex == 1){
        [self.MyFriendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.NewFriendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.AddFriendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
   
        [UIView animateWithDuration:0.6f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.LineView setCenterX:self.NewFriendButton.centerX];
        } completion:nil];
    }else if(currentIndex == 2){
        [self.MyFriendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.NewFriendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.AddFriendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [UIView animateWithDuration:0.6f delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseInOut animations:^{
             [self.LineView setCenterX:self.AddFriendButton.centerX];
        } completion:nil];
    }
}

- (CGSize)intrinsicContentSize{
    return CGSizeMake(ScreenWidth - 100, 40);
}

@end
