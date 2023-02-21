//
//  SecondCommentRequest.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/24.
//

#import "BaseRequest.h"

@interface SecondCommentRequest : BaseRequest
@property (nonatomic,copy) NSString *MainCommentId; // 当前想要获取的主评论ID
@property (nonatomic,assign) NSInteger limit; // 获取限制
@property (nonatomic,assign)  NSInteger startLocation; // 从哪开始获取
@end
