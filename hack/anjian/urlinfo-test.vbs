'==========以下是按键精灵录制的内容==========
For 69
    ' excel 向下一格
    Delay 600
    KeyPress "Down", 1
    Delay 100
    ' excel 复制一格
    KeyDown "Ctrl", 1
    Delay 60
    KeyPress  "C", 1
    Delay 60
    KeyUp "Ctrl", 1
    ' 切换到上一个窗口
    Delay 600
    KeyDown "Alt", 1
    Delay 60
    KeyPress "Tab",1
    Delay 60
    KeyUp "Alt", 1
    ' 切换到 urlinfo 输入框并粘贴，提交
    Delay 600
    KeyPress "Tab", 1
    Delay 100
    KeyDown "Ctrl", 1
    Delay 60
    KeyPress "A", 1
    Delay 60
    KeyUp "Ctrl", 1
    Delay 100
    KeyDown "Ctrl", 1
    Delay 60
    KeyPress "V", 1
    Delay 60
    KeyUp "Ctrl", 1
    Delay 600
    KeyPress "Tab", 1
    Delay 500
    KeyPress "Enter", 1
    Delay 4500
    ' 可选步骤：清除当前图片缓存
    KeyPress "Tab", 4
    Delay 500
    KeyPress "Enter", 1
    Delay 1000
    KeyPress "Enter", 1
    Delay 600
    KeyPress "Tab", 1
    Delay 500
    KeyDown "Ctrl", 1
    Delay 60
    KeyPress "V", 1
    Delay 60
    KeyUp "Ctrl", 1
    Delay 600
    KeyPress "Tab", 1
    Delay 500
    KeyPress "Enter", 1
    ' 切换到上一个窗口
    Delay 4500
    KeyDown "Alt", 1
    Delay 60
    KeyPress "Tab",1
    Delay 60
    KeyUp "Alt", 1
    Delay 300
    MoveTo 2,2
    FindPic 0,0,1920,1080,"P:\pim-wudi\_dev\mindpin\pinidea\ops\goods\mindpin-no-pic.bmp",1.0,intX,intY
    //以下是条件判断；如果返回的坐标大于0，那么就说明找到了。
    If intX > 0 And intY > 0 Then
        //在这里可以添加找到坐标后，需要做的处理。
        ' 确定图片显示有误
        Delay 60
        KeyPress "Right", 1
        Delay 60
        KeyPress "x", 1
        Delay 60
        KeyPress "Left", 1
    Else 
        Delay 300
        MoveTo 2,2
        FindPic 0,0,1920,1080,"P:\pim-wudi\_dev\mindpin\pinidea\ops\goods\mindpin-no-pic-icon.bmp",0.85,intX,intY
        //以下是条件判断；如果返回的坐标大于0，那么就说明找到了。
        If intX > 0 And intY > 0 Then
            //在这里可以添加找到坐标后，需要做的处理。
            ' 确定图片显示有误
            Delay 60
            KeyPress "Right", 1
            Delay 60
            KeyPress "x", 1
            Delay 60
            KeyPress "Left", 1
        Else 
            ' 确定图片显示正常
            Delay 60
            KeyPress "Right", 1
            Delay 60
            KeyPress "v", 1
            Delay 60
            KeyPress "Left", 1
        End If
    End If
Next 
'==========以上是按键精灵录制的内容==========
