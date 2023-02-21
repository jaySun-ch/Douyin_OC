//
//  VideoAccountDetialView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/1/7.
//

#import "VideoAccountDetialView.h"
#import "VideoListCollectionView.h"
#import "ChangeBackGroundView.h"
#import "CustomImagePicker.h"
#import "ShowClientImageView.h"
#import "ChangeCurrentClientModelView.h"
#import "SetSliderBar.h"


#define VideoHeaderHeight 460 + 40
#define VideonavigationBarHeight 40

NSString *const VideoHeaderCell = @"AccountHeaderCell";
NSString *const VideocollectionCell = @"AccountCollectionCell";

@interface VideoAccountDetialView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HeaderTabbarDelegate,VideoAccountMainCellDelegate,UIScrollViewDelegate,ChangeBackGroundViewDelegate,VideoAccountHeaderCellDelegate>
@property (nonatomic,strong) ClientData *userData;
@property (nonatomic,assign) CGFloat   itemWidth;
@property (nonatomic,assign) CGFloat   itemHeight;
@property (nonatomic,assign) NSInteger currentselectpage;
@property (nonatomic,assign) NSInteger currentPageCount;
@property (nonatomic,strong) VideoAccountHeaderCell *headerView;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyOwnVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyLoackVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyStarVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyLikeVideoList;
@property (nonatomic,strong) UIView *TopBar;
@property (nonatomic,strong) UILabel *navigationTitle;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UIButton *searchButton; //顶部的搜索button
@property (nonatomic,strong) UIButton *SetButton; //设置按钮
@property (nonatomic,strong) ChangeBackGroundView *changeClientBackgroundView;
@end

@implementation VideoAccountDetialView

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.collectionview reloadSections:[NSIndexSet indexSetWithIndex:0]];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setUserInteractionEnabled:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    GetUserWithIdRequest  *request = [[GetUserWithIdRequest alloc] init];
    request.ID = self.user_id;
    [NetWorkHelper getWithUrlPath:GetUserByIDPath request:request success:^(id data) {
        GetUserResponse *response = [[GetUserResponse alloc] initWithDictionary:data error:nil];
        if(![response.status isEqualToString:@"faliure"] ){
            ClientData *clientdata = [[ClientData alloc] initWithData:response.msg IsSign:YES];
            self.userData = clientdata;
            self.MyOwnVideoList = [NSMutableArray arrayWithObjects:@"1",nil];
            self.MyLoackVideoList = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",nil];
            self.MyStarVideoList = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",nil];
            self.MyLikeVideoList = [NSMutableArray arrayWithObjects:@"1",@"1",nil];
            [self initCollectionView];
            [self initTopBar];
        }
    } faliure:^(NSError *error) {
        [UIWindow showTips:@"获取失败"];
    }];
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
        [self.changeClientBackgroundView removeFromSuperview];
    }];
}

- (void)ShowSelectBackGroundViewController{
    CustomImagePicker *newvc = [CustomImagePicker new];
    newvc.type = PickerImageClientBackground;
    [newvc.view setBackgroundColor:[UIColor whiteColor]];
    [self presentViewController:newvc animated:YES completion:nil];
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
    if(view == VideoAccountHeadBackGround){
        [self initChangeBackgroundView];
    }else if(view == VideoAccountHeadClientImage){
        [self ShowClientImage];
    }else if(view == VideoAccountHeadClientNameRightButton){
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
    [_navigationTitle setText:self.userData.username];
    _navigationTitle.textColor = [UIColor clearColor];
    [_navigationTitle setFont:[UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]];
    
    _backButton = [[UIButton alloc] init];
    [_backButton addTarget:self action:@selector(DismissView) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
    
    _searchButton = [[UIButton alloc] init];
    [_searchButton setImage:[UIImage systemImageNamed:@"magnifyingglass"] forState:UIControlStateNormal];
    
    _SetButton = [[UIButton alloc] init];
    [_SetButton addTarget:self action:@selector(ShowSetSliderBar) forControlEvents:UIControlEventTouchUpInside];
    [_SetButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    
    _SetButton.backgroundColor = [UIColor darkGrayColor];
    [_SetButton setTintColor:[UIColor whiteColor]];
    _SetButton.alpha = 0.6;
    _SetButton.layer.cornerRadius = 16;
    
    _searchButton.backgroundColor = [UIColor darkGrayColor];
    [_searchButton setTintColor:[UIColor whiteColor]];
    _searchButton.layer.cornerRadius = 16;
    _searchButton.alpha = 0.6;
    
    _backButton.backgroundColor = [UIColor darkGrayColor];
    [_backButton setTintColor:[UIColor whiteColor]];
    _backButton.layer.cornerRadius = 16;
    _backButton.alpha = 0.6;
    
    [_TopBar addSubview:_navigationTitle];
    [_TopBar addSubview:_searchButton];
    [_TopBar addSubview:_SetButton];
    [_TopBar addSubview:_backButton];
    
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
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).inset(10);
        make.top.equalTo(_TopBar).inset(45);
        make.width.height.mas_equalTo(32);
    }];
}

-(void)DismissView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



-(void)initCollectionView{
    _itemWidth = (ScreenWidth - (CGFloat)(((NSInteger)(ScreenWidth)) % 3) ) / 3.0f - 1.0f;
    _itemHeight = _itemWidth * 1.35f;
    CustomCollectionLayout *layout = [[CustomCollectionLayout alloc] initWithTopHeight:SafeAreaTopHeight + VideonavigationBarHeight];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 0;
    _collectionview = [[UICollectionView  alloc]initWithFrame:ScreenFrame collectionViewLayout:layout];
    _collectionview.backgroundColor = [UIColor clearColor];
    _collectionview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _collectionview.alwaysBounceVertical = YES;
    _collectionview.showsVerticalScrollIndicator = NO;
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    [_collectionview registerClass:[VideoAccountHeaderCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VideoHeaderCell];
    [_collectionview registerClass:[VideoAccountMainCell class] forCellWithReuseIdentifier:VideocollectionCell];
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
    VideoAccountMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideocollectionCell forIndexPath:indexPath];
    [cell initWithData:self.currentselectpage MyOwnVideoList:self.MyOwnVideoList MyLoackVideoList:self.MyLoackVideoList MyStarVideoList:self.MyStarVideoList MyLikeVideoList:self.MyLikeVideoList];
    cell.delegate = self;
    return cell;
}



- (void)updateNavigationTitle:(CGFloat)offsetY {
    NSLog(@"%f offsetY",offsetY);
    if (VideoHeaderHeight - VideonavigationBarHeight*2 > offsetY) {
        self.TopBar.backgroundColor = [UIColor clearColor];
        self.navigationTitle.textColor = [UIColor clearColor];
        [self SetTopButtonDarlStyle];
    }
    
    if (VideoHeaderHeight - VideonavigationBarHeight*2 < offsetY && offsetY < ScreenHeight / 2 - VideonavigationBarHeight) {
        CGFloat alphaRatio =  1.0f - (ScreenHeight / 2 - VideonavigationBarHeight - offsetY)/VideonavigationBarHeight;
        [self.TopBar setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alphaRatio]];
        [self.navigationTitle setTextColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:alphaRatio]];
        [self SetTopButtonLightStyle];
    }
    if (offsetY >VideoHeaderHeight - VideonavigationBarHeight) {
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
    _backButton.backgroundColor = [UIColor darkGrayColor];
    [_backButton setTintColor:[UIColor whiteColor]];
    _backButton.layer.cornerRadius = 16;
    _backButton.alpha = 0.6;
}

-(void)SetTopButtonLightStyle{
    _SetButton.backgroundColor = [UIColor clearColor];
    [_SetButton setTintColor:[UIColor blackColor]];
    _searchButton.backgroundColor = [UIColor clearColor];
    [_searchButton setTintColor:[UIColor blackColor]];
    _backButton.backgroundColor = [UIColor clearColor];
    [_backButton setTintColor:[UIColor blackColor]];
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
        VideoAccountMainCell *cell = [self.collectionview cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        [cell ScrollToSelectPage:index];
        [self.headerView SelectPageChangeAlpha];
        [self updateNavigationTitle:self.collectionview.contentOffset.y];
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && kind == UICollectionElementKindSectionHeader) {
        NSLog(@"%ld %ld indexPath",indexPath.row,indexPath.section);
        VideoAccountHeaderCell *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:VideoHeaderCell forIndexPath:indexPath];
        header.tabbar.delegate = self;
        _headerView = header;
        header.delegate = self;
        [header initData:self.userData];
        return header;
    }
    UICollectionReusableView *cell = [UICollectionReusableView new];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return CGSizeMake(ScreenWidth,VideoHeaderHeight);
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
