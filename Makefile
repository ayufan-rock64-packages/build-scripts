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
	bash package.bash rockchip-linux xserver rockchip-1.19 xorg-server bionic

xf86-video-armsoc:
	bash package.bash rockchip-linux xf86-video-armsoc master xf86-video-armsoc bionic

mpp:
	bash package.bash rockchip-linux mpp release

clean:
	rm -f $(filter-out $(wildcard *.orig.tar.*) $(wildcard *.debian.tar.*), \
		$(wildcard *.tar.gz *.tar.xz *.dsc *.build *.buildinfo *.changes *.ppa.upload *.ddeb *.deb))
