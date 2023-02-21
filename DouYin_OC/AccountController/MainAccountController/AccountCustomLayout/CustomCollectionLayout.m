//
//  CustomCollectionLayout.m
//  DouYin(OC)
//
//  Created by 孙志雄 on 2022/11/29.
//

#import "CustomCollectionLayout.h"


@implementation CustomCollectionLayout

- (instancetype)initWithTopHeight:(CGFloat)height{
    if(self = [super init]){
        self.topHeight = height;
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray <UICollectionViewLayoutAttributes *> *superarray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for(UICollectionViewLayoutAttributes *arritbute in [superarray mutableCopy]){
        if ([arritbute.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [superarray removeObject:arritbute];
        }
    }
    
    [superarray addObject:[super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
    
    for(UICollectionViewLayoutAttributes *attributes in superarray){
        if(attributes.indexPath.section == 0) {
            
            if ([attributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]){
                CGRect rect = attributes.frame;
                if(self.collectionView.contentOffset.y + self.topHeight - rect.size.height > rect.origin.y) {
                    rect.origin.y =  self.collectionView.contentOffset.y + self.topHeight - rect.size.height;
                    attributes.frame = rect;
                }
                attributes.zIndex = 5;
            }
        }
    }
    
    return [superarray copy];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
