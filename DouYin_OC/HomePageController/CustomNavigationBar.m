//
//  CustomNavigationBar.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/19.
//

#import "CustomNavigationBar.h"
#import "DefinGroup.pch"
#import <Masonry/Masonry.h>

#define iconHeight 40

#define textwidth 50

@implementation CustomNavigationBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _currentPageIndex = 2;
        
        _round = [[UIView alloc] init];
        _round.backgroundColor = [UIColor whiteColor];
        _round.layer.cornerRadius = 2;
        
        _plusButton = [[UIImageView alloc] init];
        [_plusButton setImage:[UIImage systemImageNamed:@"plus.circle"] ];
        [_plusButton setTintColor:[UIColor whiteColor]];
        
        _SearchButton = [[UIImageView alloc] init];
        [_SearchButton setImage:[UIImage systemImageNamed:@"magnifyingglass"]];
        [_SearchButton setTintColor:[UIColor whiteColor]];
        
        
        _concernButton = [[UIButton alloc] init];
        [_concernButton setUserInteractionEnabled:YES];
        [_concernButton setTitle:@"关注" forState:UIControlStateNormal];
        [_concernButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_concernButton setTitleColor:[UIColor systemGray2Color] forState:UIControlStateNormal];
        [_concernButton addTarget:self action:@selector(ChangePageIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        _recommendButton = [[UIButton alloc] init];
        [_recommendButton setUserInteractionEnabled:YES];
        [_recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
        [_recommendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_recommendButton setTitleColor:[UIColor systemGray2Color] forState:UIControlStateNormal];
        [_recommendButton addTarget:self action:@selector(ChangePageIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        _SameCityButton = [[UIButton alloc] init];
        [_SameCityButton setTitle:@"同城" forState:UIControlStateNormal];
        [_SameCityButton setTintColor:[UIColor lightGrayColor]];
        [_SameCityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_SameCityButton setTitleColor:[UIColor systemGray2Color] forState:UIControlStateNormal];
        [_SameCityButton addTarget:self action:@selector(ChangePageIndex:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_round];
        [self addSubview:_plusButton];
        [self addSubview:_SearchButton];
        [self addSubview:_concernButton];
        [self addSubview:_recommendButton];
        [self addSubview:_SameCityButton];
        [_recommendButton setSelected:YES];
    }
    return self;
}


- (void)setCurrentPageIndex:(NSInteger)currentPageIndex{
    _currentPageIndex = currentPageIndex;
    if(_currentPageIndex == 1){
        [_recommendButton setSelected:NO];
        [_SameCityButton setSelected:NO];
        [_concernButton setSelected:YES];
    }else if(_currentPageIndex == 0){
        [_recommendButton setSelected:NO];
        [_SameCityButton setSelected:YES];
        [_concernButton setSelected:NO];
    }else{
        [_recommendButton setSelected:YES];
        [_SameCityButton setSelected:NO];
        [_concernButton setSelected:NO];
    }
    [self UpdateRoundLocation];
}


-(void)ChangePageIndex:(UIButton *)sender{
    NSLog(@"sender.titleLabel.text %@",sender.titleLabel.text);
    if([sender.titleLabel.text isEqualToString:@"关注"]){
        _currentPageIndex = 1;
        [_recommendButton setSelected:NO];
        [_SameCityButton setSelected:NO];
        [_concernButton setSelected:YES];
        _concernfunc();
    }else if([sender.titleLabel.text isEqualToString:@"同城"]){
        _currentPageIndex = 0;
        [_recommendButton setSelected:NO];
        [_SameCityButton setSelected:YES];
        [_concernButton setSelected:NO];
        _sameCityfunc();
    }else{
        _currentPageIndex = 2;
        [_recommendButton setSelected:YES];
        [_SameCityButton setSelected:NO];
        [_concernButton setSelected:NO];
        _recommentfunc();
    }
    [self UpdateRoundLocation];
}

-(void)UpdateRoundLocation{
    [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        if(self.currentPageIndex == 1){
            self.round.center = CGPointMake(self.concernButton.center.x, (self.concernButton.bounds.size.height - 2));
        }else if(self.currentPageIndex == 0){
            self.round.center = CGPointMake(self.SameCityButton.center.x, (self.SameCityButton.bounds.size.height - 2));
        }else{
            self.round.center = CGPointMake(self.recommendButton.center.x, (self.recommendButton.bounds.size.height - 2));
        }
    } completion:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
   
    
//    _concernButton.center = CGPointMake(ScreenWidth / 2,16);
    [_concernButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(textwidth);
        make.height.mas_equalTo(iconHeight);
    }];
    
    [_recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_concernButton.mas_right).inset(40);
        make.width.mas_equalTo(textwidth);
        make.height.mas_equalTo(iconHeight);
    }];
    
    [_SameCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_concernButton.mas_left).inset(40);
        make.width.mas_equalTo(textwidth);
        make.height.mas_equalTo(iconHeight);
    }];
    
    [_plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).inset(15);
        make.centerY.equalTo(_concernButton);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    [_SearchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).inset(15);
        make.centerY.equalTo(_concernButton);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    _round.frame = CGRectMake(0, 0, textwidth / 2, 2);
    _round.center = CGPointMake(_recommendButton.center.x, (_recommendButton.bounds.size.height - 2));
}

@end
