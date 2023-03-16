//
//  CustomTabbar2.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/15.
//

#import "CustomTabbar2.h"

#define IconSpace 10

@implementation CustomTabbar2

-(instancetype)initWithFrameAndtabItems:(CGRect)frame tabItems:(NSArray *)tabItems{
    if(self=[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorNamed:@"darkgray"];
        self.tabItems = tabItems;
        [self setTabItems];
    }
    return self;
}


-(void)respondsToPlusButton{
    if([self.delegate respondsToSelector:@selector(tabbarDidClickCustomPlusButton:)]){
        [self.myDelegate tabbarDidClickCustomPlusButton:self];
    }
}
//    for (int index = 0; index < 5; index++) {
//        CustomTabarItem *tabBarItem = self.tabItems[index];
//        CGFloat itemX = (index+1) * (itemW);
//        tabBarItem.frame = CGRectMake(itemX, itemY, itemW, itemH);
//        NSLog(@"%@ labelText",tabBarItem.labelText);
//    }

-(void)setTabItems{
    [self clearView];
    CGFloat w = IconSpace;
    CGFloat Width = (ScreenWidth - (6) * IconSpace) / 5;
    for (int i=0; i<_tabItems.count; i++) {
        CustomTabarItem *barItem= _tabItems[i];
        barItem.frame = CGRectMake(w,5,Width, 35);
        barItem.tintColor = self.tintColor;
        [self addSubview:barItem];
        w += (Width + IconSpace);
    }
    [self setCurrentIndex:0 tintColor:[UIColor whiteColor]];
}


- (void)clearView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)setCurrentIndex:(NSInteger)tag  tintColor:(UIColor *)tintColor{
    for (int i=0; i<self.tabItems.count; i++) {
        [self.tabItems[i] setItemSelected:i==tag tintColor:tintColor];
    }
    
    if(tag > 2){
        [self.tabItems[2] changeImagecolor:[UIColor blackColor]];
    }else{
        [self.tabItems[2] changeImagecolor:[UIColor whiteColor]];
    }
}

-(void)SetBadgeWithbage:(NSInteger)Badge Index:(NSInteger)index{
    [self.tabItems[index] SetBadgeWithBadge:Badge];
}

@end
