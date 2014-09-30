//
//  StickyFlow.m
//  StckyUICollectionHeader
//
//  Created by Praphin SP on 30/09/14.
//  Copyright (c) 2014 Praphin SP. All rights reserved.
//

#import "StickyFlow.h"

@implementation StickyFlow
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        [answer addObject:layoutAttributes];
        
    }];
    
    NSInteger numberOfSections = [cv numberOfSections];
    
    //CLS_LOG(@"For loop");
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            NSInteger section = layoutAttributes.indexPath.section;
            
            if (section < numberOfSections) {
                NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
                
                NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
                NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
                
                BOOL cellsExist;
                UICollectionViewLayoutAttributes *firstObjectAttrs;
                UICollectionViewLayoutAttributes *lastObjectAttrs;
                
                if (numberOfItemsInSection > 0) { // use cell data if items exist
                    cellsExist = YES;
                    firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                    lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
                } else { // else use the header and footer
                    cellsExist = NO;
                    firstObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            atIndexPath:firstObjectIndexPath];
                    lastObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                           atIndexPath:lastObjectIndexPath];
                    
                }
                
                CGFloat topHeaderHeight = (cellsExist) ? CGRectGetHeight(layoutAttributes.frame) : 0;
                CGFloat bottomHeaderHeight = CGRectGetHeight(layoutAttributes.frame);
                CGRect frameWithEdgeInsets = UIEdgeInsetsInsetRect(layoutAttributes.frame,
                                                                   cv.contentInset);
                
                CGPoint origin = frameWithEdgeInsets.origin;
                
                origin.y = MIN(
                               MAX(
                                   contentOffset.y + cv.contentInset.top,
                                   (CGRectGetMinY(firstObjectAttrs.frame) - topHeaderHeight)
                                   ),
                               (CGRectGetMaxY(lastObjectAttrs.frame) - bottomHeaderHeight)
                               );
                
                layoutAttributes.zIndex = 1024;
                layoutAttributes.frame = (CGRect){
                    .origin = origin,
                    .size = layoutAttributes.frame.size
                };
            }
        }
        
    }
    
    return answer;
    
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}

@end
