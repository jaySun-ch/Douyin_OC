//
//  SearchClientResponse.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//

#import "BaseResponse.h"
#import "SearchClientData.h"
@interface SearchClientResponse:BaseResponse
@property (nonatomic,strong) NSArray<SearchClientData *> <SearchClientData> *msg;
@end
