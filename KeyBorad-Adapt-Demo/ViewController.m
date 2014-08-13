//
//  ViewController.m
//  KeyBorad-Adapt-Demo
//
//  Created by Jakey on 14-8-13.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGRect keyBoradRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect currentEditRect = [_currentView.superview convertRect:_currentView.frame toView:nil];
    
    NSLog(@"currentEditRect = %@",NSStringFromCGRect(currentEditRect));
    NSLog(@"keyBoradRect = %@",NSStringFromCGRect(keyBoradRect));
    
#warning 需要注意的
    //(当前编辑的view的y起点 + view的高 - 键盘的Y值 = 偏移量),  ***横屏模式***下frame 坐标不会改变 x变成了y width变成了height
    offY = currentEditRect.origin.x + currentEditRect.size.width - keyBoradRect.origin.x;
    
    NSLog(@"offY = %f",offY);
    
    if (offY<0) {
        return;
    }
    
    [UIView animateWithDuration:.3f animations:^{
        //这块判断当前编辑的输入框 应该滚动哪个view是用superview来判断的,这里只是做个室里,也可以用tag或者其他方式指定滚动哪个view
        if (_currentView.superview == self.view) {
            self.view.bounds  = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+offY, self.view.bounds.size.width, self.view.bounds.size.height);
            _wantMoveView = self.view;

        }
        if (_currentView.superview == self.myScrollView || _currentView.superview.superview == self.myScrollView) {
            self.myScrollView.contentOffset = CGPointMake(self.myScrollView.contentOffset.x,self.myScrollView.contentOffset.y +offY);
            _wantMoveView = self.myScrollView;
            NSLog(@"scrollview.contentOffset up =%@",NSStringFromCGPoint(self.myScrollView.contentOffset));
        }
        if (_currentView.superview == self.mySubView  || _currentView.superview.superview == self.mySubView) {
            self.view.bounds  = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+offY, self.view.bounds.size.width, self.view.bounds.size.height);
            _wantMoveView = self.mySubView;

        }

        if (_currentView.superview.superview.superview.superview == self.myTableView) {
             self.myTableView.contentOffset = CGPointMake(self.myTableView.contentOffset.x,self.myTableView.contentOffset.y +offY);
            _wantMoveView = self.myTableView;

        }
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    if (offY<0) {
        return;
    }
    //这块判断当前编辑的输入框 应该滚动哪个view是用superview来判断的,这里只是做个室里,也可以用tag或者其他方式指定滚动哪个view

    if (_currentView.superview == self.view) {
        self.view.bounds  = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-offY, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    if (_currentView.superview == self.myScrollView || _currentView.superview.superview == self.myScrollView) {
        self.myScrollView.contentOffset = CGPointMake(self.myScrollView.contentOffset.x,self.myScrollView.contentOffset.y - offY);
        NSLog(@"scrollview.contentOffset down=%@",NSStringFromCGPoint(self.myScrollView.contentOffset));

    }
    if (_currentView.superview == self.mySubView  || _currentView.superview.superview == self.mySubView) {
        self.view.bounds  = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y-offY, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    
    if (_currentView.superview.superview.superview.superview == self.myTableView) {
        self.myTableView.contentOffset = CGPointMake(self.myTableView.contentOffset.x,self.myTableView.contentOffset.y - offY);

    }

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //把当前编辑的textView 赋值给全局变量_currentView
    _currentView = textView;
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //把当前编辑的textField 赋值给全局变量_currentView
    _currentView = textField;
    return YES;
}

#pragma mark -
#pragma -mark tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(0, 10, 200, 30)];
        text.placeholder = @"tableview的textfield";
        text.backgroundColor = [UIColor grayColor];
        text.delegate = self;
        [cell addSubview:text];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
