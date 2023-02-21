//
//  VideoAccountDetialView.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2023/1/7.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionLayout.h"
#import "VideoAccountHeaderCell.h"
#import "VideoAccountMainCell.h"


@interface VideoAccountDetialView : UIViewController
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) UICollectionView *collectionview;
@end
