#!/bin/sh

# 通过使用命令 source encrypt.code 导出两个函数 code_encrypt 和 code_decrypt
# code_encrypt函数输出其参数
# code_decrypt函数将其参数作为密文解密得到明文并输出明文
# 你可以在encrypt.code中设置一个统一的Salt值，用于脚本加密
echo `code_decrypt OoCa2wUKpY0PeTbM`

# Shell脚本加密处理时，对code_encrypt函数引用会替换为code_decrypt的引用并加密内容，
# 而对code_decrypt函数的引用无需再处理，这两个函数的参数不能再包含变量替换。
# Shell脚本解密处理时，对code_decrypt函数引用会替换为code_encrypt的引用并解密内容，
# 而对code_encrypt函数的引用无需再处理(在完全解密时才会去除code_decrypt的命令替换)。

echo `code_decrypt "OoCa2wUKpY0PeTbM"`

# 通过上述方式，脚本内容无需解密即可运行，运行时再询问密码
# 当然，脚本也可以使用通常的部分加密方式
