//
//  CustomAlertTabCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/7.
//

#import "CustomAlertTabCell.h"

@interface CustomAlertTabCell()
@property (nonatomic,strong) UIImageView *currentImage;
@property (nonatomic,strong) UILabel *label;
@end


@implementation CustomAlertTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.label = [[UILabel alloc] init];
        [self.label setTintColor:[UIColor blackColor]];
        
        self.currentImage = [[UIImageView alloc] init];
        [self.currentImage setTintColor:[UIColor blackColor]];
        self.currentImage.layer.cornerRadius = self.frame.size.height / 4;
    }
    return self;
}

-(void)SetData:(NSString *)title image:(UIImage *)image SetImageRight:(BOOL)SetImageRight IsLast:(BOOL)IsLast{
    [self.label setText:title];
    if(IsLast){
        [self.label removeFromSuperview];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).inset(15);
            make.height.mas_equalTo(20);
        }];
    }else{
        [self.label removeFromSuperview];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(20);
        }];
    }
    
    if(image != nil){
        [self.currentImage setImage:image];
        if(SetImageRight){
            [self.currentImage removeFromSuperview];
            [self addSubview:self.currentImage];
            [self.currentImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self.label.mas_right).inset(5);
                make.width.height.mas_equalTo(self.frame.size.height / 2);
            }];
        }else{
            [self.currentImage removeFromSuperview];
            [self addSubview:self.currentImage];
            [self.currentImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.equalTo(self.label.mas_left).inset(5);
                make.width.height.mas_equalTo(self.frame.size.height / 2);
            }];
        }
    }else{
        [self.currentImage removeFromSuperview];
    }
}


@end
