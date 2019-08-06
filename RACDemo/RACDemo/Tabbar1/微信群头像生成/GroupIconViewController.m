//
//  GroupIconViewController.m
//  RACDemo
//
//  Created by lym on 2019/7/19.
//

#import "GroupIconViewController.h"
#import "UIImage+Group.h"


@interface GroupIconViewController ()

@end

@implementation GroupIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];



    // 2 - 9个显示，超过9的忽略

    NSArray *urls = @[
                      @"http://upload-images.jianshu.io/upload_images/3816723-e182f6da029b3e7d.jpg",
                      @"http://upload-images.jianshu.io/upload_images/3816723-023e66be11a2e94b.jpg",
                      @"http://upload-images.jianshu.io/upload_images/3816723-d7ece9dba73d4953.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/100",
                      @"http://upload-images.jianshu.io/upload_images/3816723-e08bf975aadbfdd4.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/100",
                      @"http://upload-images.jianshu.io/upload_images/3816723-13271b280c0e5fd4.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/100",

                      @"http://upload-images.jianshu.io/upload_images/3816723-023e66be11a2e94b.jpg",
                      @"http://upload-images.jianshu.io/upload_images/3816723-023e66be11a2e94b.jpg",
                      //                      @"http://upload-images.jianshu.io/upload_images/3816723-023e66be11a2e94b.jpg",
                      //                      @"http://upload-images.jianshu.io/upload_images/3816723-023e66be11a2e94b.jpg",

                      ];

    NSMutableArray * iconItemsArr = [NSMutableArray array];

    for (NSString *url in urls) {
        [iconItemsArr addObject:url];
    }

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 150, 100, 100)];
    [self.view addSubview:imageView];


    [UIImage groupIconWithUrls:iconItemsArr size:imageView.bounds.size padding:5 bgColor:[UIColor groupTableViewBackgroundColor] defaultImg:[UIImage new] callback:^(UIImage * _Nonnull image) {
        imageView.image = image;
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
