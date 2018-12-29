# iOS-JMKeyboardManager
监听键盘弹出, 输入框上移到可见高度  
可以指定输入框的任意父视图上移  
支持UITextField, UITextView, UITableView, inputAccessoryView  

安装:  
CocoaPods: pod 'JMKeyboardManager'  

使用:  
  [JMKeyboardManager shareManager].enable = YES;  
  绑定输入框与上移的视图:  
  [JMKeyboardManager bindingTextField:textField moveView:self.view];  
