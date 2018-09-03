# BGSwiftModules

> Swift项目中一些抽离的方法。扩展，技巧

## UITextField输入时格式化限制示例gif
![image](https://github.com/zhbgitHub/SwiftModules/blob/master/UITextField.gif)


1. 自动布局 更改multiplier的值
2. String的扩展
    * 截取字符串[from,to)前闭后开
    * self如果包含Array里的某个元素,返回true,不包含返回false
    * 计算文字高度、Size
3. String关于本地沙盒子路径的扩展
```
    /****************************************************/
    /****       /---name.app                    ****/
    /****       |---Documents                   ****/
    /****       |             |- Caches         ****/
    /*** Home---|---Library---|                 ****/
    /****       |             |- Preferences    ****/
    /****       \---tmp                         ****/
    /****************************************************/
```
3. StringProtocol的扩展
    * 去除文字中的所有空格
    * 删除冗余的空格。eg:("hello   swift  ! ") --> ("hello swift!")
    * 删除头部和结尾的空格
    * 手机号格式: 13522589780 -->135 2258 9780
    * 金钱格式: 10000000 -->10,000,000.00
    
4. StringProtocol正则匹配的扩展
    * 字符串是 手机号码 吗?
    * 字符串是 身份证号码 吗?
    * 字符串是 车牌号码 吗?
    * 字符串是 LinkURl 吗? 只能验证(带有http:// 或 https://的)url
    * 字符串是 中文汉字 吗?
    * 字符串是 用户名称(2-11个汉字) 吗?
    * 字符串是 密码格式 吗? 英文字母或数字,6-20位长度
    * 字符串中是否包含 中文汉字?
    
5. UIColor的扩展
    * 十六进制颜色值，构建UIColor
    
6. UIImage的扩展
    * 根据颜色值生成一张图片
    
7. UILabel设置文字值，并设置行间距

8. UITableView滚动到最底部

9. UITextField输入时限制--格式化
    * 手机号，有无空格，且长度限制
    * 只能输入数字
    * 金钱格式
    * 银行卡格式
