//
//  EditSchoolTablCell.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/8.
//


#import <UIKit/UIKit.h>

@interface EditSchoolTablCell: UITableViewCell
@property (nonatomic,strong) UILabel *message;
-(void)SetData:(NSString *)title message:(NSString *)message;
@end
