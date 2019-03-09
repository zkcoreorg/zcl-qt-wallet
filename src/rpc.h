#ifndef RPCCLIENT_H
#define RPCCLIENT_H

#include "precompiled.h"

#include "balancestablemodel.h"
#include "txtablemodel.h"
#include "ui_mainwindow.h"
#include "mainwindow.h"
#include "connection.h"

using json = nlohmann::json;

class Turnstile;

struct TransactionItem {
    QString         type;
    qint64            datetime;
    QString         address;
    QString         txid;
    double          amount;
    unsigned long   confirmations;
    QString         fromAddr;
    QString         memo;
};

struct WatchedTx {
    QString opid;
    Tx tx;
    std::function<void(QString, QString)> completed;
    std::function<void(QString, QString)> error;
};

class RPC
{
public:
    RPC(MainWindow* main);
    ~RPC();

    void setConnection(Connection* c);
    void setEzkCored(QProcess* p);
    const QProcess* getEzkCoreD() { return ezkcored; }

    void refresh(bool force = false);

    void refreshAddresses();

    void checkForUpdate(bool silent = true);
    void refreshZKCPrice();
    void getZboardTopics(std::function<void(QMap<QString, QString>)> cb);

    void executeTransaction(Tx tx,
        const std::function<void(QString opid)> submitted,
        const std::function<void(QString opid, QString txid)> computed,
        const std::function<void(QString opid, QString errStr)> error);

    void fillTxJsonParams(json& params, Tx tx);
    void sendZTransaction(json params, const std::function<void(json)>& cb, const std::function<void(QString)>& err);
    void watchTxStatus();
    void addNewTxToWatch(const QString& newOpid, WatchedTx wtx);

    const TxTableModel*               getTransactionsModel() { return transactionsTableModel; }
    const QList<QString>*             getAllZAddresses()     { return zaddresses; }
    const QList<UnspentOutput>*       getUTXOs()             { return utxos; }
    const QMap<QString, double>*      getAllBalances()       { return allBalances; }
    const QMap<QString, bool>*        getUsedAddresses()     { return usedAddresses; }

    void newZaddr(bool sapling, const std::function<void(json)>& cb);
    void newTaddr(const std::function<void(json)>& cb);

    void getZPrivKey(QString addr, const std::function<void(json)>& cb);
    void getTPrivKey(QString addr, const std::function<void(json)>& cb);
    void importZPrivKey(QString addr, bool rescan, const std::function<void(json)>& cb);
    void importTPrivKey(QString addr, bool rescan, const std::function<void(json)>& cb);

    void shutdownzkCored();
    void noConnection();

    QString getDefaultSaplingAddress();

    void getAllPrivKeys(const std::function<void(QList<QPair<QString, QString>>)>);

    Turnstile*  getTurnstile()  { return turnstile; }
    Connection* getConnection() { return conn; }

private:
    void refreshBalances();

    void refreshTransactions();
    void refreshSentZTrans();
    void refreshReceivedZTrans(QList<QString> zaddresses);

    bool processUnspent     (const json& reply);
    void updateUI           (bool anyUnconfirmed);

    void getInfoThenRefresh(bool force);

    void getBalance(const std::function<void(json)>& cb);

    void getTransparentUnspent  (const std::function<void(json)>& cb);
    void getZUnspent            (const std::function<void(json)>& cb);
    void getTransactions        (const std::function<void(json)>& cb);
    void getZAddresses          (const std::function<void(json)>& cb);

    Connection*                 conn                        = nullptr;
    QProcess*                   ezkcored                     = nullptr;

    QList<UnspentOutput>*       utxos                       = nullptr;
    QMap<QString, double>*      allBalances                 = nullptr;
    QMap<QString, bool>*        usedAddresses               = nullptr;
    QList<QString>*             zaddresses                  = nullptr;

    QMap<QString, WatchedTx>    watchingOps;

    TxTableModel*               transactionsTableModel      = nullptr;
    BalancesTableModel*         balancesTableModel          = nullptr;

    QTimer*                     timer;
    QTimer*                     txTimer;
    QTimer*                     priceTimer;

    Ui::MainWindow*             ui;
    MainWindow*                 main;
    Turnstile*                  turnstile;

    // Current balance in the UI. If this number updates, then refresh the UI
    QString                     currentBalance;
};

#endif // RPCCLIENT_H
