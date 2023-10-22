# code_encrypt

用于创建公开的加密代码仓库，只对仓库中代码文件的部分进行自定义加密，\
采取chacha20加密算法。支持三种加密类型：文本加密、二进制文件加密、Shell脚本加密。

使用的加密命令为：

	openssl enc -chacha20 -pbkdf2 -iter 10000 -md sha256 -S $Salt

需安装openssl(v1.1.1+)，以上命令用pbkdf2算法以密码生成密钥并用chacha20加密。

命令详见：[openssl-enc](https://www.openssl.org/docs/man3.0/man1/openssl-enc.html),
[wiki PBKDF2](https://zh.wikipedia.org/wiki/PBKDF2).

加密处理也可作用于文件夹，这样会对此文件夹内所有文件和目录进行处理。

需加密的文件要在
{{[`"encrypt.code"`](encrypt.code)}}
脚本中定义，写明之後，才能执行命令以用之：

1. `. encrypt.code` 包含命令。<br>
  如果拉取了使用Shell脚本加密的仓库，执行此命令後，那些要加密的脚本才能正常运行。
2. `. encrypt.code e` 加密仓库。<br>
  执行此命令之前当前仓库应该未加密，此命令会按配置加密仓库内容，每个文件使用不同\
  Salt标识符。
3. `. encrypt.code d` 解密仓库。<br>
  执行此命令之前当前仓库应该已加密，此命令会解密仓库内容，对文本部分解密不会去除\
  Salt标识符。
4. `. encrypt.code D` 完全解密。<br>
  先对仓库进行解密操作。然後对文本部分解密去除Salt标识符，对Shell脚本解密去除\
  `code_encrypt`命令替换，以使仓库完全不包含加密部分和标识。
5. `. encrypt.code R` 恢复备份。<br>
  先按加密文件列表清除文件，然後解压备份文件以恢复备份内容。进行完全解密操作後，\
  不能直接执行加密仓库操作，需要先执行此操作以恢复加密标识。

判断当前仓库是否加密的标准是，当前工作目录下是否有`".encrypt.pass"`文件，若存在则\
表示当前仓库应该是未加密状态，若不存在则表示当前仓库已加密(加密完成会删去该文件)。

本仓库的密码是：pass

你可以自行测试本仓库的功能，也可以复制`"encrypt.code"`文件到其他仓库以用之。

`"encrypt.code"`文件以bash环境运行，其依赖命令有：`openssl`, `awk`, `sed`, `od`,
`wc`, `dirname`, `basename`, `sort`, `dd`, `cat`, `xargs`, `find`, `sponge`,
`tar`, `gzip`, `printf`.

Debian系统执行以下命令以安装依赖即可：

	sudo apt install openssl gawk sed tar gzip findutils coreutils moreutils

## 文本加密

对于文件中的换行符(LF和CR)不进行加密，其他部分按要求加密。

文本加密有两种方式，整体加密和部分加密。文本加密都会将密文再以Base64编码。

文本加密不支持原始後缀为`".enc"`的文件，因为这与整体加密的定义冲突。

### 整体加密

文件加密之前不带`".enc"`後缀，加密之後其会加上`".enc"`後缀而成为多後缀文件。\
文件解密会自动去除`".enc"`後缀。

需加密的文件要在`"encrypt.code"`脚本中定义，赋值给`code_encrypt_file`数组变量\
即可。对于整体加密应该写加密後的文件路径，也就是原始路径加上`".enc"`後缀。

整体加密的例子详见以下文件：
{{[`test/test_dir.enc`](test/test_dir.enc)}}

### 部分加密

文件部分加密不会改变文件名，在`"encrypt.code"`脚本中将需加密文件的文件名赋值给\
`code_encrypt_file`数组变量即可。部分加密只支持兼容ASCII的文本编码。

部分加密的例子详见以下文件：
{{[`test/part_encrypt.txt`](test/part_encrypt.txt)}}

## 二进制文件加密

二进制文件加密，在`"encrypt.code"`脚本中将需加密文件的文件名赋值给\
`bin_encrypt_file`数组变量即可。加密後存储的仍然是二进制内容而不以Base64编码。

二进制文件加密的例子详见以下文件：
{{[`test/bin_encrypt.txt`](test/bin_encrypt.txt)}}

## Shell脚本加密

Shell脚本加密，此方式专用于Shell脚本，加密後的脚本仍然可直接运行(需要运行\
`". encrypt.code"`命令才能正确执行)，此方式不影响脚本可读性。

在`"encrypt.code"`脚本中将需加密文件的文件名赋值给`sh_encrypt_file`数组变量即可。

因为Shell脚本用于类Unix系统的配置，有些配置项是十分重要的隐私数据而不应公开，\
但是Shell脚本本身是可以公开的，这一矛盾也促使我开发了这一功能。

拉取了使用Shell脚本加密的仓库，首先执行`". encrypt.code"`命令，然後就能正常运行\
那些加密的脚本。即使你不知道仓库密码，也能通过输入空密码的方式自定义解密後的内容。

Shell脚本加密的例子详见以下文件：
{{[`test/script_encrypt.sh`](test/script_encrypt.sh)}}

Shell脚本的编码只能是UTF8，否则会处理异常。
