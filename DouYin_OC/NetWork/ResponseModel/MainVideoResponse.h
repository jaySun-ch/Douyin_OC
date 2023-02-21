//
//  MainVideoResponse.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/18.
//

#import "BaseResponse.h"
#import "VideoPlayData.h"

@interface MainVideoResponse : BaseResponse

@property (nonatomic,copy) NSArray<VideoPlayData *> <VideoPlayData> *data;

@end
