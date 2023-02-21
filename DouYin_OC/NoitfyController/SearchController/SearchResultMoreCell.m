//
//  SearchResultMoreCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//

#import "SearchResultMoreCell.h"

@interface SearchResultMoreCell()
@property (nonatomic,strong) UIView *imageViewbackground;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UILabel *subLabel;
@property (nonatomic,strong) UIImageView *comeInView;
@end

@implementation SearchResultMoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.imageViewbackground = [[UIView alloc] init];
        self.imageViewbackground.backgroundColor = lightgraycolor;
        self.imageViewbackground.layer.cornerRadius = 25;
        [self addSubview:self.imageViewbackground];
        
        [self.imageView setImage:[UIImage systemImageNamed:@"magnifyingglass"]];
        [self.imageView setTintColor:[UIColor lightGrayColor]];
        [self.imageViewbackground addSubview:self.imageView];
        
        self.label = [[UILabel alloc] init];
        [self.label setText:@"搜索"];
        [self.label setFont:titleFont];
        [self addSubview:self.label];
        
        self.subLabel = [[UILabel alloc] init];
        [self.subLabel setText:@"视频、用户、音乐、话题、地点等"];
        [self.subLabel setTextColor:[UIColor darkGrayColor]];
        [self.subLabel setFont:subtitleFont];
        [self addSubview:self.subLabel];
        
        self.searchLabel = [[UILabel alloc] init];
        self.searchLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.searchLabel setFont:titleFont];
        [self.searchLabel setText:@"hhhh"];
        [self.searchLabel setTextColor:[UIColor systemPinkColor]];
        [self addSubview:self.searchLabel];
        
        self.comeInView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right"]];
        [self.comeInView setTintColor:[UIColor darkGrayColor]];
        [self addSubview:self.comeInView];
        
        [self.imageViewbackground mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).inset(15);
            make.centerY.equalTo(self);
            make.height.width.mas_equalTo(50);
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.imageViewbackground);
            make.width.height.mas_equalTo(20);
        }];
        
        [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageViewbackground.mas_right).inset(10);
            make.top.equalTo(self).inset(self.size.height / 2 - 5);
            make.height.mas_equalTo(20);
        }];
        
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageViewbackground.mas_right).inset(10);
            make.top.equalTo(self.label.mas_bottom).inset(3);
            make.height.mas_equalTo(20);
        }];
        
        [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.label.mas_right).inset(3);
            make.width.mas_equalTo(ScreenWidth / 2 + 30);
            make.centerY.equalTo(self.label);
            make.height.mas_equalTo(20);
        }];
        
        [self.comeInView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).inset(15);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}

@end
