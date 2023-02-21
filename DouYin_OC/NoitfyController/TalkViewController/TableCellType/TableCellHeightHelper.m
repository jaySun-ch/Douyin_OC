//
//  TableCellHeightHelper.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//

#import "TableCellHeightHelper.h"

@interface TableCellHeightHelper()

@end

@implementation TableCellHeightHelper

+(CGFloat)GetCellHeightWithImageRadio:(CGFloat)ImageRadio{
    
    NSLog(@"%f GetCellHeightWithImageRadio",(150 * ImageRadio) + 20);
    if(ImageRadio >= 1){
        return (150 * ImageRadio) + 20;
    }else{
        return (200 * ImageRadio) + 20;
    }
}

+(CGFloat)GetCellHeightWithString:(NSString *)String{
    CGSize size = [String singleLineSizeWithText:[UIFont systemFontOfSize:16.0]];
    CGFloat Height = 0;
    if(size.width < ScreenWidth - 165){
        // 代表它是多行文本
        Height = 50;
    }else{
        Height = (([String heightForFont:[UIFont systemFontOfSize:16.0] width:ScreenWidth - 165] + 35 ) > 60) ? ([String heightForFont:[UIFont systemFontOfSize:16.0] width:ScreenWidth - 165] + 35) : 60;
    }
    NSLog(@"%f GetCellHeightWithString",Height);
    return Height;
}

@end
