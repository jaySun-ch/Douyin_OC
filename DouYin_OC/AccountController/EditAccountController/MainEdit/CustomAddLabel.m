//
//  CustomAddLabel.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/9.
//

#import "CustomAddLabel.h"



@interface CustomAddLabel()
@property (nonatomic,strong) UILabel *label;
@end

@implementation CustomAddLabel

- (instancetype)init{
    CGSize size = [@"完善信息 +10%" singleLineSizeWithText:[UIFont systemFontOfSize:9.0]];
    self = [super initWithFrame:CGRectMake(0, 0,size.width, size.height)];
    if(self){
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.label = [[UILabel alloc] init];
        [self.label setText:@"完善信息 +10%"];
        [self.label setFont:[UIFont systemFontOfSize:9.0]];
        [self.label setTextColor:[UIColor redColor]];
        [self addSubview:self.label];
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.mas_equalTo(self.height);
        }];
    }
    return self;
}

-(void)setlabel:(NSInteger)model{
    if(model == 0){
        [self.label setText:@"完善信息 +10%"];
    }else{
        [self.label setText:@"完善信息 +20%"];
    }
}

@end
