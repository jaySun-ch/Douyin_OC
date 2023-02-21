//
//  EditAccountHeaderCell.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/4.
//

#import <UIKit/UIKit.h>

static const NSInteger HeaderClientBackground = 0x01;
static const NSInteger HeaderClientImage = 0x02;

@protocol EditAccountHeaderDelegate

- (void)onUserActionTap:(NSInteger)tag;

@end


@interface EditAccountHeaderCell: UITableViewCell
@property (nonatomic,strong) id<EditAccountHeaderDelegate> delegate;
-(void)initSubView;
-(void)ScaleBackGroundImage:(CGFloat) offsetY;
-(void)OffsetBackGroundImage;
-(void)UpdateProgress;
@end
