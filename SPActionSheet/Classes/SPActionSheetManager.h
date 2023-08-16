//
//  SPActionSheetManager.h
//  SPActionSheet
//
//  Created by GheniAblez on 2023/8/16.
//

#import <Foundation/Foundation.h>
#import "SPActionSheet.h"

NS_ASSUME_NONNULL_BEGIN

//define view type integer SPActionSheetDefaultItem
#define SPViewTypeActionSheetDefaultItem -5000

@interface SPActionSheetManager : NSObject

//sharedInstance
+(SPActionSheetManager *)sharedInstance;

//add actionSheet
-(void)addActionSheet:(SPActionSheet *)actionSheet key:(NSString *)key;

//remove actionSheet
-(void)removeActionSheet:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
