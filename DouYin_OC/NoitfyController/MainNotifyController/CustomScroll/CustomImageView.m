//
//  CustomImageView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/30.
//

#import "CustomImageView.h"

#import <Masonry/Masonry.h>

@interface CustomImageView()
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *label;
@end

@implementation CustomImageView


- (instancetype)initWithFrame:(CGRect)frame imageurl:(NSString *)imageurl label:(NSString *)label{
    self = [super initWithFrame:frame];
    if(self){
        _image = [[UIImageView alloc] init];
        [_image setImageWithURL:[NSURL URLWithString:imageurl] options:YYWebImageOptionSetImageWithFadeAnimation];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.layer.cornerRadius = 30;
        _image.clipsToBounds = YES;
        _label = [[UILabel alloc] init];
        [_label setFont:[UIFont systemFontOfSize:15.0]];
        [_label setText:label];
        [self addSubview:_image];
        [self addSubview:_label];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.height.width.mas_equalTo(60);
        }];
        
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_image.mas_bottom).inset(5);
            make.centerX.equalTo(_image);
        }];
    }
    return self;
}

@end
