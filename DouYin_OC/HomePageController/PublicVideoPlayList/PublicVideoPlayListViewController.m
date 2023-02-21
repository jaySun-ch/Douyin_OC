//
//  PublicVideoPlayListViewController.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/18.
//

#import "PublicVideoPlayListViewController.h"
#import "MainVideoCell.h"
#import "MainPlayList.h"

NSString *const PlayCell = @"PlayCell";

@interface PublicVideoPlayListViewController()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MainVideoCellDelegate>
@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) NSArray<VideoPlayData *> *array;
@end

@implementation PublicVideoPlayListViewController
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        [self initTableView];
        [self GetAllVideoURL];
    }
    return self;
}


-(void)initTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.width,ScreenHeight - TabbarHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.tableView setAllowsSelection:NO];
    [self.tableView registerClass:[MainVideoCell class] forCellReuseIdentifier:PlayCell];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    self.currentIndex = 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ScreenHeight - TabbarHeight;
}

-(void)play{
    MainVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    [cell play];
}

-(void)pause{
    MainVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    [cell pause];
}

-(void)ReSetVideo{
    MainVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    [cell ReSetVideo];
}


- (void)UpdateCurrentPlayerPlayState:(BOOL)isplay{
    if(_delegate){
        [_delegate UpdateCurrentPlayerPlayState:isplay];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:PlayCell forIndexPath:indexPath];
    if(cell == nil){
        cell = [[MainVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PlayCell];
    }
    cell.delegate = self;
    if(self.array.count != 0){
        [cell SetVideoAssset:self.array[indexPath.row]];
    }
    return cell;
}

- (void)ScaleWithVideo:(UIPinchGestureRecognizer *)gesture isplay:(BOOL)isplay{
    if(self.delegate){
        [self.delegate ScaleWithVideo:gesture isplay:isplay];
    }
}

-(void)GetAllVideoURL{
    CustomLoadView *load = [CustomLoadView new];
    load.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    [self addSubview:load];
    MainVideoRequest *request = [MainVideoRequest new];
    [NetWorkHelper getWithUrlPath:MainVideoPath request:request success:^(id data) {
        MainVideoResponse *response = [[MainVideoResponse alloc] initWithDictionary:data error:nil];
        self.array = response.data;
        [self.tableView reloadData];
        [load removeFromSuperview];
    }faliure:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:self];
//    NSLog(@"%f scrollViewDidScroll",translatedPoint i吃7777777.y);
    MainVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    [cell SetContainerWithAlpha:(100 + translatedPoint.y) / 100 > 0.4 ? (100 + translatedPoint.y) / 100:0.4];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        //UITableView禁止响应其他滑动手势
        scrollView.panGestureRecognizer.enabled = NO;
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        if(translatedPoint.y < -50 && self.currentIndex < self.array.count - 1) {
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.y > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        
        [UIView animateWithDuration:0.15
             delay:0.0
           options:UIViewAnimationOptionCurveEaseOut animations:^{
               //UITableView滑动到指定cell
               [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
           } completion:^(BOOL finished) {
               //UITableView可以响应其他滑动手势
               scrollView.panGestureRecognizer.enabled = YES;
               MainVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
               [cell SetContainerWithAlpha:1];
           }];
    });
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"currentIndex"]){
        [[MainPlayList shareList] pauseAll];
        MainVideoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
        [cell.pauseIcon setHidden:YES];
        [cell startDownloadHighPriorityTask:self.array[self.currentIndex].video_url];
        if(cell.isPlayReady){
            [cell replay];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
