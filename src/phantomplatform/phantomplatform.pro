TARGET = phantomplatform

TEMPLATE = lib
CONFIG += plugin

QT += core-private gui-private platformsupport-private

SOURCES =   main.cpp \
            phantomintegration.cpp \
            phantombackingstore.cpp
HEADERS =   phantomintegration.h \
            phantombackingstore.h

OTHER_FILES += phantomplatform.json
