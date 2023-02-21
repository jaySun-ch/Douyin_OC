//
//  MainVideoControl.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/1/3.
//

#import "MainVideoControl.h"



@interface MainVideoControl()
@property (nonatomic,strong) UIButton *xmarkbutton;
@property (nonatomic,strong)  UIView *background;

@end

@implementation MainVideoControl

- (instancetype)init{
    self = [super init];
    if(self){
        self.xmarkbutton = [[UIButton alloc] init];
        [_xmarkbutton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
        [_xmarkbutton setTintColor:[UIColor whiteColor]];
        [_xmarkbutton setBackgroundColor:[UIColor colorNamed:@"darkgray"]];
        _xmarkbutton.layer.cornerRadius = 8;
        _xmarkbutton.tag = cancelButton;
        [_xmarkbutton addTarget:self action:@selector(HandlerButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        UIWindow *window = UIApplication.sharedApplication.delegate.window;
        [window addSubview:_xmarkbutton];
        
        [_xmarkbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(window.mas_left).inset(10);
            make.bottom.equalTo(window).inset(30);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(60);
        }];
        
        _background = [[UIView alloc] init];
        _background.layer.cornerRadius = 8;
        [_background setBackgroundColor:[UIColor colorNamed:@"darkgray"]];
        [window addSubview:_background];
        
        _playbutton = [[UIButton alloc] init];
        [_playbutton setImage:[UIImage systemImageNamed:@"play"] forState:UIControlStateNormal];
        [_playbutton setTintColor:[UIColor whiteColor]];
        _playbutton.tag = pauseButton;
        [_playbutton addTarget:self action:@selector(HandlerButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [_background addSubview:_playbutton];
        
        _ratebutton = [[UIButton alloc] init];
        [_ratebutton setTitle:@"1x" forState:UIControlStateNormal];
        [_ratebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _ratebutton.tag = ratebutton;
        [_ratebutton addTarget:self action:@selector(HandlerButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [_background addSubview:_ratebutton];
        
        [_background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(window).inset(10);
            make.bottom.equalTo(window.mas_bottom).inset(30);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(100);
        }];
        
        [_ratebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_background.mas_right).inset(10);
            make.centerY.equalTo(_background);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(35);
        }];
        
        [_playbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_ratebutton.mas_left).inset(10);
            make.centerY.equalTo(_background);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];
    }
    return self;
}

-(void)HandlerButtonTap:(UIButton *)sender{
    if(_delegate){
        [_delegate TapOnVideoControlWithTag:sender.tag];
    }
}

-(void)removeFromSuperview{
    [super removeFromSuperview];
    [self.playbutton removeFromSuperview];
    [self.xmarkbutton removeFromSuperview];
    [self.ratebutton removeFromSuperview];
    [self.background removeFromSuperview];
}

@end
