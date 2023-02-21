//
//  AddFriendController.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//

#import "AddMainFriendController.h"
#import "AddFriendTopCenterView.h"
#import "AddFriendView.h"
#import "MyFriendView.h"
#import "NewFriendView.h"

#define TopBarHeight 90
@interface AddMainFriendController()<UIScrollViewDelegate,AddFriendTopCenterViewDelegate>
@property (nonatomic,strong) AddFriendTopCenterView *centerView; //顶部导航栏
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) AddFriendView *AddfriendView;
@property (nonatomic,strong) MyFriendView *myfriendView;
@property (nonatomic,strong) NewFriendView *NewFriendView;

@end

@implementation AddMainFriendController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTopBar];
    [self initScrollView];
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
}

#pragma 初始话顶部导航栏
-(void)initTopBar{
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(dissMissView)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gearshape"] style:UIBarButtonItemStylePlain target:self action:@selector(ShowSetView)]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    self.centerView = [[AddFriendTopCenterView alloc] initWithIndex:self.currentIndex];
    self.centerView.size = CGSizeMake(ScreenWidth - 100, 40);
    self.centerView.intrinsicContentSize = CGSizeMake(ScreenWidth - 100, 40);
    self.centerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.centerView.delegate = self;
    [self.navigationItem setTitleView:self.centerView];
}


-(void)dissMissView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ShowSetView{
    
}

#pragma 顶部栏的代理方法
- (void)DidChangeIndex:(NSInteger)Index{
    self.currentIndex = Index;
    [self.scrollview scrollRectToVisible:CGRectMake(ScreenWidth * self.currentIndex,0,ScreenWidth,ScreenHeight - 100) animated:NO];
}


#pragma 初始话ScrollView
-(void)initScrollView{
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,100, ScreenWidth, ScreenHeight - 100)];
    self.scrollview.delegate = self;
    self.scrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.scrollview setBounces:NO];
    [self.scrollview setAlwaysBounceVertical:NO];
    [self.scrollview setShowsVerticalScrollIndicator:NO];
    [self.scrollview setShowsHorizontalScrollIndicator:NO];
    self.scrollview.backgroundColor = [UIColor whiteColor];
    self.scrollview.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight-100);
    [self.view addSubview:self.scrollview];
    self.AddfriendView = [[AddFriendView alloc] initWithFrame:CGRectMake(ScreenWidth * 2,0, ScreenWidth, ScreenHeight - 100)];
    self.NewFriendView = [[NewFriendView alloc] initWithFrame:CGRectMake(ScreenWidth,0,ScreenWidth, ScreenHeight-100)];
    self.myfriendView = [[MyFriendView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth, ScreenHeight-100)];
    [self.scrollview addSubview:self.AddfriendView];
    [self.scrollview addSubview:self.myfriendView];
    [self.scrollview addSubview:self.NewFriendView];
    [self.scrollview scrollRectToVisible:CGRectMake(ScreenWidth * self.currentIndex,0,ScreenWidth,ScreenHeight - 100) animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        scrollView.panGestureRecognizer.enabled = NO;
        if(translatedPoint.x < -50 && self.currentIndex < 2){
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.x > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        [UIView animateWithDuration:0.15
             delay:0.0
           options:UIViewAnimationOptionCurveEaseOut animations:^{
               //UITableView滑动到指定cell
            [scrollView scrollRectToVisible:CGRectMake(ScreenWidth * self.currentIndex,0,ScreenWidth,ScreenHeight - 100) animated:NO];
           } completion:^(BOOL finished) {
               //UITableView可以响应其他滑动手势
               scrollView.panGestureRecognizer.enabled = YES;
        }];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"currentIndex"] ){
        [self.centerView setIndex:self.currentIndex];
        if(self.currentIndex == 0){
            [self.myfriendView ViewDidAppear];
        }else if(self.currentIndex == 1){
            [self.NewFriendView ViewDidAppear];
        }else if(self.currentIndex  == 2){
            [self.AddfriendView ViewDidAppear];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
