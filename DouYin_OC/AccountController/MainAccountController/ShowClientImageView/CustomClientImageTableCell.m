//
//  CustomClientImageTableCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/9.
//

#import "CustomClientImageTableCell.h"

@interface CustomClientImageTableCell()
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UIImageView *currrentimage;
@end

@implementation CustomClientImageTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setBackgroundColor:[UIColor colorNamed:@"darkgray"]];
        self.title = [[UILabel alloc] init];
        [self.title setTextColor:[UIColor whiteColor]];
        [self.title setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium]];
        [self addSubview:self.title];
        
        self.currrentimage = [[UIImageView alloc] init];
        [self.currrentimage setTintColor:[UIColor whiteColor]];
        [self addSubview:self.currrentimage];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(15);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        
        [self.currrentimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(15);
            make.centerY.equalTo(self);
            make.height.width.mas_equalTo(20);
        }];
    }
    return self;
}

-(void)SetData:(NSString *)title image:(UIImage *)image{
    [self.title setText:title];
    [self.currrentimage setImage:image];
}
@end
