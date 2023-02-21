//
//  AddTableCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//

#import "AddTableCell.h"

@interface AddTableCell()
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UIView *imageBackground;
@property (nonatomic,strong) UILabel *label;
@end

@implementation AddTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.imageBackground = [[UIView alloc] init];
        self.imageBackground.layer.cornerRadius = 25;
        self.imageBackground.backgroundColor = [UIColor colorNamed:@"lightgray"];
        
        self.image = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"plus"]];
        self.image.tintColor = [UIColor darkGrayColor];
        
        [self.imageBackground addSubview:self.image];
        
        [self addSubview:self.imageBackground];
        
        self.label = [[UILabel alloc] init];
        [self.label setText:@"添加或注册新账号"];
        [self.label setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]];
        [self addSubview:self.label];
        
        [self.imageBackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(20);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(50);
        }];
        
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imageBackground);
            make.width.height.mas_equalTo(20);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageBackground.mas_right).inset(10);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

@end
