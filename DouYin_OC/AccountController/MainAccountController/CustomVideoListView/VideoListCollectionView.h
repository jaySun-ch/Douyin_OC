//
//  VideoListCollectionView.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//

#import <UIKit/UIKit.h>

#import "CustomCollectionView.h"

@interface VideoListCollectionView : UIView

@property (nonatomic,strong) NSMutableArray<NSString*> *playList;
-(void)SetData:(NSMutableArray<NSString*>*) playList;
-(void)UpdateFrame:(CGFloat)hieght;
@end
