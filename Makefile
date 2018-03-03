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

.PHONY: shell32		# run docker shell to build image
shell32:
	@echo Entering shell...
	@docker run --rm \
		-it \
		-e HOME -v $(HOME):$(HOME) \
		--privileged \
		-h rock64-package-build-env \
		-v $(CURDIR):$(CURDIR) \
		-w $(CURDIR) \
		ayufan/rock64-dockerfiles:arm32

.PHONY: shell64		# run docker shell to build image
shell64:
	@echo Entering shell...
	@docker run --rm \
		-it \
		-e HOME -v $(HOME):$(HOME) \
		--privileged \
		-h rock64-package-build-env \
		-v $(CURDIR):$(CURDIR) \
		-w $(CURDIR) \
		ayufan/rock64-dockerfiles:arm64
