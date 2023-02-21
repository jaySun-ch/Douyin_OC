//
//  HomePageController.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/14.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import "DefinGroup.pch"
#import "LoadMoreControl.h"
#import "NetWorkHelper.h"
#import "VideoPlayData.h"


typedef NS_ENUM(NSUInteger, AwemeType) {
    // 关注
    ConcernList        = 0,
    // 主页面
    CommentList    = 1,
    // 同城
    SameCityList = 2,
};

@interface MainPlayListViewController : UIViewController
@property (nonatomic,assign) NSString *ViewType;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex; // 当前所在页面的index

- (instancetype)init:(NSString*)ViewType;
//-(void)HasChangePage:(BOOL)iscurrentPage;
// 利用数据初始化
//-(instancetype)initWithVideoData:(NSMutableArray<VideoPlayData *> *)data;
@end


@interface MainPlayListViewControllerRoot : UINavigationController
- (instancetype)init:(NSString *)ViewType;
@end
