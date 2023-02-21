//
//  HomePageController.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/19.
//
#import <UIKit/UIKit.h>
#import "MainPlayListViewController.h"
#import "PublicVideoPlayListViewController.h"

@interface HomePageController : UIViewController
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) PublicVideoPlayListViewController *RecommendPlayList;
@property (nonatomic,strong) MainPlayListViewControllerRoot *ConcernPlayList;
@property (nonatomic,strong) MainPlayListViewControllerRoot *SameCityPlayList;
@end
