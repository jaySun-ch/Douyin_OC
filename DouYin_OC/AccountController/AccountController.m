//
//  AccountController.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/14.
//

#import "AccountController.h"
#import "VideoListCollectionView.h"
#import "ChangeBackGroundView.h"
#import "CustomImagePicker.h"
#import "ShowClientImageView.h"
#import "ChangeCurrentClientModelView.h"
#import "SetSliderBar.h"


#define HeaderHeight 460 + 40
#define navigationBarHeight 40

NSString *const HeaderCell = @"AccountHeaderCell";
NSString *const collectionCell = @"AccountCollectionCell";

@interface AccountController()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderTabbarDelegate,CustomMainCollectionViewCellDelegate,UIScrollViewDelegate,ChangeBackGroundViewDelegate,AccountHeaderViewDelegate>

@property (nonatomic,assign) CGFloat   itemWidth;
@property (nonatomic,assign) CGFloat   itemHeight;
@property (nonatomic,assign) NSInteger currentselectpage;
@property (nonatomic,assign) NSInteger currentPageCount;
@property (nonatomic,strong) AccountHeaderView *headerView;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyOwnVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyLoackVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyStarVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyLikeVideoList;
@property (nonatomic,strong) UIView *TopBar;
@property (nonatomic,strong) UILabel *navigationTitle;
@property (nonatomic,strong) UIButton *searchButton; //顶部的搜索button
@property (nonatomic,strong) UIButton *VirsitorButton; //顶部的访问button
@property (nonatomic,strong) UIButton *SetButton; //设置按钮
@property (nonatomic,strong) ChangeBackGroundView *changeClientBackgroundView;
@end

@implementation AccountController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self.navigationController SetNavigationBarBackgroundClear];
    [self.collectionview reloadSections:[NSIndexSet indexSetWithIndex:0]];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//  [self.navigationController SetNavigationBarBackgoundWhite];
}



- (void)viewDidLoad{
    [super viewDidLoad];
    [UIWindow AddSetSliderBar];
    UIScreenEdgePanGestureRecognizer *edgegesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(ScreenEdgeGestureHandler:)];
    edgegesture.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:edgegesture];
    [self.view setUserInteractionEnabled:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    _MyOwnVideoList = [NSMutableArray arrayWithObjects:@"1",nil];
    _MyLoackVideoList = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",nil];
    _MyStarVideoList = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",nil];
    _MyLikeVideoList = [NSMutableArray arrayWithObjects:@"1",@"1",nil];
    [self initCollectionView];
    [self initTopBar];
}

-(void)ScreenEdgeGestureHandler:(UIScreenEdgePanGestureRecognizer *)gesture{
    [UIWindow ShowSetSliderBarWithTrans:gesture];

}

-(void)initChangeBackgroundView{
    self.changeClientBackgroundView = [[ChangeBackGroundView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.changeClientBackgroundView.delegate = self;
    self.changeClientBackgroundView.alpha = 0;
    self.changeClientBackgroundView.backgroundImage.transform = CGAffineTransformMakeTranslation(0, -ScreenHeight/2);
    [UIApplication.sharedApplication.delegate.window addSubview:self.changeClientBackgroundView];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.changeClientBackgroundView.alpha = 1;
        self.changeClientBackgroundView.backgroundImage.transform = CGAffineTransformMakeTranslation(0, 0);
        UIButton *dismissButton = [[UIButton alloc] init];
        dismissButton.frame = CGRectMake(20, 50, 30, 30);
        [dismissButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
        [dismissButton setTintColor:[UIColor whiteColor]];
        [dismissButton addTarget:self action:@selector(DismissChangeBackgroundMode) forControlEvents:UIControlEventTouchUpInside];
        [self.changeClientBackgroundView addSubview:dismissButton];
    } completion:nil];
}

-(void)DismissChangeBackgroundMode:(BOOL)isUp{
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if(isUp){
            self.changeClientBackgroundView.backgroundImage.transform = CGAffineTransformMakeTranslation(0, ScreenHeight);
        }else{
            self.changeClientBackgroundView.backgroundImage.transform = CGAffineTransformMakeTranslation(0, -ScreenHeight/2);
        }
        self.changeClientBackgroundView.alpha = 0;
    } completion:^(BOOL finished) {
//        [self.navigationController setNavigationBarHidden:YES];
        [self.changeClientBackgroundView removeFromSuperview];
    }];
}

- (void)ShowSelectBackGroundViewController{
//    CustomImagePicker *newvc = [CustomImagePicker new];
//    newvc.type = PickerImageClientBackground;
//    [newvc.view setBackgroundColor:[UIColor whiteColor]];
//    [self presentViewController:newvc animated:YES completion:nil];
    BRMediaConfig *config = [[BRMediaConfig alloc] init];
    config.type = BRImage;
    config.backgroundColor = [UIColor whiteColor];
    config.pickLimit = 1;
    config.GridCount = 3;
    config.isShowMultiPickDetial = YES;
    config.isCropImage = YES;
    [UIWindow PresentPickerWithConfig:config];
}

- (void)DismissBackGroundView:(BOOL)isUp { 
    [self DismissChangeBackgroundMode:isUp];
}


-(void)DismissChangeBackgroundMode{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.changeClientBackgroundView.backgroundImage.transform = CGAffineTransformMakeTranslation(0, -ScreenHeight/2);
        self.changeClientBackgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.changeClientBackgroundView removeFromSuperview];
    }];
}


- (void)OnTapView:(NSInteger)view{
    if(view == AccountHeadBackGround){
        [self initChangeBackgroundView];
    }else if(view == AccountHeadClientImage){
        [self ShowClientImage];
    }else if(view == AccountHeadClientNameRightButton){
        [self presentPanModal:[ChangeCurrentClientModelView new]];
    }
}

-(void)ShowClientImage{
    ShowClientImageView *vc = [[ShowClientImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [UIWindow AddSubView:vc];
    [vc StartAnimation];
}

-(void)initTopBar{
    _TopBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth,100)];
    _TopBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_TopBar];
    
    _navigationTitle = [[UILabel alloc] init];
    [_navigationTitle setText:[AppUserData GetCurrenUser].username];
    _navigationTitle.textColor = [UIColor clearColor];
    [_navigationTitle setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]];
    
    _searchButton = [[UIButton alloc] init];
    [_searchButton setImage:[UIImage systemImageNamed:@"magnifyingglass"] forState:UIControlStateNormal];
    
    _VirsitorButton = [[UIButton alloc] init];
    [_VirsitorButton setImage:[UIImage systemImageNamed:@"person.2"] forState:UIControlStateNormal];
    
    _SetButton = [[UIButton alloc] init];
    [_SetButton addTarget:self action:@selector(ShowSetSliderBar) forControlEvents:UIControlEventTouchUpInside];
    [_SetButton setImage:[UIImage systemImageNamed:@"line.3.horizontal"] forState:UIControlStateNormal];
    
    _SetButton.backgroundColor = [UIColor darkGrayColor];
    [_SetButton setTintColor:[UIColor whiteColor]];
    _SetButton.alpha = 0.6;
    _SetButton.layer.cornerRadius = 16;
    _searchButton.backgroundColor = [UIColor darkGrayColor];
    [_searchButton setTintColor:[UIColor whiteColor]];
    _searchButton.layer.cornerRadius = 16;
    _searchButton.alpha = 0.6;
    _VirsitorButton.backgroundColor = [UIColor darkGrayColor];
    [_VirsitorButton setTintColor:[UIColor whiteColor]];
    _VirsitorButton.layer.cornerRadius = 16;
    _VirsitorButton.alpha = 0.6;
    
    [_TopBar addSubview:_navigationTitle];
    [_TopBar addSubview:_searchButton];
    [_TopBar addSubview:_SetButton];
    [_TopBar addSubview:_VirsitorButton];
    
    [_navigationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_TopBar);
        make.top.equalTo(_TopBar).inset(50);
    }];
    
    [_SetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_TopBar).inset(10);
        make.top.equalTo(_TopBar).inset(45);
        make.width.height.mas_equalTo(32);
    }];
    
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_SetButton.mas_left).inset(10);
        make.top.equalTo(_TopBar).inset(45);
        make.width.height.mas_equalTo(32);
    }];
    
    [_VirsitorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_searchButton.mas_left).inset(10);
        make.top.equalTo(_TopBar).inset(45);
        make.width.height.mas_equalTo(32);
    }];
}

-(void)ShowSetSliderBar{
    [UIWindow ShowSetSliderBar];
}


-(void)initCollectionView{
    _itemWidth = (ScreenWidth - (CGFloat)(((NSInteger)(ScreenWidth)) % 3) ) / 3.0f - 1.0f;
    _itemHeight = _itemWidth * 1.35f;
    CustomCollectionLayout *layout = [[CustomCollectionLayout alloc] initWithTopHeight:SafeAreaTopHeight + navigationBarHeight];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 0;
    _collectionview = [[UICollectionView  alloc]initWithFrame:ScreenFrame collectionViewLayout:layout];
    _collectionview.backgroundColor = [UIColor clearColor];
    _collectionview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _collectionview.alwaysBounceVertical = YES;
    _collectionview.showsVerticalScrollIndicator = NO;
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    [_collectionview registerClass:[AccountHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCell];
    [_collectionview registerClass:[CustomMainCollectionViewCell class] forCellWithReuseIdentifier:collectionCell];
    [self.view addSubview:_collectionview];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 1){
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCell forIndexPath:indexPath];
    [cell initWithData:self.currentselectpage MyOwnVideoList:self.MyOwnVideoList MyLoackVideoList:self.MyLoackVideoList MyStarVideoList:self.MyStarVideoList MyLikeVideoList:self.MyLikeVideoList];
    cell.delegate = self;
    return cell;
}



- (void)updateNavigationTitle:(CGFloat)offsetY {
    NSLog(@"%f offsetY",offsetY);
    if(offsetY < 30){
        self.VirsitorButton.alpha = (30-offsetY) / 30 < 0.8 ? (30-offsetY) / 30:0.8;
    }else if(offsetY < 1){
        self.VirsitorButton.alpha = 0.8;
    }else{
        self.VirsitorButton.alpha = 0;
    }
    
    if (HeaderHeight - navigationBarHeight*2 > offsetY) {
        self.TopBar.backgroundColor = [UIColor clearColor];
        self.navigationTitle.textColor = [UIColor clearColor];
        [self SetTopButtonDarlStyle];
    }
    
    if (HeaderHeight - navigationBarHeight*2 < offsetY && offsetY < ScreenHeight / 2 - navigationBarHeight) {
        CGFloat alphaRatio =  1.0f - (ScreenHeight / 2 - navigationBarHeight - offsetY)/navigationBarHeight;
        [self.TopBar setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alphaRatio]];
        [self.navigationTitle setTextColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:alphaRatio]];
        [self SetTopButtonLightStyle];
    }
    if (offsetY >HeaderHeight - navigationBarHeight) {
        [self.TopBar setBackgroundColor:[UIColor clearColor]];
        self.navigationTitle.textColor = [UIColor blackColor];
        [self SetTopButtonLightStyle];
    }
}


-(void)SetTopButtonDarlStyle{
    _SetButton.backgroundColor = [UIColor darkGrayColor];
    [_SetButton setTintColor:[UIColor whiteColor]];
    _SetButton.alpha = 0.6;
    _SetButton.layer.cornerRadius = 16;
    _searchButton.backgroundColor = [UIColor darkGrayColor];
    [_searchButton setTintColor:[UIColor whiteColor]];
    _searchButton.layer.cornerRadius = 16;
    _searchButton.alpha = 0.6;
}

-(void)SetTopButtonLightStyle{
    _SetButton.backgroundColor = [UIColor clearColor];
    [_SetButton setTintColor:[UIColor blackColor]];
    _searchButton.backgroundColor = [UIColor clearColor];
    [_searchButton setTintColor:[UIColor blackColor]];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y <= 0){
        [self.headerView ScaleBackGroundImage:scrollView.contentOffset.y];
    }
    
    if(scrollView.contentOffset.y >= 0){
        [self updateNavigationTitle:scrollView.contentOffset.y];
        [self.headerView UpdatecontainerViewAlpha:scrollView.contentOffset.y];
    }
    NSLog(@"%f trans",scrollView.contentOffset.y);
}

- (void)DidScrollToPageIndex:(NSInteger)index{
    if(self.currentselectpage != index){
        self.currentselectpage = index;
        switch (index) {
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
                break;
        }
        [self.collectionview reloadSections:[NSIndexSet indexSetWithIndex:1]];
        [self.headerView ScrollToPageIndex:index];
        [self updateNavigationTitle:self.collectionview.contentOffset.y];
    }
}

- (void)DidSelectIndex:(NSInteger)index{
    if(self.currentselectpage != index){
        self.currentselectpage = index;
        switch (index) {
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
        [self.collectionview reloadSections:[NSIndexSet indexSetWithIndex:1]];
        CustomMainCollectionViewCell *cell = [self.collectionview cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        [cell ScrollToSelectPage:index];
        [self.headerView SelectPageChangeAlpha];
        [self updateNavigationTitle:self.collectionview.contentOffset.y];
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && kind == UICollectionElementKindSectionHeader) {
        NSLog(@"%ld %ld indexPath",indexPath.row,indexPath.section);
        AccountHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderCell forIndexPath:indexPath];
        header.tabbar.delegate = self;
        _headerView = header;
        header.delegate = self;
        [header initData];
        return header;
    }
    UICollectionReusableView *cell = [UICollectionReusableView new];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return CGSizeMake(ScreenWidth,HeaderHeight);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger line = (_currentPageCount / 3) + 1;
    if(_currentPageCount % 3 == 0){
        line = (_currentPageCount / 3);
    }else{
        line = (_currentPageCount / 3) + 1;
    }
    NSLog(@"%f LineCount",_itemHeight * line);
    return  CGSizeMake(ScreenWidth,(_itemHeight * line)+150);
}



@end
