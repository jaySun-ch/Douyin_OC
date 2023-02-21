//
//  PublicSearchResultView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//

#import "PublicSearchResultView.h"
#import "ResultOfClientView.h"

#define NavigationBarHeight 100
#define SliderBarHeight 40
@interface PublicSearchResultView()<UISearchBarDelegate,UIScrollViewDelegate,BRSliderBarDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UISearchBar *searhBar;
@property (nonatomic,strong) BRSliderBar *SliderBar;
@property (nonatomic,strong) UIScrollView *PageView;
@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSArray<NSString *> *PageArray;
@property (nonatomic,strong) ResultOfClientView *resultView;

@end


@implementation PublicSearchResultView

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.PageArray = @[@"综合",@"视频",@"用户",@"音乐",@"直播",@"地点",@"话题"];
    [self SetNavigationBar];
    [self initPageView];
    [self initSliderBar];
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
}

#pragma 设置顶部导航栏
-(void)SetNavigationBar{
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.left"] style:UIBarButtonItemStylePlain target:self action:@selector(DismissView)]];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(Search)]];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    self.searhBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 150, 40)];
    self.searhBar.placeholder = @"搜索点什么吧";
    self.searhBar.delegate = self;
    self.searhBar.searchTextField.delegate = self;
    if(self.SearchText != nil){
        self.searhBar.searchTextField.text = self.SearchText;
    }
    [self.navigationItem setTitleView:self.searhBar];
}

-(void)Search{
    [self ReloadCurrentData];
}

-(void)DismissView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self ReloadCurrentData];
    [textField resignFirstResponder];
    return YES;
}

#pragma 设置导航栏下方的分页栏
-(void)initSliderBar{
    self.SliderBar = [[BRSliderBar alloc] initWithFrame:CGRectMake(0,NavigationBarHeight, ScreenWidth, SliderBarHeight) Style:BRSliderBarWithfilter TitleArray:self.PageArray ];
    [self.SliderBar setIndex:1];
    self.SliderBar.delegate = self;
    [self.view addSubview:self.SliderBar];
}

- (void)BRSliderDidTapOnButtonWithTag:(NSInteger)Tag{
    self.currentIndex = Tag - 1;
    [self.PageView scrollRectToVisible:CGRectMake(ScreenWidth * self.currentIndex,0,ScreenWidth,self.PageView.frame.size.height) animated:NO];
}

#pragma 重新加载数据
-(void)ReloadCurrentData{
    if(![self.searhBar.searchTextField.text isEqualToString:@""]){
        if(self.currentIndex == 2){
            [self.resultView ReloadDataWith:self.searhBar.searchTextField.text];
        }
    }
}


#pragma 设置导航栏下方的页面内容
-(void)initPageView{
    self.PageView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,NavigationBarHeight + SliderBarHeight, ScreenWidth, ScreenHeight - NavigationBarHeight - SliderBarHeight)];
    self.PageView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.PageView.delegate = self;
    [self.PageView setBounces:NO];
    self.PageView.contentSize = CGSizeMake(self.PageView.frame.size.width * 7, self.PageView.frame.size.height);
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.PageView.frame.size.height)];
    view1.backgroundColor = [UIColor cyanColor];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, self.PageView.frame.size.height)];
    view2.backgroundColor = [UIColor redColor];
    self.resultView = [[ResultOfClientView alloc] initWithFrame:CGRectMake(ScreenWidth * 2, 0, ScreenWidth, self.PageView.frame.size.height) SearchText:self.SearchText];
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth * 3, 0, ScreenWidth, self.PageView.frame.size.height)];
    view4.backgroundColor = [UIColor systemPinkColor];
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth * 4, 0, ScreenWidth, self.PageView.frame.size.height)];
    view5.backgroundColor = [UIColor purpleColor];
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth * 5, 0, ScreenWidth, self.PageView.frame.size.height)];
    view6.backgroundColor = [UIColor yellowColor];
    UIView *view7 = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth * 6, 0, ScreenWidth, self.PageView.frame.size.height)];
    view7.backgroundColor = [UIColor greenColor];
    [self.PageView addSubview:view1];
    [self.PageView addSubview:view2];
    [self.PageView addSubview:self.resultView];
    [self.PageView addSubview:view4];
    [self.PageView addSubview:view5];
    [self.PageView addSubview:view6];
    [self.PageView addSubview:view7];
    [self.view addSubview:self.PageView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint translatedPoint = [scrollView.panGestureRecognizer translationInView:scrollView];
        scrollView.panGestureRecognizer.enabled = NO;
        if(translatedPoint.x < -50 && self.currentIndex < self.PageArray.count-1){
            self.currentIndex ++;   //向下滑动索引递增
        }
        if(translatedPoint.x > 50 && self.currentIndex > 0) {
            self.currentIndex --;   //向上滑动索引递减
        }
        [UIView animateWithDuration:0.15
             delay:0.0
           options:UIViewAnimationOptionCurveEaseOut animations:^{
               //UITableView滑动到指定cell
            [scrollView scrollRectToVisible:CGRectMake(ScreenWidth * self.currentIndex,0,ScreenWidth,self.PageView.frame.size.height) animated:NO];
           } completion:^(BOOL finished) {
               //UITableView可以响应其他滑动手势
               scrollView.panGestureRecognizer.enabled = YES;
        }];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"currentIndex"]){
        [self.SliderBar setIndex:self.currentIndex+1];
        [self ReloadCurrentData];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
