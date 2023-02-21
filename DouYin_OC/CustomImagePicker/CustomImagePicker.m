//
//  CustomImagePicker.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/5.
//

#import "CustomImagePicker.h"
#import "CustomColletionImageCell.h"
#import "BRCenterButton.h"
#import "CustomTableCell.h"
#import "CustomImageCropView.h"
#import "CustomBackGroundCropView.h"

NSString *const Imagecell = @"ImageCell";
NSString *const TableCell = @"TableCell";

@interface CustomImagePicker()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) PHImageManager *imageManager;
@property (nonatomic,assign) CGSize assetGridThumbnailSize;
@property (nonatomic,strong) NSMutableArray<ImageAlbumItem*> *items;
@property (nonatomic,strong) ImageAlbumItem *currentItem;
@property (nonatomic,strong) UIView *TopBar;
@property (nonatomic,strong) BRCenterButton *CenterButton;
@property (nonatomic,assign) BOOL IsShowTable;
@end

@implementation CustomImagePicker

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.imageManager = [PHCachingImageManager defaultManager];
    self.assetGridThumbnailSize = CGSizeMake(((ScreenWidth/3)-1) * (UIScreen.mainScreen.scale), ((ScreenWidth/3)-1) * (UIScreen.mainScreen.scale));
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setClipsToBounds:YES];
    [self initColletionViews];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if(status != PHAuthorizationStatusAuthorized){
            return;
        }
        self.items = [NSMutableArray array];
        PHFetchOptions *options = [PHFetchOptions new];
        PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:options];
        [self convertCollection:smartAlbums];
        PHFetchResult<PHCollection*> *userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        [self convertCollection:userCollections];
        NSArray *sortArray = [self.items sortedArrayUsingComparator:^NSComparisonResult(ImageAlbumItem *obj1, ImageAlbumItem *obj2) {
            if(obj1.fetchResult.count > obj2.fetchResult.count){
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }];
        [self.items removeAllObjects];
        [self.items addObjectsFromArray:sortArray];
        self.currentItem = self.items.firstObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self initTopBar];
        });
    }];
}


-(void)ShowTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.transform = CGAffineTransformMakeTranslation(0,-ScreenHeight);
    [self.tableView registerClass:[CustomTableCell class] forCellReuseIdentifier:TableCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.TopBar removeFromSuperview];
    [self initTopBar];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0,0);
    }];
}

-(void)DismissTableView{
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0,-ScreenHeight);
    } completion:^(BOOL finished) {
        [self.tableView removeFromSuperview];
        [self.collectionView scrollToTopAnimated:YES];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.items.count){
        return 100;
    }else{
        return 50;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.IsShowTable = NO;
    self.currentItem = self.items[indexPath.row];
    [self.collectionView reloadData];
    [self.CenterButton ResetTitle:self.currentItem.title];
    [self.CenterButton RoateIcon:self.IsShowTable];
    [self DismissTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.items.count){
        CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:TableCell];
        NSLog(@"%@ Title",self.items[indexPath.row].title);
        PHAsset *asset = self.items[indexPath.row].fetchResult.firstObject;
        // 这个不可以这样用 因为会导致 在复用的时候回重复进行加载；
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(80 * (UIScreen.mainScreen.scale),80 * (UIScreen.mainScreen.scale)) contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [cell initWithData:result title:self.items[indexPath.row].title subtitle:[NSString stringWithFormat:@"%ld",self.items[indexPath.row].fetchResult.count]];
        }];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        return cell;
    }
}

-(void)initTopBar{
    self.TopBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    [self.TopBar setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.TopBar];
    self.CenterButton = [[BRCenterButton alloc] initWithFrame: CGRectMake(0, 0, 100, 30)];
    [self.CenterButton setUserInteractionEnabled:YES];
    self.CenterButton.center = self.TopBar.center;
    [self.CenterButton initWithData:self.currentItem.title];
    [self.CenterButton addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(EditTableViewMode)]];
    [self.TopBar addSubview:self.CenterButton];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [backButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor blackColor]];
    [backButton addTarget:self action:@selector(DismissView) forControlEvents:UIControlEventTouchUpInside];
    [self.TopBar addSubview:backButton];
}

-(void)EditTableViewMode{
    if(self.IsShowTable){
        self.IsShowTable = NO;
        [self DismissTableView];
    }else{
        self.IsShowTable = YES;
        [self ShowTableView];
    }
    [self.CenterButton RoateIcon:self.IsShowTable];
}

-(void)DismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initColletionViews{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    [layout setItemSize:CGSizeMake((ScreenWidth/3)-1,(ScreenWidth/3)-1)];
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,50, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[CustomColletionImageCell class] forCellWithReuseIdentifier:Imagecell];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionView];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"%ld currentItemfetchResult",self.currentItem.fetchResult.count);
    return self.currentItem.fetchResult.count + 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.currentItem.fetchResult.count){
        CustomColletionImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Imagecell forIndexPath:indexPath];
        cell.backgroundColor = [UIColor grayColor];
        PHAsset *asset = self.currentItem.fetchResult[indexPath.row];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = NO;
        [self.imageManager requestImageForAsset:asset targetSize:self.assetGridThumbnailSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.image.image = result;
        }];
        return cell;
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PHAsset *asset = self.currentItem.fetchResult[indexPath.row];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeNone;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

    [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if(self.type == PickerImageClientImage){
            CustomImageCropView *vc = [[CustomImageCropView alloc] initWithImage:result];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }else if(self.type == PickerImageClientBackground){
            CustomBackGroundCropView  *vc = [[CustomBackGroundCropView alloc] initWithImage:result];
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
   
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((ScreenWidth/3)-1,(ScreenWidth/3)-1);
}

-(void)convertCollection:(PHFetchResult<PHAssetCollection *> *) collection{
    for (NSInteger i = 0; i < collection.count; i++) {
        PHFetchOptions *options = [PHFetchOptions new];
        options.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
        options.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"mediaType = %ld",PHAssetMediaTypeImage]];
        
        PHFetchResult<PHAsset *> *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection[i] options:options];
        if(assetsFetchResult.count > 0){
            NSString *title = [self titleOfAlbumForChinse:collection[i].localizedTitle];
            [self.items addObject:[ImageAlbumItem initWithData:title fetchResult:assetsFetchResult]];
            NSLog(@"%@ %ld",title,i);
        }
    }
}

-(NSString *)titleOfAlbumForChinse:(NSString *)title{
    if([title isEqualToString:@"Slo-mo"]) {
        return @"慢动作";
    } else if([title isEqualToString:@"Recently Added"]){
        return @"最近添加";
    } else if([title isEqualToString:@"Favorites"]){
        return @"个人收藏";
    } else if([title isEqualToString:@"Recently Deleted"]){
        return @"最近删除";
    } else if([title isEqualToString:@"Videos"]){
        return @"视频";
    } else if([title isEqualToString:@"All Photos"]){
        return @"所有照片";
    } else if([title isEqualToString:@"Selfies"]){
        return @"自拍";
    } else if([title isEqualToString:@"Screenshots"]){
        return @"屏幕快照";
    } else if([title isEqualToString:@"Camera Roll"]){
        return @"相机胶卷";
    }else if([title isEqualToString:@"Recents"]){
        return @"最近项目";
    }else if([title isEqualToString:@"Not Uploaded to iCloud"]){
        return @"未上传iCloud的照片";
    }else if([title isEqualToString:@"Portrait"]){
        return @"人像";
    }else if([title isEqualToString:@"Live Photos"]){
        return @"实况";
    }
    return title;
}


+(void)SaveImageToPhotos:(UIImage *)image{
     [UIWindow ShowLoadNoAutoDismiss];
     NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
     PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
     PHAssetCollection *appCollection = nil;
    //判断自定义相册是否存在
     for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:appName]) {
             appCollection = collection;
             break;
        }
     }
    // 不存在创建幸ace
    if(appCollection == nil){
        NSError *error = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
            [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appName];
        } error:&error];
    }
    
    for (PHAssetCollection *collection in collections) {
       if ([collection.localizedTitle isEqualToString:appName]) {
            appCollection = collection;
            break;
       }
    }
    if(appCollection != nil){
        NSError *error2 = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
             PHObjectPlaceholder *placeholderForCreatedAsset = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset;
             PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:appCollection];
             [request insertAssets:@[placeholderForCreatedAsset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
         } error:&error2];
        if(error2 != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIWindow DissMissLoadWithBlock:^{
                    [UIWindow showTips:@"保存失败"];
                }];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIWindow DissMissLoadWithBlock:^{
                    [UIWindow showTips:@"保存成功"];
                }];
            });
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIWindow DissMissLoadWithBlock:^{
                [UIWindow showTips:@"保存失败"];
            }];
        });
    }
}


@end
