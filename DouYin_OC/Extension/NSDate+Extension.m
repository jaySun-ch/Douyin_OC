//
//  NSDate+Extension.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/7.
//

#import "NSDate+Extension.h"

@implementation NSDate(Extension)
-(NSString *)GetDate{
    NSDateFormatter  *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return  [formatter stringFromDate:self];
}

-(NSString *)GetYear{
    NSTimeInterval time = [self timeIntervalSinceNow];
    NSInteger year = -time / 31536000;
    return [NSString stringWithFormat:@"%ld岁",year];
}

-(NSString *)GetConcernTime{
    NSDateFormatter  *hourformatter = [[NSDateFormatter alloc] init];
    hourformatter.dateFormat = @"hh:mm";
    
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"MM-dd";
    
    NSDateFormatter  *yearformatter = [[NSDateFormatter alloc] init];
    yearformatter.dateFormat = @"yyyy-MM-dd";
    
    NSTimeInterval time = [self timeIntervalSinceNow];
    NSInteger year = -time / 31536000;
    NSInteger day = -time / 86400;
    NSInteger hour = -time / 3600;
//    NSLog(@"%f %ld %ld %ld NSTimeInterval",time,year,day,hour);
    
    if(hour <= 24){
        return [NSString stringWithFormat:@"%ld小时前",hour];
    }else{
        if(hour <= 24){
            return [NSString stringWithFormat:@"今天 %@",[hourformatter stringFromDate:self]];
        }else{
            if(day <= 2){
                return [NSString stringWithFormat:@"昨天 %@",[hourformatter stringFromDate:self]];
            }else{
                if(year < 1){
                    return [dateformatter stringFromDate:self];
                }else{
                    return [yearformatter stringFromDate:self];
                }
            }
        }
    }
}

@end
