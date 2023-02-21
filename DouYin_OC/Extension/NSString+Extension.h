//
//  NSString+Extension.h
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/17.
//

#import <UIKit/UIKit.h>

@interface NSString(Extension)

-(NSURL *)urlScheme:(NSString *)urlScheme;

- (CGSize)singleLineSizeWithText:(UIFont *)font;

- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font ;

- (CGFloat)heightwithFont:(UIFont *)Font withWidth:(CGFloat)width;

-(NSString *)GetConcernTime;
@end
