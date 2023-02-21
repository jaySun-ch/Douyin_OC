//
//  CustomImagePicker.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/5.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PickerImageType){
    PickerImageClientImage,
    PickerImageClientBackground,
};

@protocol CustomImagePickerDelegate <NSObject>

@required
-(void *)DidPickImage:(UIImage *)PickedImage;

@end

@interface CustomImagePicker : UIViewController
@property (nonatomic,assign) PickerImageType type;
@property (nonatomic,strong) id<CustomImagePickerDelegate> delegate;
+(void)SaveImageToPhotos:(UIImage *)image;
@end
