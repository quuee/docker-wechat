
### 构建docker镜像
```shell
docker build -f docker-wechat -f docker-wechat:v1.0 .
```

### 主机执行：
x11-xserver-utils，让docker运行的系统拥有gui的大概有两个，一个是X11server 、一个是novnc。
```shell
sudo apt install x11-xserver-utils
xhost +
```
xhost + 允许所有用户可访问xserver(临时的，每次重启要执行)

### 环境参数
```
-v /tmp/.X11-unix:/tmp/.X11-unix # 共享本地unix端口
-e DISPLAY=$DISPLAY 或 -e DISPLAY=unix$DISPLAY #修改环境变量DISPLAY
-e GDK_SCALE  -e GDK_DPI_SCALE # 显示相关的参数
--device=/dev/snd --device=/dev/dri # 共享主机硬件设备
--gpus all # 使用gpu
--net=host # 使用主机网络
--ipc=host # 共享内存段
-e AUDIO_GID="$(getent group audio | cut -d: -f3)" # 可选 默认63（fedora） 主机audio gid 解决声音设备访问权限问题
-e VIDEO_GID="$(getent group video | cut -d: -f3)" # 
-e GID=${GID} -e UID=${UID} # 可选 默认1000 主机当前用户 gid 解决挂载目录访问权限问题
-e XMODIFIERS=@im=ibus -e QT_IM_MODULE=ibus -e GTK_IM_MODULE=ibus # 指定输入法
```

### run docker wechat

```shell
docker run -it \
  --name docker-wechat \
  --net=host \
  --ipc=host \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
  -v $HOME/.config/weixin:/root/.config/weixin \
  -e XMODIFIERS=@im=ibus \
  -e QT_IM_MODULE=ibus \
  -e GTK_IM_MODULE=ibus \
  docker-wechat:v1.0

```

关闭？
```shell
xhost -
```
