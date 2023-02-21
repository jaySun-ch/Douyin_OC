//
//  SearchClientData.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//


#import "BaseModel.h"

@protocol SearchClientData;

@interface SearchClientData : BaseModel
@property (nonatomic,copy) NSString *_id; //用户的ID
@property (nonatomic,copy) NSString *username;// 用户的名称
@property (nonatomic,copy) NSString *uid;// 用户的抖音号
@property (nonatomic,copy) NSString *ClientImageUrl;// 头像url
@property (nonatomic,assign) NSInteger fanscount; // 粉丝数量
@property (nonatomic,assign) BOOL HasConcern;

@end
