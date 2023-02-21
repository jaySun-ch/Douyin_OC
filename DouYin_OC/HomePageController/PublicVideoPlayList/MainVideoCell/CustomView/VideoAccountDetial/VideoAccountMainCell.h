//
//  VideoAccountMainCell.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/1/7.
//

#import <UIKit/UIKit.h>

@protocol VideoAccountMainCellDelegate

@required
-(void)DidScrollToPageIndex:(NSInteger)index;

@end

@interface VideoAccountMainCell : UICollectionViewCell
@property (nonatomic,assign) NSInteger currentPageIndex;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyOwnVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyLoackVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyStarVideoList;
@property (nonatomic,strong) NSMutableArray<NSString*> *MyLikeVideoList;
@property (nonatomic,weak) id<VideoAccountMainCellDelegate> delegate;
-(void)ScrollToSelectPage:(NSInteger) PageIndex;
-(void)initWithData:(NSInteger)currentpageIndex MyOwnVideoList:(NSMutableArray<NSString*>*) MyOwnVideoList MyLoackVideoList:(NSMutableArray<NSString*>*) MyLoackVideoList MyStarVideoList:(NSMutableArray<NSString*>*) MyStarVideoList MyLikeVideoList:(NSMutableArray<NSString*>*) MyLikeVideoList;
@end
