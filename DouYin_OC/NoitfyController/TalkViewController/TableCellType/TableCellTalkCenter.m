//
//  TableCellTalkCenter.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/11.
//

#import "TableCellTalkCenter.h"

@interface TableCellTalkCenter()
@property (nonatomic,strong) UILabel *centerLabel;
@end

@implementation TableCellTalkCenter

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.centerLabel = [[UILabel alloc] init];
        [self.centerLabel setFont:[UIFont systemFontOfSize:13.0]];
        [self.centerLabel setTintColor:[UIColor colorNamed:@"lightgray"]];
        [self addSubview:self.centerLabel];
        [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(15);
            make.center.equalTo(self);
        }];
    }
    return self;
}


-(void)SetCenterText:(NSString *)text{
    [self.centerLabel setText:text];
}
@end
