CONFIG -= qt
SOURCES = libxml2.cpp
mac {
    QMAKE_CXXFLAGS += -iwithsysroot /usr/include/libxml2
    LIBS += -lxml2
} else:!contains(QT_CONFIG, no-pkg-config) {
    PKGCONFIG += libxml-2.0
    CONFIG += link_pkgconfig
} else:!win32-* {
    INCLUDEPATH += /usr/include/libxml2
    LIBS += -lxml2
}
