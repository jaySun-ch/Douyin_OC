//
//  VideoAccountMainCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/1/7.
//

#import "VideoAccountMainCell.h"
#import "VideoListCollectionView.h"

@interface VideoAccountMainCell() <UIScrollViewDelegate>
@property (nonatomic,assign) CGFloat   itemWidth;
@property (nonatomic,assign) CGFloat   itemHeight;
@property (nonatomic,assign) NSInteger currentPageCount;
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) VideoListCollectionView *view1;
@property (nonatomic,strong) VideoListCollectionView *view2;

@end


@implementation VideoAccountMainCell

- (void)prepareForReuse{
    [super prepareForReuse];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _itemWidth = (ScreenWidth - (CGFloat)(((NSInteger)(ScreenWidth)) % 3) ) / 3.0f - 1.0f;
        _itemHeight = _itemWidth * 1.35f;
        _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
        _scrollview.delegate = self;
        _view1 = [[VideoListCollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
        
        _view2 = [[VideoListCollectionView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, self.frame.size.height)];
        _scrollview.contentSize = CGSizeMake(ScreenWidth * 4, self.frame.size.height);
        [_scrollview setBounces:NO];
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.alwaysBounceHorizontal = YES;
        _scrollview.pagingEnabled = NO;
        [_scrollview addSubview:_view1];
        [_scrollview addSubview:_view2];
        [self addSubview:_scrollview];
        [self addObserver:self forKeyPath:@"currentPageIndex" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"currentPageIndex"]){
        if(self.delegate){
            [self.delegate DidScrollToPageIndex:self.currentPageIndex];
        }
        [self UpdateSrollFrame];
    }else{
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)initWithData:(NSInteger)currentpageIndex MyOwnVideoList:(NSMutableArray<NSString*>*) MyOwnVideoList MyLoackVideoList:(NSMutableArray<NSString*>*) MyLoackVideoList MyStarVideoList:(NSMutableArray<NSString*>*) MyStarVideoList MyLikeVideoList:(NSMutableArray<NSString*>*) MyLikeVideoList{
    self.MyOwnVideoList = MyOwnVideoList;
    self.MyLoackVideoList = MyLoackVideoList;
    [_view1 SetData:self.MyOwnVideoList];
    [_view2 SetData:self.MyLoackVideoList];
    self.currentPageIndex = currentpageIndex;
    [self.scrollview scrollRectToVisible:CGRectMake(ScreenWidth * currentpageIndex, 0, ScreenWidth,self.frame.size.height) animated:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [self.scrollview.panGestureRecognizer translationInView:self.scrollview];
        self.scrollview.panGestureRecognizer.enabled = NO;

        if(translatedPoint.x < -50 && self.currentPageIndex < 1){
            self.currentPageIndex ++;   //向下滑动索引递增
        }

        if(translatedPoint.x > 50 && self.currentPageIndex > 0) {
            self.currentPageIndex --;   //向上滑动索引递减
        }
        
        NSLog(@"%ld currentPageIndex",self.currentPageIndex);

        [UIView animateWithDuration:0.15
             delay:0.0
           options:UIViewAnimationOptionCurveEaseOut animations:^{
               //UITableView滑动到指定cell
            [self.scrollview scrollRectToVisible:CGRectMake(ScreenWidth * self.currentPageIndex, 0, ScreenWidth, self.frame.size.height) animated:NO];
           } completion:^(BOOL finished) {
               //UITableView可以响应其他滑动手势
               self.scrollview.panGestureRecognizer.enabled = YES;
        }];
    });
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    self.currentPageIndex = (NSInteger)(scrollView.contentOffset.x / ScreenWidth);
//
////    [self ScrollToSelectPage:self.currentPageIndex];
//}


-(void)ScrollToSelectPage:(NSInteger) PageIndex{
    NSLog(@"ScrollToSelectPage");
    self.currentPageIndex = PageIndex;
    [self UpdateSrollFrame];
    [self.scrollview scrollRectToVisible:CGRectMake(ScreenWidth * PageIndex, 0, ScreenWidth,self.frame.size.height) animated:YES];
}


-(void)UpdateSrollFrame{
    switch (self.currentPageIndex) {
        case 1:
            self.currentPageCount = self.MyLoackVideoList.count;
            break;
        case 2:
            self.currentPageCount = self.MyStarVideoList.count;
            break;
        case 3:
            self.currentPageCount = self.MyLikeVideoList.count;
            break;
        default:
            self.currentPageCount = self.MyOwnVideoList.count;
    }
    NSInteger line = (self.currentPageCount / 3) + 1;
    if(self.currentPageCount % 3 == 0){
        line = (self.currentPageCount / 3);
    }else{
        line = (self.currentPageCount / 3) + 1;
    }
    CGFloat height = (_itemHeight * line) ;
    self.scrollview.frame = CGRectMake(0, 0, ScreenWidth,height + 10);
    self.scrollview.contentSize = CGSizeMake(ScreenWidth * 4,height + 10);
    switch (self.currentPageIndex) {
        case 1:
            _view2.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollview.frame.size.height);
            [_view2 UpdateFrame:self.scrollview.frame.size.height];
            break;
        default:
            _view1.frame = CGRectMake(0, 0, ScreenWidth, self.scrollview.frame.size.height);
            [_view1 UpdateFrame:self.scrollview.frame.size.height];
    }
    NSLog(@"%ld %ld UpdateSrollFrame",self.currentPageIndex,line);
}
@end
