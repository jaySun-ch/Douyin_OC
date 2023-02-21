//
//  BaseModel.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/18.
//

#import "BaseModel.h"

@protocol VideoPlayData;

@interface VideoPlayData : BaseModel

@property (nonatomic,copy) NSString *_id;// 视频的id
@property (nonatomic,copy) NSString *desc;// 发表的主体内容
@property (nonatomic,copy) NSString *author_id;// 发表人的主体信息
@property (nonatomic,copy) NSString *video_url; // 视频内容的url
@property (nonatomic,copy) NSString *Music; // 当前视频的音频信息
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *ClientImageUrl;
@property (nonatomic,assign) NSInteger commentCount; // 当前视频的评论数
@property (nonatomic,assign) NSInteger sharecount; // 当前视频的分享数
@property (nonatomic,assign) NSInteger likecount; // 当前视频的喜欢
@property (nonatomic,assign) NSInteger starcount; // 当前视频的收藏
@property (nonatomic,assign) double videoRadio; // 视频的长宽比

@end
