//
//  LoadMoreCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/23.
//

#import "LoadMoreCell.h"

@interface LoadMoreCell()
@property (nonatomic,strong) UIView *lineview;
@property (nonatomic,strong) UIButton *label;
@property (nonatomic,strong) UIImageView *go;
@property (nonatomic,strong) CustomLoadView *loadmore;
@end


@implementation LoadMoreCell

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 65;
    frame.size.width -= 65;
    [super setFrame:frame];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
            self.lineview = [UIView new];
            self.lineview.backgroundColor = lightgraycolor;
            [self addSubview:self.lineview];
            self.label = [UIButton new];
            [self.label.titleLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightMedium]];
            [self.label setTitle:@"展开更多回复" forState:UIControlStateNormal];
            [self.label setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [self.label addTarget:self action:@selector(LoadMoreSecondComment) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.label];
            self.go = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chevron-downxiala"]];
            self.go.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:self.go];
    
            self.loadmore = [CustomLoadView new];
            self.loadmore.center = self.center;
            [self.loadmore setHidden:YES];
            [self addSubview:self.loadmore];
    
            [self.lineview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self);
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(1);
            }];
    
            [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self.lineview.mas_right).inset(8);
                make.height.mas_equalTo(20);
            }];
    
            [self.go mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self.label.mas_right);
                make.width.height.mas_equalTo(18);
            }];
    }
    return self;
}

-(void)LoadMoreSecondComment{
    if(_delegate){
        [_delegate LoadMoreComment];
    }
    [self.loadmore setHidden:NO];
    [self.go setHidden:YES];
    [self.label setHidden:YES];
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.loadmore setHidden:YES];
    [self.go setHidden:NO];
    [self.label setHidden:NO];
}

@end
