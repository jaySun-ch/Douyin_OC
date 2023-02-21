//
//  CommentData.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/20.
//

#import "BaseModel.h"

@protocol CommentModel;

@interface CommentModel : BaseModel
@property (nonatomic,copy) NSString *CommentName;//
@property (nonatomic,copy) NSDate *CreateDate;//
@property (nonatomic,assign) BOOL IsMainComment;
@property (nonatomic,copy) NSString * LeverUpCommentId ;
@property (nonatomic,strong) NSMutableArray *Like; //
@property (nonatomic,copy) NSString * Message;//
@property (nonatomic,copy) NSString * VideoId;
@property (nonatomic,copy) NSString * WasCommentName; //
@property (nonatomic,assign) NSInteger __v;
@property (nonatomic,copy) NSString *_id;//
@property (nonatomic,assign) NSInteger LeverdownCommentCount;
@property (nonatomic,copy) NSString *loaction;//
@end

@interface MainComment : CommentModel
@end

@interface SecondComment : CommentModel
@end


@interface CommentData : BaseModel
// MainComment* 是Key
// 二级评论为多个 NSMutableArray<SecondComment*> *
@property (nonatomic,strong) NSMutableDictionary<CommentModel*,NSMutableArray<CommentModel*> *> *data;
@property (nonatomic,assign) NSInteger allcount;
@end
