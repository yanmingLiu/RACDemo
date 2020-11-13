//
//  NOView.h
//  RACDemo
//
//  Created by lym on 2020/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NOViewDelegate <NSObject>

- (NSInteger)numberOfSections;

- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (void)headerWithRefreshing;

- (void)footerWithRefreshing;

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface NOView : UIView

@property (nonatomic, weak) id<NOViewDelegate> delegate;

- (instancetype)initWithDelegate:(id<NOViewDelegate>)delegate;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithCoder:(NSCoder *)coder UNAVAILABLE_ATTRIBUTE;

- (void)reloadData:(NSArray *)datas;

- (void)beginHeaderRefreshing;

- (void)beginFooterRefreshing;

@end

NS_ASSUME_NONNULL_END
