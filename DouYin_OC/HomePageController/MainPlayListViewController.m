////
////  HomePageController.m
////  DouYin(OC)
////
////  Created by 孙志雄 on 2022/11/14.
////
//
//#import "MainPlayListViewController.h"
//
//@interface MainPlayListViewController()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
//@property (nonatomic,assign) NSDate *lastChangeIndexTime;
//@property (nonatomic,assign) BOOL                              isCurPlayerPause;
//@property (nonatomic,strong) LoadMoreControl                   *loadMore;
//@property (nonatomic,strong) NSMutableArray<VideoPlayData *>    *data; // 当前播放的所有资源
//
//@end
//
//// Cache弄完 Cache的时候现实加载 
//
//@implementation MainPlayListViewController
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    NSLog(@"currentIndex %ld",(long)_currentIndex);
//    [self.tableView reloadData];
//    if(self.data.count <= _currentIndex){
//        NSLog(@"%lu self.data.count",(unsigned long)self.data.count);
//    }else{
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    }
//}
//
//#pragma
//- (instancetype)init:(NSString *)ViewType{
//    self = [super init];
//    if(self){
//        _ViewType = ViewType;
//        _isCurPlayerPause = NO;
//        _currentIndex = 0;
//        _data = [NSMutableArray array];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
//    }
//    return self;
//}
//
//- (void)viewDidLoad{
//    [super viewDidLoad];
//    NSLog(@"%@ _ViewType",_ViewType);
//    _currentIndex = 0;
//    self.view.backgroundColor = [UIColor blackColor];
////    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, - (ScreenHeight + 85), ScreenWidth, ScreenHeight * 3)];
////    _tableView.contentInset = UIEdgeInsetsMake(ScreenHeight, 0, ScreenHeight * 1, 0);
//    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,-85, ScreenWidth, ScreenHeight)];
//    self.tableView.backgroundColor = [UIColor blackColor];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.allowsSelection = NO;
//    self.tableView.alwaysBounceVertical = NO;
//    [self LoadData];
//    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    [self.tableView registerClass:CustomTableViewCell.class forCellReuseIdentifier:_ViewType];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.view addSubview:self.tableView];
//        [self.tableView reloadData];
//        [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
//    });
////    _loadMore = [[LoadMoreControl alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 50) surplusCount:3];// 下拉加载更多
////    __weak __typeof(self) wself = self;
////    [_loadMore setOnLoad:^{
////        [wself LoadData];
////    }];
////    [_tableView addSubview:_loadMore];
//    
//}
//
//
//- (void)viewDidDisappear:(BOOL)animated{
////    [super viewDidDisappear:animated];
////    [_tableView.layer removeAllAnimations];
////    NSArray<CustomTableViewCell *> *cells = [_tableView visibleCells];
////    for(CustomTableViewCell *cell in cells){
////        [cell.PlayerView cancelLoading];
////    }
////    if([_ViewType isEqualToString:@"concern"]){
////        [[ConcerPlayList PlayerListManager]pauseAll];
////    }else if([_ViewType isEqualToString:@"samecity"]){
////        [[ConcerPlayList PlayerListManager]pauseAll];
////    }else{
////        [[PlayerListManage PlayerListManager]pauseAll];
////    }
//    
////    [[NSNotificationCenter defaultCenter] removeObserver:self];
////    [self removeObserver:self forKeyPath:@"currentIndex"];
////    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
//
////- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
////    NSLog(@"hello");
////    CustomTableViewCell *firstcell = self.tableView.visibleCells.firstObject;
////    [firstcell play];
////}
//
//
//#pragma TableViewSet
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"%ld tableViewcount",self.data.count);
//    return self.data.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return (UIScreen.mainScreen.bounds.size.height);
//}
//
////- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
////    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_ViewType];
////    if(cell == nil){
////        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_ViewType];
////    }
////    cell.userInteractionEnabled = YES;
////    cell.backgroundColor = [UIColor blackColor];
////    [cell initData:_data[indexPath.row] isLastCell: NO];
////    if(indexPath.row == self.currentIndex  && [self.ViewType isEqual:@"recommend"]){
////        __weak typeof (cell) wcell = cell;
////        __weak typeof (self) wself = self;
////        cell.onPlayerReady = ^{
////            if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
////                [wcell play];
////            }
////        };
////    }
////    cell.OnAvaterFunction = ^{
////        UIViewController *newvc = [UIViewController new];
////        self.definesPresentationContext = YES;
////        newvc.view.frame = ScreenFrame;
////        newvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
////        newvc.view.backgroundColor = [UIColor grayColor];
////        NSLog(@"navigationController %@",self.navigationController);
////        [self presentViewController:newvc animated:YES completion:nil];
////    };
////
////    [cell startDownLoadBackgroundTask];
////    NSLog(@"%@ cellfortablview",cell);
////    return cell;
////}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
//        //UITableView禁止响应其他滑动手势
//        scrollView.panGestureRecognizer.enabled = NO;
//
//        if(translatedPoint.y < -50 && self.currentIndex < (self.data.count - 1)) {
//            self.currentIndex ++;   //向下滑动索引递增
//        }
//        if(translatedPoint.y > 50 && self.currentIndex > 0) {
//            self.currentIndex --;   //向上滑动索引递减
//        }
//        
//        [UIView animateWithDuration:0.15
//             delay:0.0
//           options:UIViewAnimationOptionCurveEaseOut animations:^{
//               //UITableView滑动到指定cell
//               [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//           } completion:^(BOOL finished) {
//               //UITableView可以响应其他滑动手势
//               scrollView.panGestureRecognizer.enabled = YES;
//           }];
//    });
//}
//
//- (void)applicationBecomeActive {
//    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
//    if(!_isCurPlayerPause) {
//        [cell.PlayerView play];
//    }
//}
//
//- (void)applicationEnterBackground {
//    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
//    _isCurPlayerPause = ![cell.PlayerView rate];
//    [cell.PlayerView pause];
//}
//
//-(void)LoadData{
//    __weak __typeof(self) weakself = self;
//    MainVideoRequest *request = [MainVideoRequest new];
//    [NetWorkHelper getWithUrlPath:MainVideoPath request:request success:^(id data) {
//        MainVideoResponse *response = [[MainVideoResponse alloc] initWithDictionary:data error:nil];
//        NSArray<VideoPlayData *> *array = response.data;
////
////        NSLog(@"%@ fristobject",array.firstObject.video_url);
//        if(array.count > 0){
//            [weakself.data addObjectsFromArray:array];
//            [weakself.tableView reloadData];
////            [weakself.tableView beginUpdates];
//            NSLog(@"%@ weakself.data",weakself.data);
////            NSMutableArray<NSIndexPath *> *indexpaths = [NSMutableArray array];
////            for(NSInteger row = weakself.data.count - array.count;row < self.data.count;row++){
////                NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
////                [indexpaths addObject:indexpath];
////            }
////            [weakself.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:NO];
////            [weakself.tableView endUpdates];
//            [weakself.loadMore endLoading];
//        }else{
//            [weakself.loadMore loadingAll];
//        }
//        
//    } faliure:^(NSError *error) {
//        [weakself.loadMore loadingFailed];
//    }];
////    AwemeListRequest *request = [AwemeListRequest new];
////    request.page = pageIndex;
////    request.size = pageSize;
////    if(_awemeType == AwemeWork){
////        [NetWorkHelper getWithUrlPath:FindAwemePostByPagePath request:request success:^(id data) {
////            AwemeListResponse *response = [[AwemeListResponse alloc] initWithDictionary:data error:nil];
////            NSArray<VideoPlayData *> *array = response.data;
////            if(array.count > 0){
////                weakself.pageIndex++;
////                [weakself.tableView beginUpdates];
////                [weakself.data addObjectsFromArray:array];
////                NSMutableArray<NSIndexPath *> *indexpaths = [NSMutableArray array];
////                for(NSInteger row = weakself.data.count - array.count;row < self.data.count;row++){
////                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
////                    [indexpaths addObject:indexpath];
////                }
////                [weakself.tableView insertRowsAtIndexPaths:indexpaths withRowAnimation:NO];
////                [self.tableView endUpdates];
////                [weakself.loadMore endLoading];
////            }else{
////                [weakself.loadMore loadingAll];
////            }
////        } faliure:^(NSError *error) {
////            [weakself.loadMore loadingFailed];
////        }];
////    }
//}
//
//-(void)ViewAppearStartPlay{
//    _isCurPlayerPause = NO;
//    CustomTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
//    [cell startDownloadHighPriorityTask];
//    __weak typeof (cell) wcell = cell;
//    __weak typeof (self) wself = self;
//    if(cell.isPlayerReady){
//        [cell replay];
//    }else{
//        if([_ViewType isEqualToString:@"concern"]){
//            [[ConcerPlayList PlayerListManager]pauseAll];
//        }else if([_ViewType isEqualToString:@"samecity"]){
//            [[ConcerPlayList PlayerListManager]pauseAll];
//        }else{
//            [[PlayerListManage PlayerListManager]pauseAll];
//            wcell.onPlayerReady = ^{
//                NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
//                if(!wself.isCurPlayerPause && indexPath && indexPath.row == wself.currentIndex) {
//                    [wcell play];
//                }else{
//                    NSLog(@"当前cell的视频源还未准备好播放");
//                }
//            };
//        }
//        //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
//    }
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    if([keyPath isEqualToString: @"currentIndex"]){
//        [self ViewAppearStartPlay];
//    }else{
//        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
//}
//
//
//
//- (void)didReceiveMemoryWarning{
//    [super didReceiveMemoryWarning];
//    [[WebCacheHelpler sharedWebCache]clearCache:^(NSString *cacheSize) {
//        NSLog(@"%@",cacheSize);
//    }];
//}
//
//- (void)dealloc {
//    NSLog(@"======== dealloc =======");
//}
//
//
//@end
//
//
//@implementation MainPlayListViewControllerRoot
//
//- (instancetype)init:(NSString *)ViewType{
//    self = [super initWithRootViewController:[[MainPlayListViewController alloc] init:ViewType]];
//    return self;
//}
//
//- (void)viewDidLoad{
//    [super viewDidLoad];
//    [self setNavigationBarHidden:YES];
//}
//
//@end
