TARGETS := libmali libdrm-rockchip xserver mpp gstreamer-rockchip

.PHONY: $(TARGETS)

all: $(TARGETS)

gstreamer-rockchip:
	bash package.bash gstreamer-rockchip master gstreamer1.0-rockchip

libmali:
	bash package.bash libmali rockchip libmali-rk

libdrm-rockchip:
	bash package.bash libdrm-rockchip rockchip-2.4.74

xserver:
	bash package.bash xserver rockchip-1.18 xorg-server

mpp:
	bash package.bash mpp for_linux
