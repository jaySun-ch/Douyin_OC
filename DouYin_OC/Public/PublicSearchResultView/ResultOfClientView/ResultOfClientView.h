//
//  ResultOfClientView.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//

#import <UIKit/UIKit.h>

@interface ResultOfClientView : UIView
- (instancetype)initWithFrame:(CGRect)frame SearchText:(NSString *)SearchText;
-(void)ReloadDataWith:(NSString *)searchText;
@end

