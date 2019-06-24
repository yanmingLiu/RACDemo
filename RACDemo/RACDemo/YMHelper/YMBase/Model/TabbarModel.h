//
//  TabbarModel.h
//  HJStoreS
//
//  Created by lym on 2018/12/25.
//  Copyright © 2018 lym. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabbarModel : NSObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * selectedImage;
@property (nonatomic, strong) NSString * viewController;

+ (NSArray *)tabbarItems;

// OperationManagerSuperController
// ManagerController

@end

NS_ASSUME_NONNULL_END
