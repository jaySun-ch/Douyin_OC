//
//  SuccessResponse.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/26.
//

#import "BaseResponse.h"
#import "CommentData.h"

@interface PostCommentResponse : BaseResponse
@property (nonatomic,copy) CommentModel *msg;
@end
