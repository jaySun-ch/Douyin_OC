//
//  SearchBarCell.m
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//

#import "SearchBarCell.h"

@interface SearchBarCell()<UISearchBarDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation SearchBarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self initSearchBar];
    }
    return self;
}

#pragma 设置SearchBar
-(void)initSearchBar{
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.delegate  = self;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.searchTextField.delegate = self;
    self.searchBar.searchTextField.backgroundColor = [UIColor colorNamed:@"lightgray"];
    self.searchBar.placeholder = @"搜索用户名字/抖音号";
//    self.searchBar.backgroundColor = [UIColor colorNamed:@"lightgray"];
    [self.contentView addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(15);
        make.top.bottom.equalTo(self).inset(5);
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    for(UIView *subView in self.searchBar.subviews){
        for(UIView *subview2 in subView.subviews){
            // 这一层View
            for(UIView *subview3 in subview2.subviews){
                // 这一层分为Backgrounround 和 continaer
                if([subview3 isKindOfClass:UIButton.class]){
                    UIButton *button = (UIButton *)subview3;
                    [button setTitle:@"取消" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(CancleSearch) forControlEvents:UIControlEventTouchUpInside];
                }
            }
        }
    }
    return YES;
}

-(void)CancleSearch{
    [self.searchBar.searchTextField resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self CancleSearch];
    return YES;
}

@end
