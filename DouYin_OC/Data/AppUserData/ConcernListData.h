//
//  ConcernListData.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/15.
//
#import <Foundation/Foundation.h>

@protocol ConcernListData;

@interface ConcernListData : BaseModel<NSCoding>
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSDate *CreateDate;
- (instancetype)initWithId:(NSString *)ID CreateDate:(NSDate *)CreateDate;
@end
