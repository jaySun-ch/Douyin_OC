//
//  TableCellOfText.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//
#import <UIKit/UIKit.h>

@interface TableCellTalkText : UITableViewCell
@property (nonatomic,strong) UILabel *StatLable;
-(void)initWithModel:(BOOL)isFriend Message:(NSString *)Message;
@end
