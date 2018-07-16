//
//  JSHandler.h
//  NDL_Category
//
//  Created by dzcx on 2018/6/28.
//  Copyright © 2018年 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface JSHandler : NSObject

- (instancetype)initWithViewController:(UIViewController *)vc configuration:(WKWebViewConfiguration *)configuration;

//- (void)addScriptMessageName:(NSString *)messageName handler:(CommonNoParamNoReturnValueBlock)handlerBlock;

- (void)removeAllScriptMessageHandlers;

@end