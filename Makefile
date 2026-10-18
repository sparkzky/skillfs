# Makefile for cross-building SkillFS under DADK (DragonOS) or standalone.
#
# DADK invokes `make install` inside the cloned source tree with
# DADK_CURRENT_BUILD_DIR pointing at the task's build cache; the stripped
# static binary is placed there and installed into the rootfs /bin.

TOOLCHAIN ?= +nightly-2026-02-24-x86_64-unknown-linux-gnu

ifdef DADK_CURRENT_BUILD_DIR
	INSTALL_DIR = $(DADK_CURRENT_BUILD_DIR)
else
	INSTALL_DIR = ./install
endif

ifeq ($(ARCH), riscv64)
	export RUST_TARGET=riscv64gc-unknown-linux-musl
else
	export RUST_TARGET=x86_64-unknown-linux-musl
endif

build:
	cargo $(TOOLCHAIN) build --target $(RUST_TARGET) --release -p skillfs

install: build
	@mkdir -p $(INSTALL_DIR)
	strip target/$(RUST_TARGET)/release/skillfs -o $(INSTALL_DIR)/skillfs

clean:
	cargo $(TOOLCHAIN) clean

fmt:
	cargo $(TOOLCHAIN) fmt

fmt-check:
	cargo $(TOOLCHAIN) fmt --check

.PHONY: build install clean fmt fmt-check
