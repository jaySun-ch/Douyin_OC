//
//  LikeCommentRequest.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/27.
//

#import "BaseRequest.h"

@interface LikeCommentRequest : BaseRequest
@property (nonatomic,copy) NSString *CommentId;
@property (nonatomic,copy) NSString *likeId;
@end
