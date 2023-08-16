//
//  SPActionSheet.h
//  SPActionSheet
//
//  Created by GheniAblez on 2023/8/16.
//

#import <Foundation/Foundation.h>
#import <SPCollectionView/SPViewModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SPActionSheet : UIWindow

+(SPActionSheet *)create:(NSString *)title items:(NSArray<NSString *> *)items;
+(SPActionSheet *)create:(NSString *)title data:(NSArray<SPViewModel *> *)data;

@property (nonatomic, copy) void (^onItemClick)(SPViewModel *item,NSInteger index);

//show
-(void)show;

//dismiss
-(void)dismiss;

//autoHide
@property (nonatomic, assign) BOOL autoHide;

//maskHide
@property (nonatomic, assign) BOOL maskHide;

@end

NS_ASSUME_NONNULL_END
