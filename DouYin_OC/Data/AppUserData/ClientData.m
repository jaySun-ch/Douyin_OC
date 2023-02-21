//
//  ClientData.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/28.
//

#import "ClientData.h"

@implementation ClientData

- (instancetype)initWithData:(UserData *)data IsSign:(BOOL)IsSign{
    if(self = [super init]){
        self.LastSignTime = [NSDate date];
        self.IsSign = IsSign;
        self.FriendList = data.FriendList;
        self.Likecount = data.Likecount;
        self.concernList = data.concernList;
        self.fansList = data.fansList;
        self._id = data._id;
        self.username = data.username;
        self.__v = data.__v;
        self.uid = data.uid;
        self.phoneNumber = data.phoneNumber;
        self.BackGroundImageUrl = data.BackGroundImageUrl;
        self.ClientImageUrl = data.ClientImageUrl;
        self.introduce = data.introduce;
        self.sex = data.sex;
        self.location = data.location;
        self.bornDate = data.bornDate;
        self.school = data.school;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:_LastSignTime forKey:@"LastSignTime"];
    [coder encodeBool:_IsSign forKey:@"IsSign"];
    [coder encodeObject:_FriendList forKey:@"FriendList"];
    [coder encodeObject:_concernList forKey:@"concernList"];
    [coder encodeObject:_fansList forKey:@"fansList"];
    [coder encodeObject:_uid forKey:@"uid"];
    [coder encodeInteger:_Likecount forKey:@"Likecount"];
    [coder encodeObject:__id forKey:@"_id"];
    [coder encodeObject:_username forKey:@"username"];
    [coder encodeObject:_CreateDate forKey:@"CreateDate"];
    [coder encodeInteger:___v forKey:@"__v"];
    [coder encodeObject:_phoneNumber forKey:@"phoneNumber"];
    [coder encodeObject:_BackGroundImageUrl forKey:@"BackGroundImageUrl"];
    [coder encodeObject:_ClientImageUrl forKey:@"ClientImageUrl"];
    [coder encodeObject:_introduce forKey:@"introduce"];
    [coder encodeObject:_sex forKey:@"sex"];
    [coder encodeObject:_location forKey:@"location"];
    [coder encodeObject:_bornDate forKey:@"bornDate"];
    [coder encodeObject:_school forKey:@"school"];
}


- (instancetype)initWithCoder:(NSCoder *)coder{
    if(self = [super init]){
        self.LastSignTime = [coder decodeObjectForKey:@"LastSignTime"];
        self.IsSign = [coder decodeBoolForKey:@"IsSign"];
        self.FriendList = [coder decodeObjectForKey:@"FriendList"];
        self.concernList = [coder decodeObjectForKey:@"concernList"];
        self.Likecount = [coder decodeIntegerForKey:@"Likecount"];
        self.fansList = [coder decodeObjectForKey:@"fansList"];
        self._id = [coder decodeObjectForKey:@"_id"];
        self.username = [coder decodeObjectForKey:@"username"];
        self.uid = [coder decodeObjectForKey:@"uid"];
        self.__v = [coder decodeIntegerForKey:@"__v"];
        self.phoneNumber = [coder decodeObjectForKey:@"phoneNumber"];
        self.BackGroundImageUrl = [coder decodeObjectForKey:@"BackGroundImageUrl"];
        self.ClientImageUrl = [coder decodeObjectForKey:@"ClientImageUrl"];
        self.introduce = [coder decodeObjectForKey:@"introduce"];
        self.sex = [coder decodeObjectForKey:@"sex"];
        self.location = [coder decodeObjectForKey:@"location"];
        self.bornDate = [coder decodeObjectForKey:@"bornDate"];
        self.school = [coder decodeObjectForKey:@"school"];
    }
    return self;
}

//-(void)SaveUser:(ClientData *)user{
//    [NSUserDefaults.standardUserDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user requiringSecureCoding:NO error:nil] forKey:@"clientData"];
//}

-(NSInteger)getCurrentProgress{
    NSInteger mainprogress = 20;
    if(![self.introduce isEqualToString:@""]){
        mainprogress += 20;
    }
    
    if(![self.sex isEqualToString:@""]){
        mainprogress += 10;
    }
    
    if(self.bornDate != nil){
        mainprogress += 10;
    }
    
    if(![self.location isEqualToString:@""]){
        mainprogress += 10;
    }
    
    if(![self.school isEqualToString:@""]){
        mainprogress += 10;
    }
    
    if(![self.ClientImageUrl isEqualToString:@"http://172.20.10.2:3000/public/images/uploadimage/img_find_default@2x.png"]){
        mainprogress += 10;
    }
    
    if(![self.BackGroundImageUrl isEqualToString:@"http://172.20.10.2:3000/public/images/uploadimage/splash_ad_x.png"]){
        mainprogress += 10;
    }
    return mainprogress;
}


+(void)SaveUserToServerWithRequest:(ChangeClientMessageRequest *)request responsedata:(void(^)(SuccessResponse * responsedata))responsedata{
    [NetWorkHelper getWithUrlPath:UpdateClientMessagePath request:request success:^(id data) {
        SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
        responsedata(response);
    } faliure:^(NSError *error) {
        responsedata(nil);
    }];
}

+(void)SaveUserDateToServerWithRequest:(ChangeClientDateRequest *)request responsedata:(void(^)(SuccessResponse * responsedata))responsedata{
    [NetWorkHelper getWithUrlPath:UpdateClientMessagePath request:request success:^(id data) {
        SuccessResponse *response = [[SuccessResponse alloc] initWithDictionary:data error:nil];
        responsedata(response);
    } faliure:^(NSError *error) {
        responsedata(nil);
    }];
}



//+(ClientData *)GetUser{
//    NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"clientData"];
//    if(userData){
//        ClientData *data = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
//        NSLog(@"%@ GetUserconcernList",data.concernList.lastObject.Id);
//        return data;
//    }
//    return nil;
//}

@end
