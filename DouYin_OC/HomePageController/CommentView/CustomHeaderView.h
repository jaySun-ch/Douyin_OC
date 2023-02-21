//
//  CustomHeaderView.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/27.
//

#import <UIKit/UIKit.h>
#import "CommentData.h"


typedef void(^LikeCommentBlock)(void);
typedef void(^deleteCommentBlock)(void);
@interface CustomHeaderView : UIView
@property (nonatomic,strong) CommentModel *commentdata;
@property (nonatomic,strong) UIImageView *clientImage;
@property (nonatomic,strong) UILabel *clientname;
@property (nonatomic,strong) UILabel *message;
@property (nonatomic,strong) UILabel *timeAndLocation;
@property (nonatomic,strong) UIButton *likeButton;
@property (nonatomic,strong) UIButton *dislikeButton;
@property (nonatomic,strong) LikeCommentBlock likecomment;
@property (nonatomic,strong) deleteCommentBlock deLikeComment;
- (instancetype)initWithData:(CommentModel *)data;
@end
