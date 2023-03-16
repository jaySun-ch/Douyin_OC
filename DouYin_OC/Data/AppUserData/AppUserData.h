//
//  AppUserData.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/18.
//

#import <Foundation/Foundation.h>
#import "ClientData.h"

@interface AppUserData : NSObject<NSCoding>
/// the all of user has been login
@property (nonatomic,strong) NSArray<ClientData *> <ClientData> *AllUser;

/// get current user,which has login in
+(ClientData *)GetCurrenUser;

/**
 * save user with a new user
 * @param user the new user which will be added in user list
*/
+(void)SavCurrentUser:(ClientData *)user;

/**
 * Query whether the user is added to the list
 * @param user the user which is you want to query
*/
+(BOOL)AddNewUser:(ClientData *)user;

/**
 * get all of user you have been added
*/
+(AppUserData *)GetAllUser;

/**
 * get recent user
*/
+(ClientData *)GetNearstSignUser;

/**
 * login with recent user
*/
+(void)SignWithNearstUser;

/**
 * login with index
*/
+(void)SignWithUser:(NSInteger)newindex;

/**
 * remove user by index
 * @param index the user index
*/
+(void)RemoveUser:(NSInteger)index;

@end
