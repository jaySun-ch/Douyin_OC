//
//  DragTipsView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/19.
//

#import "DragTipsView.h"

@interface DragTipsView()
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *tipView;
@end

@implementation DragTipsView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
        
        self.label = [UILabel new];
        [self.label setNumberOfLines:0];
        [self.label setText:@"边\n缘\n左\n滑\n\n进\n入\n主\n页\n"];
        [self.label setTextColor:[UIColor whiteColor]];
        [self.label setFont:[UIFont systemFontOfSize:13.0]];
        [self addSubview:self.label];
        
        self.tipView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ChevronLeft2"]];
        [self.tipView setTintColor:[UIColor whiteColor]];
        [self addSubview:self.tipView];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).inset(ScreenHeight / 4);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(15);
        }];
        
        [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.label);
            make.width.height.mas_equalTo(15);
            make.top.equalTo(self.label.mas_bottom).inset(10);
        }];
        
        CAShapeLayer *shapelayer  = [CAShapeLayer new];
        
        UIBezierPath *path1 = [[UIBezierPath alloc] init];
//        [path1 addCurveToPoint:CGPointMake(0, self.height / 2) controlPoint1:CGPointMake(10, self.height / 2) controlPoint2:CGPointMake(-10, self.height / 2)];
//        [path1 addCurveToPoint:CGPointMake(self.width - 10, self.height) controlPoint1:CGPointMake(10, self.height) controlPoint2:CGPointMake(-10, self.height)];
        [path1 moveToPoint:CGPointMake(0, 0)];
//        [path1 addCurveToPoint:CGPointMake(self.width, self.height) controlPoint1:CGPointMake(self.width, self.height / 2) controlPoint2:CGPointMake(-self.width, self.height / 2)];
//        [path1 addCurveToPoint:CGPointMake(self.width - 10, self.height) controlPoint1:CGPointMake(10, self.height) controlPoint2:CGPointMake(-10, self.height)];
        [path1 addQuadCurveToPoint:CGPointMake(0, self.height) controlPoint:CGPointMake(-self.width, self.height / 2)];
        
        
        shapelayer.path = path1.CGPath;
        shapelayer.size = CGSizeMake(self.width * 2, self.height);
        shapelayer.fillColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2].CGColor;
        shapelayer.borderColor = [UIColor clearColor].CGColor;
        shapelayer.borderWidth = 2;
    
        [self.layer addSublayer:shapelayer];
    }
    return self;
}

@end
