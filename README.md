# iOS-JMKeyboardManager
监听键盘弹出, 输入框上移到可见高度<br>
可以指定输入框的任意父视图上移<br>
支持键盘Toolbar<br>

安装:<br>
CocoaPods: pod 'JMKeyboardManager'<br>

使用:<br>
  [JMKeyboardManager shareManager].enable = YES;<br>
  绑定输入框与上移的视图:<br>
  [JMKeyboardManager bindingTextField:textField moveView:self.view];<br>
