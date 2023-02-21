//
//  CustomAlertSheetView.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/7.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CustomAlertActionStyle) {
    CustomAlertActionStyleDefalut,
    CustomAlertActionStyleCancel,
};

typedef void(^buttonaction)(void);

@interface CustomAlertAction : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) buttonaction handle;
@property (nonatomic,assign) CustomAlertActionStyle style;
@property (nonatomic,assign) BOOL SetImageRight;
-(instancetype)initWithStyle:(NSString *)Title image:(UIImage*)image style:(CustomAlertActionStyle)style SetImageRight:(BOOL)SetImageRight handle:(buttonaction)handle;

@end


@interface CustomAlertSheetView : UIViewController
- (instancetype)initWithActionCount:(NSInteger)count;
-(void)addCustomActions:(CustomAlertAction *)action;

@end



