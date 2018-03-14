export TARGET = iphone:11.2:9.0

INSTALL_TARGET_PROCESSES = Preferences

ifneq ($(RESPRING),0)
    INSTALL_TARGET_PROCESSES += SpringBoard
endif

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DailyPaper
DailyPaper_FILES = $(wildcard *.x) $(wildcard *.m)
DailyPaper_FRAMEWORKS = UIKit CoreGraphics
DailyPaper_PRIVATE_FRAMEWORKS = PersistentConnection PhotoLibrary SpringBoardFoundation
DailyPaper_EXTRA_FRAMEWORKS = Cephei
DailyPaper_CFLAGS = -include Global.h -fobjc-arc

SUBPROJECTS = prefs

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
