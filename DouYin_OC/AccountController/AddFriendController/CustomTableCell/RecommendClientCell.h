//
//  RecommendClientCell.h
//  DouYin_OC
//
//  Created by 孙志雄 on 2022/12/13.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,RecommendClientCellType){
    RecommendClientCellNormal,
    RecommendClientCellPoke,
    RecommendClientCellHasConcern,
    RecommendClientCellChat,
    RecommendClientCellConcern,
    RecommendClientCellSearchConcern
};

typedef NS_ENUM(NSInteger,RecommendButtonType){
    RecommendButtonConcern,
    RecommendButtonChat,
};



@protocol RecommendClientCellDelegate
-(void)DidTapWithTag:(NSInteger)tag index:(NSIndexPath *)index;
@end

@interface RecommendClientCell: UITableViewCell
@property (nonatomic,strong) NSIndexPath *MyIndex;
@property (nonatomic,strong) id<RecommendClientCellDelegate> delegate;
@property (nonatomic,strong) UIImageView *clientImage;
@property (nonatomic,strong) UILabel *clientName;
@property (nonatomic,strong) UILabel *subtitle;
@property (nonatomic,strong) UILabel *downLabel;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,strong) UIButton *concernButton;
@property (nonatomic,strong) UIButton *PokeButton;
@property (nonatomic,strong) UIButton *HasConcernButton;
@property (nonatomic,strong) UIButton *chatButton;
@property (nonatomic,strong) UIButton *SetButton;
-(void)SetCellWithType:(RecommendClientCellType)type;
@end
