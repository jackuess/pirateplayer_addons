#include "mainwindow.h"

#include <QDebug>
#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QHBoxLayout>
#include <QtDeclarative>
#include <QScrollBar>
#include <QCoreApplication>

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent)
{
    QWidget *window = new QWidget();
    setCentralWidget(window);
    QHBoxLayout *l = new QHBoxLayout(window);
    QDeclarativeView *view = new QDeclarativeView(window);

    view->engine()->setNetworkAccessManagerFactory(new NetworkAccessManagerFactory);
    view->engine()->rootContext()->setContextProperty("mainWindow", this);
    view->engine()->setImportPathList(view->engine()->importPathList() << "../src/browser/imports");

    view->setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view->setStyleSheet("background-color:transparent;");
    view->setSource(QUrl::fromLocalFile("../src/" + QCoreApplication::arguments().last() + "/main.qml"));

    l->addWidget(view);

    resize(800, 640);
}

void MainWindow::getStreams(QString url, QVariantMap metaData) {
    qDebug() << "Url: " << url;
    qDebug() << "Meta data: " << metaData;
}
