TARGETS := libmali libdrm-rockchip xserver mpp gstreamer-rockchip xf86-video-armsoc

.PHONY: $(TARGETS)

all: $(TARGETS)

gstreamer-rockchip:
	bash package.bash rockchip-linux gstreamer-rockchip master gstreamer1.0-rockchip

libmali:
	bash package.bash rockchip-linux libmali rockchip libmali-rk

libdrm-rockchip:
	bash package.bash rockchip-linux libdrm-rockchip rockchip-2.4.74

xserver-1.18:
	bash package.bash rockchip-linux xserver rockchip-1.18 xorg-server xenial

xserver-1.19:
	bash package.bash rockchip-linux xserver rockchip-1.19 xorg-server zesty

xf86-video-armsoc:
	bash package.bash mmind xf86-video-armsoc packaging/debian xserver-xorg

mpp:
	bash package.bash rockchip-linux mpp release
