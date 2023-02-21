//
//  CustomMainCollectionViewCell.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//

#import <UIKit/UIKit.h>

@protocol CustomMainCollectionViewCellDelegate

@required
-(void)DidScrollToPageIndex:(NSInteger)index;

@end

@interface CustomMainCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyOwnVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyLoackVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyStarVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyLikeVideoList;
@property (nonatomic,weak) id<CustomMainCollectionViewCellDelegate> delegate;
-(void)ScrollToSelectPage:(NSInteger) PageIndex;
-(void)initWithData:(NSInteger)currentpageIndex MyOwnVideoList:(NSMutableArray<NSString*>*) MyOwnVideoList MyLoackVideoList:(NSMutableArray<NSString*>*) MyLoackVideoList MyStarVideoList:(NSMutableArray<NSString*>*) MyStarVideoList MyLikeVideoList:(NSMutableArray<NSString*>*) MyLikeVideoList;
@end
