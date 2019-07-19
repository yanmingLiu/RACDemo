//
//  RACCommandController.m
//  RACDemo
//
//  Created by lym on 2018/1/30.
//

#import "RACCommandController.h"
#import "ReactiveObjC.h"
#import "CViewModel.h"

@interface RACCommandController ()
/** viewModel */
@property (nonatomic, strong) CViewModel * viewModel; 
@end

@implementation RACCommandController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _viewModel = [[CViewModel alloc] init];
    
    /*
     使用步骤：
     // 1.创建命令： _viewModel
     // 2.创建信号,用来传递数据： _viewModel return
     // 3.强引用命令，否则接收不到数据： VC
     // 4.执行命令：execute  VC
     // 5.订阅RACCommand中的信号：没有执行命令execute，一定订阅不到；先订阅还是先执行都没有关系，但是一定要执行
        属性 executionSignals
     */
    
    
    [_viewModel.concatCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        // 执行命令 订阅一起
        [[_viewModel.switchToLatestCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
    }
    else if (indexPath.row == 1) { 
        
        // 先执行命令 再订阅
        [_viewModel.executeCommand execute:@1];
        [_viewModel.executeCommand.executionSignals subscribeNext:^(id  _Nullable x) {
            [x subscribeNext:^(id  _Nullable x) {
                NSLog(@"%@",x);
            }];
        }];
    }
    else if (indexPath.row == 2) {
      
        // 先执行命令 再订阅 监听过程
        [_viewModel.executingCommand execute:nil];
        
        // 监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
        [[_viewModel.executingCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
            NSLog(@"%@",x); 
            
            if ([x boolValue] == YES) {
                // 正在执行
                NSLog(@"正在执行");
                
            }else{
                // 执行完成
                NSLog(@"执行完成");
            }
        }];
    }
    else if (indexPath.row == 3) { 
        // 先执行命令 再订阅 switchToLatest:直接拿到RACCommand中的信号
        [_viewModel.executeCommand execute:@1];
        [_viewModel.executeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
    }
    else if (indexPath.row == 4) { 
        
        RACSignal *s1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:[NSString stringWithFormat:@"请求s1"]];
                [subscriber sendCompleted];
            });
            return nil;
        }];
        RACSignal *s2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:[NSString stringWithFormat:@"请求s2"]];
                [subscriber sendCompleted];
            });
            return nil;
        }];
        
        [[s1 concat:s2] subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
    }
    else if (indexPath.row == 5) {
        
        
        [_viewModel.concatCommand execute:nil];
    }
}



@end
