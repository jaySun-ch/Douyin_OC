//
//  SearchClientRequest.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//

#import "BaseRequest.h"

@interface SearchClientRequest : BaseRequest
@property (nonatomic,strong) NSString *searchText;
@property (nonatomic,strong) NSString *MyID;
@end
