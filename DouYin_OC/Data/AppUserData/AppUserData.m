//
//  AppUserData.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/18.
//

#import "AppUserData.h"

@implementation AppUserData

- (instancetype)init{
    self = [super init];
    if(self){
        self.AllUser = [[NSArray array] copy];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder{
    if(self = [super init]){
       self.AllUser = [coder decodeObjectForKey:@"AllUser"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:_AllUser forKey:@"AllUser"];
}

+(AppUserData *)GetAllUser{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserData"];
    AppUserData *data = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return data;
}

+ (ClientData *)GetCurrenUser{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserData"];
    if(userData == nil){
        return nil;
    }
    AppUserData *data = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    ClientData *currentuser = [data.AllUser filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(ClientData *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        if(evaluatedObject.IsSign){
            return YES;
        }
        return NO;
    }]].firstObject;
    return currentuser;
}

+(void)SignWithNearstUser{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserData"];
    AppUserData *data = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if(data == nil){
        data = [[AppUserData alloc] init];
    }
    NSMutableArray<ClientData *><ClientData> *newarray = [[data.AllUser sortedArrayUsingComparator:^NSComparisonResult(ClientData *obj1,ClientData *obj2) {
        return [obj1.LastSignTime compare:obj2.LastSignTime];
    }] mutableCopy] ;
    
    ClientData *nearstuser = newarray.lastObject;
    nearstuser.IsSign = YES;
    nearstuser.LastSignTime = [NSDate date];
    NSUInteger index = [data.AllUser indexOfObjectPassingTest:^BOOL(ClientData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj._id isEqualToString:nearstuser._id]){
            return YES;
        }
        return NO;
    }];
    NSMutableArray<ClientData *><ClientData> *newarray2 = [data.AllUser mutableCopy];
    [newarray2 replaceObjectAtIndex:index withObject:nearstuser];
    data.AllUser = [newarray2 copy];
    [NSUserDefaults.standardUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:NO error:nil] forKey:@"AppUserData"];
}

+(void)RemoveUser:(NSInteger)index{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserData"];
    AppUserData *data = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    NSMutableArray<ClientData *><ClientData> *newarray2 = [data.AllUser mutableCopy];
    [newarray2 removeObjectAtIndex:index];
    data.AllUser = [newarray2 copy];
    [NSUserDefaults.standardUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:NO error:nil] forKey:@"AppUserData"];
}


+(void)SignWithUser:(NSInteger)newindex{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserData"];
    AppUserData *data = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    NSUInteger index = [data.AllUser indexOfObjectPassingTest:^BOOL(ClientData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.IsSign){
            return YES;
        }
        return NO;
    }];
    // index 可能位nil 因为可能存在没有登陆的情况
    NSMutableArray<ClientData *><ClientData> *newarray2 = [data.AllUser mutableCopy];
    if(index <= 3){
        ClientData *oldData = newarray2[index];
        oldData.IsSign = NO;
        [newarray2 replaceObjectAtIndex:index withObject:oldData];
    }
    
    ClientData *newdata = newarray2[newindex];
    newdata.IsSign = YES;
    newdata.LastSignTime = [NSDate date];
    [newarray2 replaceObjectAtIndex:newindex withObject:newdata];
    data.AllUser = [newarray2 copy];
    [NSUserDefaults.standardUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:NO error:nil] forKey:@"AppUserData"];
}

+(void)SavCurrentUser:(ClientData *)user{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserData"];
    AppUserData *data = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if(data == nil){
        data = [[AppUserData alloc] init];
    }
    NSUInteger index = [data.AllUser indexOfObjectPassingTest:^BOOL(ClientData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(obj.IsSign){
            return YES;
        }
        return NO;
    }];
    NSMutableArray<ClientData *><ClientData> *newarray = [data.AllUser mutableCopy];
    [newarray replaceObjectAtIndex:index withObject:user];
    data.AllUser = [newarray copy];
    [NSUserDefaults.standardUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:NO error:nil] forKey:@"AppUserData"];
}

+(ClientData *)GetNearstSignUser{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserData"];
    if(userData == nil){
        return nil;
    }
    AppUserData *data = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    NSMutableArray<ClientData *><ClientData> *newarray = [[data.AllUser sortedArrayUsingComparator:^NSComparisonResult(ClientData *obj1,ClientData *obj2) {
        return [obj1.LastSignTime compare:obj2.LastSignTime];
    }] mutableCopy];
    return newarray.lastObject;
}

+(BOOL)AddNewUser:(ClientData *)user{
    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUserData"];
    AppUserData *data = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    if(data == nil){
        data = [[AppUserData alloc] init];
    }
    NSMutableArray<ClientData *><ClientData> *newarray = [data.AllUser mutableCopy];
    NSUInteger index = [data.AllUser indexOfObjectPassingTest:^BOOL(ClientData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj._id isEqualToString:user._id] ){
            return YES;
        }
        return NO;
    }];
    
    if(index <= 3){
        // 如果已经有了的话 那么我们将直接让他变成当前的主用户
        [self SignWithUser:index];
        return NO;
    }else{
        for(NSInteger i = 0;i<newarray.count;i++){
            newarray[i].IsSign = NO;
        }
        [newarray addObject:user];
        data.AllUser = [newarray copy];
        [NSUserDefaults.standardUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:NO error:nil] forKey:@"AppUserData"];
        return YES;
    }
}

@end
