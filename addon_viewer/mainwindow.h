#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include "networkaccessmanagerfactory.h"
#include "tidynetworkaccessmanager.h"
#include "tidynetworkreply.h"

#include <QMainWindow>

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = 0);

public slots:
    void getStreams(QString url, QVariantMap metaData = QVariantMap());
    
};

#endif // MAINWINDOW_H
