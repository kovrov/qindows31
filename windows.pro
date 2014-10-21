TARGET = windows

CONFIG += c++11

QT += quick #gui qml

SOURCES = \
    main.cpp \
    font.cpp

HEADERS = \
    font.h

include(assets/resources.pri)
