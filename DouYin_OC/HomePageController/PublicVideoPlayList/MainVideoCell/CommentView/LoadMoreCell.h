//
//  LoadMoreCell.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/23.
//

#import <UIKit/UIKit.h>


@protocol LoadMoreCellDelegate
@required
-(void)LoadMoreComment;

@end

@interface LoadMoreCell : UITableViewCell
@property (nonatomic,strong) id<LoadMoreCellDelegate>delegate;
@end


