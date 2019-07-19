//
//  CViewModel.h
//  RACDemo
//
//  Created by lym on 2018/1/30.
//

#import <Foundation/Foundation.h>

@interface CViewModel : NSObject

@property (nonatomic, strong) RACCommand *executeCommand;

@property (nonatomic, strong) RACCommand *executingCommand;

@property (nonatomic, strong) RACCommand *switchToLatestCommand;

@property (nonatomic, strong) RACCommand *concatCommand;

@end
