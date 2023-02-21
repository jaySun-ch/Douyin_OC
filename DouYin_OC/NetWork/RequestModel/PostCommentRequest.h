//
//  PostCommentRequest.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/26.
//

#import "BaseRequest.h"

@interface PostCommentRequest : BaseRequest
@property (nonatomic,copy) NSString *VideoId;
@property (nonatomic,copy) NSString *CommentName;
@property (nonatomic,copy) NSString *WasCommentName;
@property (nonatomic,copy) NSString *Message;
@property (nonatomic,copy) NSString *loaction;
@property (nonatomic,assign) BOOL IsMainComment;
@property (nonatomic,copy) NSString *LeverUpCommentId;
@end

