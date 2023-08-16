//
//  SPActionSheetManager.m
//  SPActionSheet
//
//  Created by GheniAblez on 2023/8/16.
//

#import "SPActionSheetManager.h"
#import <SPCollectionView/SPCollectionView.h>
#import "SPActionSheetDefaultItem.h"



@interface SPActionSheetManager ()

//actionSheetMap
@property (nonatomic, strong) NSMutableDictionary *actionSheetMap;

@end

@implementation SPActionSheetManager

//sharedInstance
+(SPActionSheetManager *)sharedInstance{
    static SPActionSheetManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SPActionSheetManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [SPCollectionView registerItem:SPViewTypeActionSheetDefaultItem class:SPActionSheetDefaultItem.class];
        self.actionSheetMap = [NSMutableDictionary new];
    }
    return self;
}

- (void)addActionSheet:(SPActionSheet *)actionSheet key:(NSString *)key{
    [self.actionSheetMap setObject:actionSheet forKey:key];
    //log size and key
    NSLog(@"%@:%@",key,NSStringFromCGSize(actionSheet.frame.size));

}

- (void)removeActionSheet:(NSString *)key{
    [self.actionSheetMap removeObjectForKey:key];
}

@end
