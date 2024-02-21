#ifndef GAMEPLAY_H
#define GAMEPLAY_H

#include <QObject>

class GamePlay : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QString> myHand READ myHand NOTIFY myHandChanged FINAL)
    Q_PROPERTY(QList<QString> enemyHand READ enemyHand NOTIFY enemyHandChanged FINAL)
    Q_PROPERTY(bool myHasPassed READ myHasPassed NOTIFY myHasPassedChanged FINAL)
    Q_PROPERTY(bool enemyHasPassed READ enemyHasPassed NOTIFY enemyHasPassedChanged FINAL)
    Q_PROPERTY(bool isMyTurn READ isMyTurn NOTIFY isMyTurnChanged FINAL)
    Q_PROPERTY(bool isGameStarted READ isGameStarted NOTIFY isGameStartedChanged FINAL)
    Q_PROPERTY(int myScore READ myScore NOTIFY myScoreChanged FINAL)
    Q_PROPERTY(int enemyScore READ enemyScore NOTIFY enemyScoreChanged FINAL)
    Q_PROPERTY(QString roundWinners READ roundWinners NOTIFY roundWinnersChanged FINAL)
    Q_PROPERTY(QString enemyCard READ enemyCard NOTIFY enemyCardPlayed FINAL)
    Q_PROPERTY(bool isAceSpadesActive READ isAceSpadesActive NOTIFY isAceSpadesActiveChanged FINAL)
    Q_PROPERTY(bool isAceDiamondsActive READ isAceDiamondsActive NOTIFY isAceDiamondsActiveChanged FINAL)
    Q_PROPERTY(bool isAceClubsActive READ isAceClubsActive NOTIFY isAceClubsActiveChanged FINAL)

private:
    std::vector<std::string> possible_cards { "XX", "XX",
        "As", "Ks", "Qs", "Js", "Ts", "9s", "8s", "7s", "6s", "5s",
        "Ad", "Kd", "Qd", "Jd", "Td", "9d", "8d", "7d", "6d", "5d",
        "Ac", "Kc", "Qc", "Jc", "Tc", "9c", "8c", "7c", "6c", "5c"};
    std::vector<std::string> deck{};
    std::vector<std::string> m_myHand{};
    std::vector<std::string> m_enemyHand{};
    std::vector<std::string> m_cardsPlayedThisRound{};
    bool m_myHasPassed;
    bool m_enemyHasPassed;
    bool m_isMyTurn;
    bool m_isGameStarted;
    int m_myScore;
    int m_enemyScore;
    std::string m_myCard;
    std::string m_enemyCard;
    std::string m_roundWinners;
    bool m_isAceSpadesActive;
    bool m_isAceDiamondsActive;
    bool m_isAceClubsActive;

    std::string drawCard();
    std::string fromCardNotationToImageName( std::string );
    std::string fromImageNameToCardNotation( std::string );
    void updateScores();
    void startNextTurn();
    void startNewRound();
    std::string chooseEnemyCard();
    void addToCardsPlayedThisRound( std::string );
    void changeTurn();
    void sleep();

public: // these are variables (built as functions) that the UI can view
    explicit GamePlay(QObject *parent = nullptr);
    QList<QString> myHand();
    QList<QString> enemyHand();
    bool myHasPassed();
    bool enemyHasPassed();
    bool isMyTurn();
    bool isGameStarted();
    int myScore();
    int enemyScore();
    QString roundWinners();
    QString enemyCard();
    bool isAceSpadesActive();
    bool isAceDiamondsActive();
    bool isAceClubsActive();



signals: // these signal to the UI that it needs to update
    QList<QString> myHandChanged();
    QList<QString> enemyHandChanged();
    bool myHasPassedChanged();
    bool enemyHasPassedChanged();
    bool isMyTurnChanged();
    bool isGameStartedChanged();
    int myScoreChanged();
    int enemyScoreChanged();
    QString roundWinnersChanged();
    QString enemyCardPlayed();
    bool isAceSpadesActiveChanged();
    bool isAceDiamondsActiveChanged();
    bool isAceClubsActiveChanged();

public slots: // these are functions that the UI can call
    void startNewGame();
    void playMyCard( QString );
    void playEnemyCard();
    void exitGame();
};

#endif // GAMEPLAY_H
