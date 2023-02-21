//
//  VideoThumbnailView.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/19.
//

#import "VideoThumbnailView.h"

@interface VideoThumbnailView()
@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *division;

@end

@implementation VideoThumbnailView

- (instancetype)init{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img1"]];
        self.image.backgroundColor = [UIColor blackColor];
        self.image.contentMode  = UIViewContentModeScaleAspectFit;
        self.image.layer.cornerRadius = 5;
        self.image.clipsToBounds = YES;
        
        [self addSubview:self.image];
        
        self.currentTime = [[UILabel alloc] init];
        self.currentTime.textColor = [UIColor whiteColor];
        [self addSubview:self.currentTime];
        
        self.allTime = [[UILabel alloc] init];
        self.allTime.textColor = [UIColor lightGrayColor];
        [self addSubview:self.allTime];
        
        self.division = [[UILabel alloc] init];
        self.division.textColor = [UIColor lightGrayColor];
        [self.division setText:@"/"];
        [self addSubview:self.division];
        
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).inset(50);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(100);
        }];
        
        [self.division mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.image.mas_bottom).inset(15);
            make.centerX.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        
        [self.currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.image.mas_bottom).inset(15);
            make.right.mas_equalTo(self.division.mas_left).inset(20);
            make.height.mas_equalTo(20);
        }];
        
        [self.allTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.image.mas_bottom).inset(15);
            make.left.mas_equalTo(self.division.mas_right).inset(20);
            make.height.mas_equalTo(20);
        }];
    }
    return self;
}

-(void)SetImageWithimage:(UIImage *)image{
    [self.image setImage:image];
    if((image.size.height / image.size.width) > 1){
        // 如果当前图片的尺寸高度大于了100
        [self.image mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).inset(10);
            make.width.mas_equalTo(160 * image.size.width / image.size.height);
            make.height.mas_equalTo(160);
        }];
    }else{
        
    }
}


@end
