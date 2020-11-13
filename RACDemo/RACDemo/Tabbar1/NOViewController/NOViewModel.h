//
//  NOViewModel.h
//  RACDemo
//
//  Created by lym on 2020/11/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NOViewModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray * dataArray;

- (void)loadNewData:(void (^)(void))callback;

- (void)loadMoreData:(void (^)(void))callback;

@end

NS_ASSUME_NONNULL_END
