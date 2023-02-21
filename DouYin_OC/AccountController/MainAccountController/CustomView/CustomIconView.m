//
//  CustomIconView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/28.
//

#import "CustomIconView.h"
#import <Masonry/Masonry.h>

@interface CustomIconView()
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *subTitle;

@end


@implementation CustomIconView


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle{
    self = [super initWithFrame:frame];
    if(self){
        self.image = [[UIImageView alloc] initWithImage:image];
        [self.image setTintColor:[UIColor blackColor]];
        self.title = [[UILabel alloc] init];
        [self.title setTextColor:[UIColor blackColor]];
        [self.title setText:title];
        [self.title setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
        
        self.subTitle = [[UILabel alloc] init];
        [self.subTitle setTextColor:[UIColor lightGrayColor]];
        [self.subTitle setText:subtitle];
        [self.subTitle setFont:[UIFont systemFontOfSize:13.0]];
        
        [self addSubview:_title];
        [self addSubview:_subTitle];
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews{
    UIView *continaer = [[UIView alloc] init];
    continaer.layer.cornerRadius = 5;
    continaer.backgroundColor = [UIColor colorNamed:@"lightgray"];

    [continaer addSubview:_image];
    [self addSubview:continaer];
    
    [continaer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.height.mas_equalTo(self.frame.size.height);
    }];
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(continaer);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(20);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(continaer.mas_right).inset(5);
        make.height.mas_equalTo(self.frame.size.height / 2);
    }];
    
    [self.subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(continaer.mas_right).inset(5);
    }];
}

@end
