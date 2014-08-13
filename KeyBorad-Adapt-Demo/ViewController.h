//
//  ViewController.h
//  KeyBorad-Adapt-Demo
//
//  Created by Jakey on 14-8-13.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    float offY;                 //键盘遮挡的距离
    UIView *_currentView;       //当前编辑的输入框
    UIView *_wantMoveView;      //当前编辑的输入框的 某一个需要上移的view

}
@property (weak, nonatomic) IBOutlet UIView *mySubView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end
