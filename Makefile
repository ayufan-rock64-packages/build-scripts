init:
	git subtree add --prefix=xserver https://github.com/rockchip-linux/xserver rockchip-1.18
	git subtree add --prefix=mpp https://github.com/rock64-linux/libmali rockchip
	git subtree add --prefix=libdrm-rockchip https://github.com/rockchip-linux/libdrm-rockchip rockchip-2.4.74
	git subtree add --prefix=libmali https://github.com/rock64-linux/libmali rockchip

upstream:
	git subtree pull --prefix=xserver https://github.com/rockchip-linux/xserver rockchip-1.18
	git subtree pull --prefix=mpp https://github.com/rock64-linux/libmali rockchip
	git subtree pull --prefix=libdrm-rockchip https://github.com/rockchip-linux/libdrm-rockchip rockchip-2.4.74
	git subtree pull --prefix=libmali https://github.com/rock64-linux/libmali rockchip

fork:
	git subtree pull --prefix=xserver https://github.com/ayufan-rock64/xserver rockchip-1.18
	git subtree pull --prefix=mpp https://github.com/ayufan-rock64/libmali rockchip
	git subtree pull --prefix=libdrm-rockchip https://github.com/ayufan-rock64/libdrm-rockchip rockchip-2.4.74
	git subtree pull --prefix=libmali https://github.com/ayufan-rock64/libmali rockchip

.PHONY: libmali libdrm-rockchip xserver mpp

libmali:
	bash package.bash libmali rockchip

libdrm-rockchip:
	bash package.bash libdrm-rockchip rockchip-2.4.74

xserver:
	bash package.bash xserver rockchip-1.18

mpp:
	bash package.bash mpp for_linux
