//
//  HeaderTabbar.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//

#import "HeaderTabbar.h"
#import "CustomHeaderBarItem.h"

@interface HeaderTabbar()
@property (nonatomic,strong) NSArray<NSString *> *buttonItem;
@property (nonatomic,strong) UIView *lineview;
@end

@implementation HeaderTabbar

- (instancetype)initWithArrayItem:(NSArray<NSString *> *)arrayItem{
    self = [super initWithFrame:CGRectMake(0, 0,ScreenWidth, 40)];
    if(self){
        self.userInteractionEnabled = YES;
        _buttonItem = arrayItem;
        for(NSInteger i = 0;i<arrayItem.count;i++){
            CustomHeaderBarItem *item = [[CustomHeaderBarItem alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / arrayItem.count, 50) label:arrayItem[i] isLock:NO];
            item.tag = i+1;
            [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HasSelect:)]];
            [self addSubview:item];
            if(i != 0){
                CustomHeaderBarItem *lastItem = [self viewWithTag:i];
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self);
                    make.left.equalTo(lastItem.mas_right);
                    make.width.mas_equalTo(ScreenWidth / arrayItem.count);
                    make.height.mas_equalTo(35);
                }];
            }else{
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self);
                    make.left.equalTo(self);
                    make.width.mas_equalTo(ScreenWidth / arrayItem.count);
                    make.height.mas_equalTo(35);
                }];
                [item SetFocus:YES];
            }
            
        }
        self.lineview = [[UIView alloc] initWithFrame:CGRectMake(0,35, self.frame.size.width / arrayItem.count, 3)];
        self.lineview.backgroundColor = [UIColor blackColor];
        [self addSubview:self.lineview];
        self.currentIndex = 0;
    }
    return self;
}


-(void)HasSelect:(UITapGestureRecognizer *)sender{
    [self ScrollToPageIndex:sender.view.tag - 1];
    if(_delegate){
        [self.delegate DidSelectIndex:self.currentIndex];
    }
}

-(void)ScrollToPageIndex:(NSInteger)index{
    for(NSInteger i = 0;i<_buttonItem.count;i++){
        CustomHeaderBarItem *SelectItem = [self viewWithTag:i+1];
        if(i == index){
            [SelectItem SetFocus:YES];
        }else{
            [SelectItem SetFocus:NO];
        }
    }
    self.currentIndex = index;
    [UIView animateWithDuration:0.8f delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.lineview.frame = CGRectMake(index * (self.frame.size.width / self.buttonItem.count),35, self.frame.size.width / self.buttonItem.count, 3);
    } completion:nil];
}

@end
