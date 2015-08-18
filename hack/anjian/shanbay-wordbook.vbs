' 利用按键精灵创建扇贝网单词书
' author: pimgeek
'
'==========以下是按键精灵录制的内容==========
is_found = ""
' 定位到 wps 的标题栏并单击
FindPic 0,0,1920,1080,"p:\pim-wudi\prod\shanbay\wps-fill\wps.bmp",0.9,intX,intY
If intX > 0 And intY > 0 Then 
    MoveTo intX + 250, intY + 20
    LeftClick 1
    Delay 60
    MoveTo 1, 1
Else 
    MessageBox "未发现 WPS 主程序！"
End If
Delay 60
' 找到扇贝单词的输入框，并且让它获得焦点
FindPic 0,0,1920,1080,"P:\pim-wudi\prod\shanbay\wps-fill\input.bmp",1.0,intX,intY
If intX > 0 And intY > 0 Then 
    MoveTo intX + 90, intY + 20
    LeftClick 1
    Delay 60
    MoveTo 1, 1
Else 
    MessageBox "未发现扇贝单词输入框"
End If
Delay 60
' 切换回 wps
KeyDown "Alt", 1
Delay 60
KeyDown "Tab", 1
Delay 60
KeyUp "Tab", 1
Delay 15
KeyUp "Alt", 1
Delay 500
For 67
    ' 复制 wps 表格中当前元素
    KeyDown "Ctrl", 1
    Delay 60
    KeyDown "C", 1
    Delay 60
    KeyUp "C", 1
    Delay 500
    KeyUp "Ctrl", 1
    Delay 500
    ' 切换回扇贝单词输入框
    KeyDown "Alt", 1
    Delay 60
    KeyDown "Tab", 1
    Delay 60
    KeyUp "Tab", 1
    Delay 15
    KeyUp "Alt", 1
    Delay 500
    ' 在输入框中全选并且粘贴来自 wps 表格的单词
    KeyDown "Ctrl", 1
    Delay 60
    KeyDown "A", 1
    Delay 60
    KeyUp "A", 1
    Delay 15
    KeyUp "Ctrl", 1
    Delay 60
    KeyDown "Ctrl", 1
    Delay 60
    KeyDown "V", 1
    Delay 60
    KeyUp "V", 1
    Delay 15
    KeyUp "Ctrl", 1
    Delay 60
    ' 回车确认
    KeyPress "Enter", 1
    Delay 500
    FindPic 0,0,1920,1080,"P:\pim-wudi\prod\shanbay\wps-fill\error.bmp",1.0,intX,intY
    If intX > 0 And intY > 0 Then 
        is_found = "x"
        ' 切换回 wps 表格，让词义左侧的状态标记单元格获得焦点
        KeyDown "Alt", 1
        Delay 60
        KeyDown "Tab", 1
        Delay 60
        KeyUp "Tab", 1
        Delay 15
        KeyUp "Alt", 1
        Delay 500
        KeyPress "Right", 1
        Delay 60
        KeyPress is_found, 1
        Delay 60
        KeyPress "Enter", 1
        Delay 60
        KeyPress "Left", 1
    Else 
        is_found = "v"
        ' 开启词义输入模式，并且让词义输入框获得焦点（按下 Home 键避免持续向下滚屏）
        KeyPress "Tab", 2
        Delay 60
        KeyPress "Home", 1
        Delay 1200
        KeyPress "Enter", 1
        Delay 1000
        KeyPress "Tab", 19
        Delay 60
        ' 切换回 wps 表格，复制词义并且让词义左侧的状态标记单元格获得焦点
        KeyDown "Alt", 1
        Delay 60
        KeyDown "Tab", 1
        Delay 60
        KeyUp "Tab", 1
        Delay 15
        KeyUp "Alt", 1
        Delay 500
        KeyPress "Right", 2
        Delay 60
        KeyDown "Ctrl", 1
        Delay 60
        KeyDown "C", 1
        Delay 60
        KeyUp "C", 1
        Delay 15
        KeyUp "Ctrl", 1
        Delay 60
        KeyPress "Left", 1
        Delay 60
        ' 切换回扇贝网的词义输入框，全选并粘贴。
        KeyDown "Alt", 1
        Delay 60
        KeyDown "Tab", 1
        Delay 60
        KeyUp "Tab", 1
        Delay 15
        KeyUp "Alt", 1
        Delay 60
        KeyDown "Ctrl", 1
        Delay 60
        KeyDown "A", 1
        Delay 60
        KeyUp "A", 1
        Delay 15
        KeyUp "Ctrl", 1
        Delay 60
        KeyDown "Ctrl", 1
        Delay 60
        KeyDown "V", 1
        Delay 60
        KeyUp "V", 1
        Delay 15
        KeyUp "Ctrl", 1
        Delay 60
        ' 定位词义提交按钮，并点击提交。
        FindPic 0,0,1920,1080,"P:\pim-wudi\prod\shanbay\wps-fill\btn.bmp",0.9,intX,intY
        If intX > 0 And intY > 0 Then 
            MoveTo intX + 20, intY + 10
            Delay 60
            LeftClick 1
            Delay 60
            MoveTo 1, 1
        Else 
            MessageBox "词义提交按钮没有找到"
        End If
        ' 让扇贝单词输入框重新获得焦点
        KeyPress "Home", 1
        Delay 60
        KeyPress "Tab", 17
        Delay 60
        ' 切换回 wps 表格，标记当前单词的存储状态
        KeyDown "Alt", 1
        Delay 60
        KeyDown "Tab", 1
        Delay 60
        KeyUp "Tab", 1
        Delay 15
        KeyUp "Alt", 1
        Delay 60
        KeyPress is_found, 1
        Delay 60
        KeyPress "Enter", 1
        Delay 60
        KeyPress "Left", 1
        Delay 60
    End If
    Delay 60
Next
'==========以上是按键精灵录制的内容==========
