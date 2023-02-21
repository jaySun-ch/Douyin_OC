//
//  AppUserData.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/18.
//

#import <Foundation/Foundation.h>
#import "ClientData.h"

@interface AppUserData : NSObject<NSCoding>
@property (nonatomic,strong) NSArray<ClientData *> <ClientData> *AllUser;

+(ClientData *)GetCurrenUser; // 获取到当前的User
+(void)SavCurrentUser:(ClientData *)user; //保存当前的User
+(BOOL)AddNewUser:(ClientData *)user; //添加新的User
+(AppUserData *)GetAllUser;
+(ClientData *)GetNearstSignUser;
+(void)SignWithNearstUser;
+(void)SignWithUser:(NSInteger)newindex;
+(void)RemoveUser:(NSInteger)index;
@end
