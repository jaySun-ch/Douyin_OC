//
//  CustomBottomBarButton.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/11.
//

#import "CustomBottomBarButton.h"

@interface CustomBottomBarButton()
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *image;
@end

@implementation CustomBottomBarButton

- (instancetype)init{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor colorNamed:@"lightgray"];
        self.image = [[UIImageView alloc] init];
        self.image.contentMode = UIViewContentModeScaleAspectFit;
        self.image.clipsToBounds = YES;
        self.label = [[UILabel alloc] init];
        [self.label setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
        [self addSubview:self.image];
        [self addSubview:self.label];

        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(18);
            make.left.top.bottom.equalTo(self).inset(8);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self).inset(4);
            make.left.equalTo(self.image.mas_right).inset(4);
            make.height.mas_equalTo(12);
        }];
    }
    return self;
}


-(void)SetWithTitle:(NSString *)string image:(UIImage *)image{
    [self.image setImage:image];
    [self.label setText:string];
}

@end
