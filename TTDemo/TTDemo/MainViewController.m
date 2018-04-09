//
//  MainViewController.m
//  TTDemo
//
//  Created by ai-nixs on 2018/4/8.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "MainViewController.h"
#import "YYText.h"
#import "RegexKitLite.h"
#import "TTFeedbackViewController.h"

#define NI_SCREEN_Width [UIScreen mainScreen].bounds.size.width
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"MainVC";
    
    YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, 100, NI_SCREEN_Width, 20)];
    
    label.text = @"欢迎使用探探, 在使用过程中有疑问请<a href=”tantanapp://feedback”>反馈</a>;   我的个人主页<a href=”https://nixinsheng.github.io/”>倪新生</a>";
    
    // url正则有很多种，不过这个已经够满足我的需求
    NSString *regex_http = @"<a href=(?:.*?)>(.*?)<\\/a>";
    // 文本内容
    NSString *labelText = [label.text copy];
    
    // [label.text captureComponentsMatchedByRegex:@""]; // 只会匹配第一个满足条件的
    
    // 这个方法可以匹配多个满足条件的，得到一个二维数组。内容中可能会有多个链接，所以要用这个
    NSArray *array_http = [labelText arrayOfCaptureComponentsMatchedByRegex:regex_http];
    if ([array_http count]) {
        // 先把html a标签都给去掉
        labelText = [labelText stringByReplacingOccurrencesOfString:@"<a href=(.*?)>"
                                                         withString:@""
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange (0, labelText.length)];
        labelText = [labelText stringByReplacingOccurrencesOfString:@"<\\/a>"
                                                         withString:@""
                                                            options:NSRegularExpressionSearch
                                                              range:NSMakeRange (0, labelText.length)];
        // 样式文本
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString: labelText];
        // 处理掉a标签后的内容，用来让UILabel去显示
        label.text = labelText;
        
        for (NSArray *array in array_http) {
            // 获得链接显示文字的range，用来设置下划线
            NSRange range = [labelText rangeOfString:array[1]];
            // 设置下划线样式
            [one yy_setTextUnderline:[YYTextDecoration decorationWithStyle:YYTextLineStyleSingle] range:range];
            // 设置链接文本字体颜色
            UIColor *textColor = [UIColor blueColor];
            [one yy_setColor:textColor range:range];
            /**
             *  标记文字点击事件
             */
            [one yy_setTextHighlightRange:range color:textColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                // 点击就是跳转超链接了，在这里我输出标记文字
                if ([[text.string substringWithRange:range] isEqual:@"反馈"]) {
                    [self NIXSNextVC];
                }else if ([[text.string substringWithRange:range] isEqual:@"倪新生"]){
                    NSLog(@"===%@===",[NSString stringWithFormat:@"%@, 字体大小: 30", [text.string substringWithRange:range]]);
                }
            }];
        }
        // 设置UILabel样式
        label.attributedText = one;
    }
    [self.view addSubview:label];
    
}

/**
 to:TTFeedbackViewController
 */
-(void)NIXSNextVC{
    TTFeedbackViewController* ttfbVC = [TTFeedbackViewController new];
    [self.navigationController pushViewController:ttfbVC animated:YES];
}
























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
