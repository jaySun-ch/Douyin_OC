//
//  CustomBackgroundButton.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//

#import "CustomBackgroundButton.h"
#import <Masonry/Masonry.h>
#import "NSString+Extension.h"

@interface CustomBackgroundButton()
@property (nonatomic,strong) UIView *continaler;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *image;
@end

@implementation CustomBackgroundButton

-(void)initWithdata:(NSString *)label image:(UIImage *)image{
    CGSize size = [label singleLineSizeWithText:[UIFont systemFontOfSize:11.0]];
    self.continaler.frame = CGRectMake(0, 0,(12 + size.width), 20);
    [self.label setText:label];
    if(image != nil){
        self.image = [[UIImageView alloc] initWithImage:image];
        self.continaler.frame = CGRectMake(0, 0,(30 + size.width), 20);
        [self.image setTintColor:[UIColor darkGrayColor]];
        [self.continaler addSubview:self.image];
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.mas_equalTo(12);
            make.left.equalTo(self.continaler).inset(5);
            make.centerY.equalTo(self.continaler);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.image.mas_right).inset(2);
            make.centerY.equalTo(self.continaler);
            make.right.equalTo(self.continaler).inset(5);
        }];
    }else{
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.continaler);
            make.right.equalTo(self.continaler).inset(5);
        }];
    }
}

- (instancetype)init{
    self = [super init];
    if(self){
        self.continaler = [[UIView alloc] init];
        self.continaler.backgroundColor = [UIColor colorNamed:@"lightgray"];
        self.continaler.layer.cornerRadius = 5;
        [self addSubview:self.continaler];
        
        self.label = [[UILabel alloc]init];
        [self.label setTextColor:[UIColor darkGrayColor]];
        [self.label setFont:[UIFont systemFontOfSize:11.0]];
        [self.continaler addSubview:self.label];

     
        
    }
    return self;
}
@end
