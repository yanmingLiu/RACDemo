//
//  YMImagePickerViewController.m
//  RACDemo
//
//  Created by lym on 2019/7/1.
//

#import "YMImagePickerViewController.h"
#import "YMImagePicker.h"


@interface YMImagePickerViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (nonatomic, strong) YMImagePicker * pick;

@end

@implementation YMImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.pick = [[YMImagePicker alloc] init];
    self.pick.type = 0;

    @weakify(self);
    self.pick.callback = ^(BOOL isVideo, NSString * _Nullable path, UIImage * _Nullable image) {
        @strongify(self);

        if (isVideo) {
            NSLog(@"Video path --- %@", path);
        }else {
            self.imageView.image = image;
        }
    };
}


- (IBAction)sgmt:(UISegmentedControl *)sender {

    self.pick.type = sender.selectedSegmentIndex;
}


- (IBAction)action:(id)sender {

    [self.pick actionFromController:self];
}

@end
