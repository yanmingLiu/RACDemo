//
//  DateTableViewController.m
//  RACDemo
//
//  Created by lym on 2019/8/17.
//

#import "DateTableViewController.h"
#import "NSDate+YMDate.h"


@interface DateTableViewController ()

@property (nonatomic, strong) NSArray * texts;

@end

@implementation DateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _texts = @[@"时间->字符串",
               @"时间戳->字符串",
               @"两个时间的差值",
               @"倒计时",
               @"比较两个日期大小",
               @"发布时间",
               @"时间->时间戳",
               ];

    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _texts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *cellID = @"dfasdfasdf";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue2) reuseIdentifier:cellID];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
    }

    NSString *text = _texts[indexPath.row];
    cell.textLabel.text = text;

    NSString *s1 = @"2019-08-17 13:37:52";
    NSString *s2 = @"2019-08-17 13:38:52";
    NSString *tm = @"1566022757"; // = s1

    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = [NSDate currentDateString];
            break;

        case 1:
            cell.textLabel.text = [text stringByAppendingString:tm];
            cell.detailTextLabel.text = [NSDate ym_timestampToString:tm format:YMDateFormtyMdHms];
            break;

        case 2:
        {
        cell.textLabel.text = [[text stringByAppendingString:s1] stringByAppendingString:s2];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f", [NSDate ym_differenceDateStr1:s1 dateStr2:s2]];
            break;
        }

        case 3:
        {
        cell.textLabel.text = [[text stringByAppendingString:s1] stringByAppendingString:s2];
        cell.detailTextLabel.text = [NSDate ym_countDown:s1 endTime:s2];
        break;
        }

        case 4:
        {
        cell.textLabel.text = [[text stringByAppendingString:s1] stringByAppendingString:s2];
        NSComparisonResult re = [NSDate ym_compareDateStr1:s1 dateStr2:s2];

        switch (re) {
            case NSOrderedAscending:
                cell.detailTextLabel.text = @"<";
                break;
            case NSOrderedSame:
                cell.detailTextLabel.text = @"=";
                break;
            case NSOrderedDescending:
                cell.detailTextLabel.text = @">";
                break;
        }
        break;
        }
        case 5:
        {
        cell.detailTextLabel.text = [NSDate ym_pushTime:s1];
        break;
        }

        case 6:
        {
        NSDate *d = [NSDate ym_stringToDate:s1];

        cell.detailTextLabel.text = [NSDate ym_dateToTimestamp:d format:YMDateFormtyMdHms];
        break;
        }
        default:
            break;
    }


    return cell;
}


- (NSString *)timestampTransformToString:(NSString *)timestamp format:(NSString *)format {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone systemTimeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}


@end
