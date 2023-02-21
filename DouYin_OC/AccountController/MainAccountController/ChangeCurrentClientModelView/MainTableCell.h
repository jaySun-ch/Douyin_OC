//
//  MainTableCell.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/10.
//


#import <UIKit/UIKit.h>

@protocol MainTableCellDelegate
@required
-(void)DidTapOnRemoveButton:(NSIndexPath*)CellIndex;

@end

@interface  MainTableCell: UITableViewCell
@property (nonatomic,strong) id<MainTableCellDelegate>delegate;
@property (nonatomic,strong) NSIndexPath *index;
@property (nonatomic,strong) UIImageView *CheckButton;
@property (nonatomic,strong) UIImageView *RemoveButton;
-(void)SetData:(NSString *)imageurl name:(NSString *)name subtitle:(NSString *)subtitle iscurrent:(BOOL)iscurrent;
@end
