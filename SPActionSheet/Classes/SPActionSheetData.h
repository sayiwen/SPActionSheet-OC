//
//  SPActionSheetData.h
//  SPActionSheet
//
//  Created by GheniAblez on 2023/8/16.
//

#import <SPCollectionView/SPCollectionView.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPActionSheetData : SPViewModel

//title
@property (nonatomic, copy) NSString *title;

//last
@property (nonatomic, assign) BOOL last;

@end

NS_ASSUME_NONNULL_END
