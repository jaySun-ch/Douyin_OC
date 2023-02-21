//
//  CommentResponse.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/24.
//

#import "BaseResponse.h"
#import "CommentData.h"

@interface CommentDResponse : BaseResponse
@property (nonatomic,copy) NSArray<CommentModel *> <CommentModel> *data;
@end
