//
//  VideoListCollectionView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//

#import "VideoListCollectionView.h"
#import "CustomCollectionLayout.h"

@interface VideoListCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionview;
@property (nonatomic, assign) CGFloat   itemWidth;
@property (nonatomic, assign) CGFloat   itemHeight;
@end

@implementation VideoListCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _playList = [NSMutableArray array];
        _itemWidth = (ScreenWidth - (CGFloat)(((NSInteger)(ScreenWidth)) % 3) ) / 3.0f - 1.0f;
        _itemHeight = _itemWidth * 1.35f;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 0;
        _collectionview = [[UICollectionView  alloc]initWithFrame:ScreenFrame collectionViewLayout:layout];
        _collectionview.backgroundColor = [UIColor clearColor];
        _collectionview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionview.alwaysBounceVertical = YES;
        _collectionview.showsVerticalScrollIndicator = NO;
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        _collectionview.scrollEnabled = NO;
        [_collectionview registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"collectionCell"];
        [self addSubview:_collectionview];
    }
    return self;
}

-(void)SetData:(NSMutableArray<NSString*>*) playList{
    self.playList = playList;
    [self.collectionview reloadData];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.playList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(_itemWidth,_itemHeight);
}


-(void)UpdateFrame:(CGFloat)hieght{
    self.collectionview.frame = CGRectMake(0, 0,self.frame.size.width,hieght);
}

@end
