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
	--privileged \
	--device=/dev/snd \
	--device=/dev/dri \
	--gpus all \
	--net=host \
	--ipc=host \
	-v $PWD/dockerVol/wechat:/root \
	-e DISPLAY=unix$DISPLAY \
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

## 中文无法输入 fcitx 或者 ibus
```shell
vim /etc/profile

export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx

source /etc/profile
```

## 不能发送图片
	apt install libjpeg62:i386
	需要将图片拷贝到docker容器中
	或者挂载卷

## 启动相关命令
	#启动容器
	docker start 容器名
	#进入容器
	docker exec -it 容器名 bash 
	#在容器中启动微信路径
	wine /root/.wine/drive_c/Program\ Files/Tencent/WeChat/WeChat.exe
	#拷贝文件到容器
	docker cp 文件 [容器名或id]:/root/文件
	#更改挂载的文件夹权限
	sudo chmod 666 文件夹
## 创建图标启动
	wechat.desktop
	Exec=/自己的路径/wechatRunInDockerWithWine/wechat-run.sh
	Icon=/自己的路径/wechatRunInDockerWithWine/icon64_appwx_logo.png

	sudo mv wechat.desktop /usr/share/aplications


## TODO
	没有声音
	不能截图
	不能打开订阅号


## gpu报错，需要在主机上添加以下包 nvidia-container-runtime或者nvidia-container-toolkit
	以下是nvidia-container-toolkit安装
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
	curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
	curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
	sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
	sudo systemctl restart docker

	nvidia-container-runtime包安装
	curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | sudo apt-key add -
	distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
	curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
	sudo apt-get update && sudo apt-get install nvidia-container-runtime


	其他
	apt install libnvidia-gl-515:i386







