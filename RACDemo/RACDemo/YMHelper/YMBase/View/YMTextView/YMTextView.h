
/**
 *    自定义带placeHolder的文本输入框
 */

#import <UIKit/UIKit.h>

@interface YMTextView : UITextView

/**
 Set textView's placeholder text. Default is nil.
 */
@property(nullable, nonatomic,copy) IBInspectable NSString    *placeholder;

/**
 To set textView's placeholder text color. Default is nil.
 */
@property(nullable, nonatomic,copy) IBInspectable UIColor    *placeholderTextColor;

@end
