//
//  SPCollectionView.m
//  SPCollectionView
//
//  Created by GheniAblez on 2023/8/14.
//

#import "SPCollectionView.h"
#import "SPBaseItem.h"
#import <MJRefresh/MJRefresh.h>

static NSMutableDictionary *itemDictioanry;

@interface SPCollectionView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic,strong) NSMutableArray<SPViewModel *> *dataList;

@end

@implementation SPCollectionView

//注册
+ (void)registerItem:(NSInteger)viewType class:(Class)itemClass{
    if(itemDictioanry == nil){
        itemDictioanry = [[NSMutableDictionary alloc]init];
    }
    [itemDictioanry setObject:itemClass forKey:[NSString stringWithFormat:@"%ld",(long)viewType]];
}


//创建
+ (SPCollectionView *)create:(id)delegate{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    SPCollectionView *collectionView = [[SPCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView = collectionView;
    collectionView.delegate = collectionView;
    collectionView.dataSource = collectionView;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.userDelegate = delegate;
    collectionView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    return collectionView;
}


//点击回掉
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.userDelegate != nil){
        if([self.userDelegate respondsToSelector:@selector(onItemClick:model:index:)]){
            [self.userDelegate onItemClick:self model:self.dataList[indexPath.row] index:indexPath.row];
        }
    }
}


//确定大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    SPViewModel *model = self.dataList[indexPath.row];
    CGFloat width;
    if(model.viewSpan != 0){
        width = (self.frame.size.width - 0.001) / (60.f / model.viewSpan);
    }else{
        width = self.frame.size.width;
    }
    Class itemClass = [itemDictioanry objectForKey:[NSString stringWithFormat:@"%ld",(long)model.viewType]];
    if([itemClass respondsToSelector:@selector(itemHeight:)]){
        return CGSizeMake(width,[itemClass itemHeight:width]);
    }
    return CGSizeMake(width, 100);
}

//确定数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataList.count;
}


//确定cell
- (SPBaseItem *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SPViewModel *model = self.dataList[(NSUInteger) indexPath.row];
    SPBaseItem *item = [self dequeueReusableCellWithReuseIdentifier:[@"viewType" stringByAppendingFormat:@"%ld",(long)model.viewType] forIndexPath:indexPath];
    item.data = self.dataList[(NSUInteger) indexPath.row];
    item.userDelegate = self.userDelegate;
    return item;
}


//数据源
- (void)setData:(NSArray<SPViewModel *> *)data{
    _dataList = [[NSMutableArray alloc]initWithArray:data];
    for (SPViewModel *model in data) {
        [self registerClass:[itemDictioanry objectForKey:[NSString stringWithFormat:@"%ld",(long)model.viewType]] forCellWithReuseIdentifier:[@"viewType" stringByAppendingFormat:@"%ld",(long)model.viewType]];
    }
    [self reloadData];
}


//添加数据源
- (void)addData:(NSArray<SPViewModel *> *)data{
    [_dataList addObjectsFromArray:data];
    for (SPViewModel *model in data) {
        [self registerClass:[itemDictioanry objectForKey:[NSString stringWithFormat:@"%ld",(long)model.viewType]] forCellWithReuseIdentifier:[@"viewType" stringByAppendingFormat:@"%ld",(long)model.viewType]];
    }
    [self reloadData];
}

//刷新
- (void)enableRefresh{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if(self.userDelegate != nil){
            if([self.userDelegate respondsToSelector:@selector(onRefresh)]){
                [self.userDelegate onRefresh];
            }
        }
    }];
}
- (void)enableRefresh:(MJRefreshHeader *)header{
    self.mj_header = header;
}

//停止刷新
- (void)stopRefresh{
    [self.mj_header endRefreshing];
}


//停止加载更多
- (void)stopLoadMore{
    [self.mj_footer endRefreshing];
}

//加载更多
- (void)enableLoadMore{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if(self.userDelegate != nil){
            if([self.userDelegate respondsToSelector:@selector(onLoadMore)]){
                [self.userDelegate onLoadMore];
            }
        }
    }];
}
- (void)enableLoadMore:(MJRefreshFooter *)footer{
    self.mj_footer = footer;
}

@end
