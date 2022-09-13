# 在docker使用wine安装微信
项目中缺少W2KSP4_EN.EXE文件，需要重新下载
## 安装x11
宿主机执行：
```sh
sudo apt install x11-xserver-utils
xhost + 
```
xhost + 允许所有用户可访问xserver(临时的，每次重启要执行)

## 构建一个带有wine的ubuntu镜像
	docker build -t quuee/wine:1.0 -f Dockerfile . 

## 运行并进入容器
	docker run -it \
		-v /tmp/.x11-unix:/tmp/.x11-unix \
		-e DISPLAY=$DISPLAY \
		--user=${uid}:${gid} \
		--net=host \
		quuee/wine:1.0

## 在容器中下载微信
	wget https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe --no-check-certificate

## 安装微信
	wine WeChatSetup.exe 

## 输入框无法输入
	winetricks riched20 #最好启动登陆一次后再执行，输入框无法输入才能修复，但是中文还是不能输入

	vim /etc/profile 加入 
	export XMODIFITERS="@im=fcitx"
	export GTK_IM_MODULE="fcitx"
	export QT_IM_MODULE="fcitx"

	source /etc/profile
	# 重新启动微信，中文可以输入了。


## TODO
	每次重新启动容器 都要source /etc/profile 再重新登陆才能输入中文
	挂载 卷
	没有声音
	不能发送图片
## 其他
	#启动容器
	docker start 容器名
	#进入容器
	docker exec -it 容器名 bash 
	#启动微信路径
	wine /root/.wine/drive_c/Program\ Files/Tencent/WeChat/WeChat.exe


