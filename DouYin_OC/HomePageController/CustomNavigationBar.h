//
//  CustomNavigationBar.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/19.
//


#import <UIKit/UIKit.h>

typedef void (^sameCityfunc)(void);
typedef void (^recommentfunc)(void);
typedef void (^concernfunc)(void);

@interface CustomNavigationBar : UIView
@property (nonatomic,strong) recommentfunc recommentfunc;
@property (nonatomic,strong) concernfunc concernfunc;
@property (nonatomic,strong) sameCityfunc sameCityfunc;
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic,strong) UIView *round;
@property (nonatomic,strong) UIButton *recommendButton;
@property (nonatomic,strong) UIButton *concernButton;
@property (nonatomic,strong) UIButton *SameCityButton;
@property (nonatomic,strong) UIImageView *SearchButton;
@property (nonatomic,strong) UIImageView *plusButton;

-(void)setCurrentPageIndex:(NSInteger)currentPageIndex;

@end
