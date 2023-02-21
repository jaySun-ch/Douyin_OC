//
//  CustomButtonView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/28.
//

#import "CustomButtonView.h"
#import <Masonry/Masonry.h>

@interface CustomButtonView()
@property (nonatomic,strong) UILabel *NumberCount;
@property (nonatomic,strong) UILabel *describe;
@end

@implementation CustomButtonView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _NumberCount = [[UILabel alloc] init];
        _describe = [[UILabel alloc] init];
        [self initSubView];
    }
    return self;
}

-(void)initSubView{
    [_NumberCount setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightBold]];
    [_NumberCount setTextColor:[UIColor blackColor]];
    [_describe setFont:[UIFont systemFontOfSize:15.0]];
    [_describe setTextColor:[UIColor darkGrayColor]];
    [self addSubview:_NumberCount];
    [self addSubview:_describe];
    [_NumberCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
    }];
    [_describe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_NumberCount.mas_right).inset(5);
        make.right.equalTo(self);
    }];
}

-(void)initWithData:(NSInteger)count describe:(NSString *)describe{
    [_NumberCount setText:[NSString stringWithFormat:@"%ld",count]];
    [_describe setText:describe];
}
@end
