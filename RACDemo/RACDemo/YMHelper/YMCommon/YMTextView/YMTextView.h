
/**
 *    自定义带placeHolder的文本输入框
 */

#import <UIKit/UIKit.h>

@interface YMTextView : UITextView

/** 占位符 */
@property (nonatomic, copy) NSString *placeholder;

/** 是否显示占位符 */
@property (nonatomic, assign) BOOL hidePlaceholder;

/** 是否显示占位符 */
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, assign) NSInteger maxTextNum;


@end
