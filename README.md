# 在docker使用wine安装微信
项目中缺少W2KSP4_EN.EXE文件，需要重新下载(http://x3270.bgp.nu/download/specials/W2KSP4_EN.EXE)
## 安装x11
宿主机执行：
```sh
sudo apt install x11-xserver-utils
xhost + 
```
xhost + 允许所有用户可访问xserver(临时的，每次重启要执行)

## 构建一个带有wine的ubuntu镜像
	docker build -t quuee/wine-wechat:1.0 -f Dockerfile .

## 运行并进入容器
	docker run -it \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	--device=/dev/snd \
	--device=/dev/dri \
	--gpus all \
	--net=host \
	-e DISPLAY=$DISPLAY \
	-e NVIDIA_DRIVER_CAPABILITIES=all \
	-e NVIDIA_VISIBLE_DEVICES=0 \
	-e GDK_SCALE \
	-e GDK_DPI_SCALE \
	-e GID=${GID} \
	-e UID=${UID} \
	-e AUDIO_GID="$(getent group audio | cut -d: -f3)" \
	-e VIDEO_GID="$(getent group video | cut -d: -f3)" \
	--name wine-wechat \
	quuee/wine-wechat:1.0

## 在容器中下载微信
	wget https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe --no-check-certificate
## 安装微信后退出
	wine WeChatSetup.exe
## 输入框无法输入问题，最好在微信安装后执行
	winetricks riched20
## 中文无法输入
vim /etc/profile
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

source /etc/profile

## TODO
	没有声音
	不能发送图片
	不能截图
	不能打开订阅号
## 其他
	#启动容器
	docker start 容器名
	#进入容器
	docker exec -it 容器名 bash 
	#启动微信路径
	wine /root/.wine/drive_c/Program\ Files/Tencent/WeChat/WeChat.exe

	gpu报错，需要在主机上加入以下包
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
	curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
	curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
	sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
	sudo systemctl restart docker

	X Error of failed request:  BadValue
	apt install libnvidia-gl-515:i386






