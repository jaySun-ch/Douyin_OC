//
//  LoadMoreControl.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/17.
//

#import <UIKit/UIKit.h>

//loading type enum
typedef NS_ENUM(NSUInteger,LoadingType) {
    LoadStateIdle,
    LoadStateLoading,
    LoadStateAll,
    LoadStateFailed
};

typedef void (^OnLoad)(void);

@interface LoadMoreControl:UIControl
@property (nonatomic, strong) UIScrollView               *superView;
@property (nonatomic, assign) LoadingType                loadingType;
@property (nonatomic, strong) UIImageView                *indicatorView;
@property (nonatomic, strong) UILabel                    *label;
@property (nonatomic, strong) OnLoad                     onLoad;

-(instancetype)initWithFrame:(CGRect)frame surplusCount:(NSInteger)surplusCount;

- (void)setLoadingType:(LoadingType)loadingType;

- (void)setOnLoad:(OnLoad)onLoad;

- (void)reset;

- (void)startLoading;

- (void)endLoading;

- (void)loadingFailed;

- (void)loadingAll;
@end
