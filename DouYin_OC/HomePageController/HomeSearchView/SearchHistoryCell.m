//
//  SearchHistoryCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/14.
//

#import "SearchHistoryCell.h"

@interface SearchHistoryCell()
@property (nonatomic,strong) UIImageView *cancleButton;
@end

@implementation SearchHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.imageView setImage:[UIImage systemImageNamed:@"clock"]];
        [self.imageView setTintColor:[UIColor grayColor]];
        [self.textLabel setFont:[UIFont systemFontOfSize:15.0]];
        self.cancleButton = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"xmark"]];
        [self.cancleButton setTintColor:[UIColor grayColor]];
        self.cancleButton.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.cancleButton];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(15);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(15);
        }];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).inset(5);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(20);
        }];
        
        [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(15);
            make.centerY.equalTo(self);
            make.width.height.mas_equalTo(15);
        }];
    }
    return self;
}

@end
