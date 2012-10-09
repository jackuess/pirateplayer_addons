#-------------------------------------------------
#
# Project created by QtCreator 2012-09-22T00:56:40
#
#-------------------------------------------------

QT       += core gui
QT       += network
QT       += declarative

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = addonviewer

TEMPLATE = app

LIBS += -L/usr/lib/ -ltidy

SOURCES += main.cpp \
    mainwindow.cpp \
    tidynetworkaccessmanager.cpp \
    tidynetworkreply.cpp \
    networkaccessmanagerfactory.cpp

HEADERS += \
    mainwindow.h \
    tidynetworkaccessmanager.h \
    tidynetworkreply.h \
    networkaccessmanagerfactory.h

