//
//  CustomColletionImageCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/5.
//

#import "CustomColletionImageCell.h"

@interface CustomColletionImageCell()

@end

@implementation CustomColletionImageCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.clipsToBounds = YES;
        self.image = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        self.image.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.image];
//        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.contentView);
//        }];
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    NSLog(@"prepareForReuse");
}

- (void)layoutSubviews{
    [super layoutSubviews];
 
}


@end
