//
//  HomePageController.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/19.
//
#import "HomePageController.h"
#import "CustomNavigationBar.h"
#import "HomeSearchView.h"
#import "MainVideoControl.h"
#import "MainPlayList.h"


@interface HomePageController()<UIScrollViewDelegate,BRSliderBarDelegate,UIGestureRecognizerDelegate,PublicVideoPlayListViewControllerDelegate,MainVideoControlDelegate>
@property (nonatomic,strong) UIImageView *SearchButton;
@property (nonatomic,strong) UIImageView *PlusButton;
@property (nonatomic,strong) MainVideoControl *VideoControl;
@property (nonatomic,strong) BRSliderBar *SliderBar;

@end

@implementation HomePageController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.RecommendPlayList play];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.RecommendPlayList pause];
}


- (void)viewDidLoad{
    self.currentPageIndex = 2;
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ScreenEdgeHandle:)];
    gesture.edges = UIRectEdgeRight;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - TabbarHeight)];
    _scrollView.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight - TabbarHeight);
    _scrollView.alwaysBounceHorizontal = NO;
    [_scrollView setBounces:NO];
    [_scrollView setPagingEnabled:YES];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _scrollView.delegate = self;
    
    UIView *vc1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TabbarHeight)];
    vc1.backgroundColor = [UIColor whiteColor];
    UIView *vc2 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-TabbarHeight)];
    vc2.backgroundColor = [UIColor cyanColor];
    _RecommendPlayList = [[PublicVideoPlayListViewController alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight-TabbarHeight)];
    _RecommendPlayList.delegate = self;
    vc1.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    vc2.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
    _RecommendPlayList.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight);
    [_scrollView addSubview:vc1];
    [_scrollView addSubview:vc2];
    [_scrollView addSubview:_RecommendPlayList];
//    vc1.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight - TabbarHeight);
//    _RecommendPlayList = [[MainPlayListViewControllerRoot alloc]init:@"recomment"];
//    _ConcernPlayList = [[MainPlayListViewControllerRoot alloc]init:@"concern"];
//    _SameCityPlayList = [[MainPlayListViewControllerRoot alloc]init:@"samecity"];
//    _SameCityPlayList.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    _ConcernPlayList.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
//    _RecommendPlayList.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight);
//    [_scrollView addSubview:_RecommendPlayList.view];
//    [_scrollView addSubview:_ConcernPlayList.view];
//    [_scrollView addSubview:_SameCityPlayList.view];
    [self.view addSubview:_scrollView];
    [self.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * self.currentPageIndex, 0, ScreenWidth, ScreenHeight - TabbarHeight) animated:YES];
    [self addObserver:self forKeyPath:@"currentPageIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    [self initSliderBar];
    [self ReSetGesturepriority];
}

- (void)ScaleWithVideo:(UIPinchGestureRecognizer *)gesture isplay:(BOOL)isplay{
    if(gesture.state == UIGestureRecognizerStateEnded && gesture.scale < 1){
        [self ResetVideo];
    }else{
        [self.PlusButton setHidden:YES];
        [self.SearchButton setHidden:YES];
        [self.SliderBar setHidden:YES];
        [self.tabBarController.tabBar setHidden:YES];
        [self.RecommendPlayList.tableView setScrollEnabled:NO];
        [self.scrollView setScrollEnabled:NO];
        if(!self.VideoControl && gesture.scale > 1){
            self.VideoControl = [[MainVideoControl alloc] init];
            if(isplay){
                [self.VideoControl.playbutton setImage:[UIImage systemImageNamed:@"pause"] forState:UIControlStateNormal];
            }
            self.VideoControl.delegate = self;
        }
    }
}

-(void)ReSetGesturepriority{
      NSArray *gestureArray = self.view.gestureRecognizers;
      for (UIGestureRecognizer *gestureRecognizer in gestureArray) {
          if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
              UIScreenEdgePanGestureRecognizer *gesture = (UIScreenEdgePanGestureRecognizer *)gestureRecognizer;
              if(gesture.edges == UIRectEdgeRight && self.scrollView.contentOffset.x == ScreenWidth * 2){
                  [self.scrollView.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
              }
          }
      }
}

-(void)ResetVideo{
    [self.SearchButton setHidden:NO];
    [self.PlusButton setHidden:NO];
    [self.SliderBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    [self.RecommendPlayList.tableView setScrollEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.VideoControl removeFromSuperview];
    self.VideoControl = nil;
}

- (void)UpdateCurrentPlayerPlayState:(BOOL)isplay{
    if(isplay){
        [self.VideoControl.playbutton setImage:[UIImage systemImageNamed:@"pause"] forState:UIControlStateNormal];
    }else{
        [self.VideoControl.playbutton setImage:[UIImage systemImageNamed:@"play"] forState:UIControlStateNormal];
    }
}

- (void)TapOnVideoControlWithTag:(NSInteger)Tag{
    if(Tag == cancelButton){
        [self ResetVideo];
        [self.RecommendPlayList ReSetVideo];
    }else if(Tag == pauseButton){
        if(self.VideoControl.playbutton.currentImage == [UIImage systemImageNamed:@"play"] ){
            // 暂停状态
            [self.VideoControl.playbutton setImage:[UIImage systemImageNamed:@"pause"] forState:UIControlStateNormal];
            [self.RecommendPlayList play];
        }else{
            // 播放状态
            [self.VideoControl.playbutton setImage:[UIImage systemImageNamed:@"play"] forState:UIControlStateNormal];
            [self.RecommendPlayList pause];
        }
    }else if(Tag == ratebutton){
        if([self.VideoControl.ratebutton.currentTitle isEqualToString:@"1x"]){
            [self.VideoControl.ratebutton setTitle:@"1.5x" forState:UIControlStateNormal];
            [[MainPlayList shareList] setCurrentRate:1.5];
        }else if([self.VideoControl.ratebutton.currentTitle isEqualToString:@"1.5x"]){
            [self.VideoControl.ratebutton setTitle:@"2x" forState:UIControlStateNormal];
            [[MainPlayList shareList] setCurrentRate:2];
        }else if([self.VideoControl.ratebutton.currentTitle isEqualToString:@"2x"]){
            [self.VideoControl.ratebutton setTitle:@"0.5x" forState:UIControlStateNormal];
            [[MainPlayList shareList] setCurrentRate:0.5];
        }else if([self.VideoControl.ratebutton.currentTitle isEqualToString:@"0.5x"]){
            [self.VideoControl.ratebutton setTitle:@"1x" forState:UIControlStateNormal];
            [[MainPlayList shareList] setCurrentRate:1];
        }
    }
}




//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    if([self isPanBackAction:gestureRecognizer]){
//        return YES;
//    }
//    return NO;
//}
//
//
//- (BOOL)isPanBackAction:(UIGestureRecognizer *)gestureRecognizer {
//    // 在最左边时候 && 是pan手势 && 手势往右拖
//    if (self.scrollView.contentOffset.x == ScreenWidth * 2) {
//        if (gestureRecognizer == self.scrollView.panGestureRecognizer) {
//            // 根据速度获取拖动方向
//            CGPoint velocity = [self.scrollView.panGestureRecognizer velocityInView:self.scrollView];
//            if(velocity.x<0){
//                //手势向左滑动
//                return YES;
//            }
//        }
//        
//    }
//    return NO;
//}


-(void)ScreenEdgeHandle:(UIScreenEdgePanGestureRecognizer *)gesture{
    CGFloat trans  = [gesture translationInView:self.view].x;
    if(self.scrollView.contentOffset.x == ScreenWidth * 2){
        [UIWindow PushControllerWithScrollX:trans gesture:gesture];
    }
}


#pragma 设置顶部栏
-(void)initSliderBar{
    self.SliderBar = [[BRSliderBar alloc] initWithFrame:CGRectMake(50,40, ScreenWidth - 100, 40) Style:BRSliderBarNormal TitleArray:@[@"同城",@"关注",@"推荐"]];
//    self.SliderBar.backgroundColor = [UIColor blackColor];
    [self.SliderBar setNormalColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    [self.SliderBar setLineColor:[UIColor whiteColor]];
    [self.SliderBar setSelectColor:[UIColor whiteColor]];
    [self.SliderBar setIndex:3];
    self.SliderBar.delegate = self;
    [self.view addSubview:self.SliderBar];
    
    self.PlusButton = [[UIImageView alloc]initWithImage:[UIImage systemImageNamed:@"plus.circle"]];
    self.PlusButton.tintColor = [UIColor whiteColor];
    [self.PlusButton setSize:CGSizeMake(25, 25)];
    [self.PlusButton setLeft:self.view.left + 15];
    [self.PlusButton setCenterY:self.SliderBar.centerY];
    [self.view addSubview:self.PlusButton];
    
    self.SearchButton = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"magnifyingglass"]];
    self.SearchButton.contentMode = UIViewContentModeScaleAspectFit;
    self.SearchButton.tintColor = [UIColor whiteColor];
    [self.SearchButton setUserInteractionEnabled:YES];
    [self.SearchButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        HomeSearchView *vc = [HomeSearchView new];
        [UIWindow PushController:vc animated:NO];
    }]];
    [self.SearchButton setSize:CGSizeMake(30, 25)];
    [self.SearchButton setRight:self.view.right - 15];
    [self.SearchButton setCenterY:self.SliderBar.centerY];
    [self.view addSubview:self.SearchButton];
}

- (void)BRSliderDidTapOnButtonWithTag:(NSInteger)Tag{
    self.currentPageIndex = Tag - 1;
    [self.scrollView scrollRectToVisible:CGRectMake(ScreenWidth * self.currentPageIndex, 0, ScreenWidth, ScreenHeight) animated:NO];
}

-(void)ActiveSearchMode{
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        scrollView.panGestureRecognizer.enabled = NO;

        if(translatedPoint.x < -50 && self.currentPageIndex < 2){
            self.currentPageIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.x > 50 && self.currentPageIndex > 0) {
            self.currentPageIndex --;   //向上滑动索引递减
        }
        [UIView animateWithDuration:0.15
             delay:0.0
           options:UIViewAnimationOptionCurveEaseOut animations:^{
               //UITableView滑动到指定cell
            [scrollView scrollRectToVisible:CGRectMake(ScreenWidth * self.currentPageIndex, 0, ScreenWidth, ScreenHeight) animated:NO];
           } completion:^(BOOL finished) {
               //UITableView可以响应其他滑动手势
               scrollView.panGestureRecognizer.enabled = YES;
        }];
        
//        NSLog(@"%ld %ld %ld PlayerListManagercount",[[PlayerListManage PlayerListManager] VideoList].count,[[SameCityPlayList PlayerListManager] VideoList].count,[[ConcerPlayList PlayerListManager] VideoList].count);
    });
}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"currentPageIndex"]){
//        [self ReSetGesturepriority];
        [self.SliderBar setIndex:self.currentPageIndex + 1];
        
        if(self.currentPageIndex == 2){
            // recommendlist出现
            NSLog(@"change2");
//            [self.RecommendPlayList viewDidAppear:YES];
//            [self.ConcernPlayList viewDidDisappear:YES];
//            [self.SameCityPlayList viewDidDisappear:YES];
        }else if(self.currentPageIndex == 1){
            NSLog(@"change1");
//            [self.ConcernPlayList viewDidAppear:YES];
//            [self.RecommendPlayList viewDidDisappear:YES];
//            [self.SameCityPlayList viewDidDisappear:YES];
        }else{
            NSLog(@"change0");
//            [self.SameCityPlayList viewDidAppear:YES];
//            [self.RecommendPlayList viewDidDisappear:YES];
//            [self.ConcernPlayList viewDidDisappear:YES];
        }
      
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
