//
//  NOViewModel.m
//  RACDemo
//
//  Created by lym on 2020/11/13.
//

#import "NOViewModel.h"

@interface NOViewModel ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end


@implementation NOViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)loadNewData:(void (^)(void))callback {
    self.page = 1;
    [self loadData:callback];
}

- (void)loadMoreData:(void (^)(void))callback {
    self.page += 1;
    [self loadData:callback];
}

- (void)loadData:(void (^)(void))callback {
        
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        for (int i = 0; i < 5; i++) {
            [self.dataArray addObject:@(i+1)];
        }
        callback();
    });

}

@end
