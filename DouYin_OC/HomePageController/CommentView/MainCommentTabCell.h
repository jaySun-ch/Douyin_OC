//
//  MainCommentTabCell.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/20.
//

#import <UIKit/UIKit.h>
#import "CommentData.h"
//

typedef void(^LikeCommentBlock)(void);
typedef void(^deleteCommentBlock)(void);
@interface MainCommentTabCell : UITableViewCell
@property (nonatomic,strong) CommentModel *data;
@property (nonatomic,strong) LikeCommentBlock likecomment;
@property (nonatomic,strong) deleteCommentBlock deLikeComment;
@property (nonatomic,strong) UIButton *likeButton;
@property (nonatomic,strong) UIButton *dislikeButton;
- (void)initWithData:(CommentModel *)data LeverUpName:(NSString *)LeverUpName;
-(void)SetMain:(BOOL)IsMain;
@end
