//
//  ConcernListData.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/15.
//

#import "ConcernListData.h"


@implementation ConcernListData
- (instancetype)initWithId:(NSString *)ID CreateDate:(NSDate *)CreateDate{
    self = [super init];
    if(self){
        self.Id = ID;
        self.CreateDate = CreateDate;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:self.Id forKey:@"Id"];
    [coder encodeObject:self.CreateDate forKey:@"CreateDate"];
}

- (instancetype)initWithCoder:(NSCoder *)coder{
    if(self = [super init]){
        self.Id = [coder decodeObjectForKey:@"Id"];
        self.CreateDate = [coder decodeObjectForKey:@"CreateDate"];
    }
    return self;
}

@end
