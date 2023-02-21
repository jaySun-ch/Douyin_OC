//
//  CustomTalk.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/30.
//

#import "CustomTalk.h"
#import <Masonry/Masonry.h>

@interface CustomTalkCell()
@end

@implementation CustomTalkCell

- (instancetype)init{
    self = [super init];
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _mainImage = [[UIImageView alloc] init];
        _mainImage.layer.cornerRadius = 65 / 2;
        _mainImage.clipsToBounds = YES;
        _mainImage.contentMode = UIViewContentModeScaleAspectFill;
        _title = [[UILabel alloc] init];
        [_title setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
        _subTitle = [[UILabel alloc] init];
        [_subTitle setFont:[UIFont systemFontOfSize:14.0]];
        [_subTitle setTextColor:[UIColor lightGrayColor]];
        [self addSubview:_mainImage];
        [self addSubview:_title];
        [self addSubview:_subTitle];
        
        
        self.RedDot = [[UILabel alloc] init];
        self.RedDot.textColor = [UIColor whiteColor];
        [self.RedDot setFont:[UIFont systemFontOfSize:12.0]];
        self.RedDot.backgroundColor = [UIColor systemPinkColor];
        self.RedDot.textAlignment = NSTextAlignmentCenter;
        self.RedDot.layer.cornerRadius = 7.5;
        self.RedDot.clipsToBounds = YES;
        self.RedDot.hidden = YES;
        [self addSubview:self.RedDot];
        
        [_mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).inset(5);
            make.height.width.mas_equalTo(65);
            make.left.equalTo(self).inset(10);
        }];
        
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_mainImage.mas_right).inset(5);
            make.top.equalTo(self).inset(17);
        }];
        
        [_subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_mainImage.mas_right).inset(5);
            make.top.equalTo(_title.mas_bottom).inset(5);
        }];

        
        [self.RedDot mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(10);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(15);
        }];
    }
    return self;
}

@end
