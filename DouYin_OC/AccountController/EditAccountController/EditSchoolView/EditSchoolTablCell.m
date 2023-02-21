//
//  EditSchoolTablCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/8.
//

#import "EditSchoolTablCell.h"

@interface EditSchoolTablCell()
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIImageView *goimage;
@end

@implementation EditSchoolTablCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.title = [[UILabel alloc] init];
        [self.title setFont:[UIFont systemFontOfSize:16.0]];
        [self addSubview:self.title];
        
        self.message = [[UILabel alloc] init];
        [self.message setFont:[UIFont systemFontOfSize:16.0]];
        [self.message setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.message];
        
        self.goimage = [[UIImageView alloc] init];
        [self.goimage setImage:[UIImage systemImageNamed:@"chevron.right"]];
        [self.goimage setTintColor:[UIColor lightGrayColor]];
        [self addSubview:self.goimage];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(15);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        
        [self.goimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(15);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(10);
            make.height.mas_equalTo(15);
        }];
        
        [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.goimage.mas_left).inset(10);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}


-(void)SetData:(NSString *)title message:(NSString *)message{
    [self.title setText:title];
    [self.message setText:message];
}

@end
