//
//  CustomHeaderBarItem.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//

#import "CustomHeaderBarItem.h"


@interface CustomHeaderBarItem()
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *image;
@end

@implementation CustomHeaderBarItem

- (instancetype)initWithFrame:(CGRect)frame label:(NSString *)label isLock:(BOOL)islock{
    self = [super initWithFrame:frame];
    if(self){
        self.userInteractionEnabled = YES;
        self.label = [[UILabel alloc] init];
        [self.label setText:label];
        [self.label setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.label];
        [self.label  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        if(islock){
            self.image = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"lock.fill"]];
            [self.image setTintColor:[UIColor lightGrayColor]];
            [self addSubview:self.image];
            [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.label.mas_right).inset(3);
                make.centerY.equalTo(self);
                make.width.height.mas_equalTo(15);
            }];
        }
    }
    return self;
}

-(void)SetFocus:(BOOL)isSelected{
    if(isSelected){
        [self.label setTextColor:[UIColor blackColor]];
    }else{
        [self.label setTextColor:[UIColor lightGrayColor]];
    }
}

@end
