//
//  CustomCollectionView.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//

#import "CustomCollectionView.h"

@interface CustomCollectionCell()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton  *favoriteNum;
@end

@implementation CustomCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage new]];
        [self.imageView setBackgroundColor:[UIColor blackColor]];
        self.favoriteNum = [[UIButton alloc] init];
        [self addSubview:self.imageView];
        [self addSubview:self.favoriteNum];
        [self.favoriteNum setImage:[UIImage imageNamed:@"icon_home_likenum"] forState:UIControlStateNormal];
        [self.favoriteNum setTitle:@"5.0万" forState:UIControlStateNormal];
        [_favoriteNum setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.favoriteNum.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.favoriteNum setTintColor:[UIColor whiteColor]];
        [self.favoriteNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.favoriteNum setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
        [self.favoriteNum setImageEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(self);
        }];
        
        [self.favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).inset(5);
            make.leading.equalTo(self).inset(10);
            make.width.mas_equalTo(self.frame.size.width);
        }];
    }
    return self;
}

@end
