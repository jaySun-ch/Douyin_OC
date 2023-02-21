//
//  NSString+Extension.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/17.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CTFramesetter.h>
#import <CoreText/CTFont.h>
#import <CoreText/CTStringAttributes.h>

@implementation NSString(Extension)

- (NSURL *)urlScheme:(NSString *)urlScheme{
    NSURLComponents *components = [[NSURLComponents alloc]initWithURL:[NSURL URLWithString:self] resolvingAgainstBaseURL:NO];
    components.scheme = urlScheme;
    return [components URL];
}

- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    
    //kCTParagraphStyleSpecifierLineSpacingAdjustment 行对其 leading 是行的高度
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierAlignment, sizeof (CGFloat), &leading };
    
    //设置段落样式
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    
    //观察一共有多少个字
    CFRange textRange = CFRangeMake(0, self.length);
    
    // 创造字体
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    
    return size;
}

- (CGSize)singleLineSizeWithText:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

//-(CGSize)MutableLinesSizeWithAttributeText:(UIFont *)font (CGFloat)Width{
//    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
//    CGFloat leading = font.lineHeight - font.ascender + font.descender;
//}

-(NSString *)GetConcernTime{
    NSDateFormatter  *hourformatter = [[NSDateFormatter alloc] init];
    hourformatter.dateFormat = @"HH:mm";
    
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"MM-dd";
    
    NSDateFormatter  *yearformatter = [[NSDateFormatter alloc] init];
    yearformatter.dateFormat = @"yyyy-MM-dd";
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [df dateFromString:self];
//    NSLog(@"NSTimeInterval %@ %@",date,self);
    
    NSTimeInterval time = [date timeIntervalSinceNow];
    NSInteger year = -time / 31536000;
    NSInteger day = - time / 86400;
    NSInteger hour = - time / 3600;
    NSInteger min = - time / 60;
//    NSLog(@"NSTimeInterval %f",time);
//    NSLog(@"%ld %ld %ld NSTimeInterval",year,day,hour);
//    
    if(min < 60){
        return [NSString stringWithFormat:@"%ld分钟前",min];
    }else{
        if(hour <= 5){
            return [NSString stringWithFormat:@"%ld小时前",hour];
        }else{
            if(hour <= 24){
                return [NSString stringWithFormat:@"今天 %@",[hourformatter stringFromDate:date]];
            }else{
                if(day <= 2){
                    return [NSString stringWithFormat:@"昨天 %@",[hourformatter stringFromDate:date]];
                }else{
                    if(year < 1){
                        return [dateformatter stringFromDate:date];
                    }else{
                        return [yearformatter stringFromDate:date];
                    }
                }
            }
        }
    }

}
@end
