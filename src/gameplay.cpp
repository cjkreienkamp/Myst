#include "gameplay.h"
#include <QDebug>
#include <vector>
#include <algorithm>
#include <stack>
#include <map>
#include <string>
#include <regex>

GamePlay::GamePlay(QObject *parent)
    : QObject{parent}
    , m_myScore(0)
    , m_enemyScore(0)
    , m_roundWinners("xxx")
    , m_isGameStarted(false)
{}

std::string GamePlay::drawCard()
{
    std::string card = deck.back();
    deck.pop_back();
    return card;
}

std::string GamePlay::fromCardNotationToImageName(std::string cardNotation)
{
    if (cardNotation == "X1")
        return "images/joker1.jpeg";
    if (cardNotation == "X2")
        return "images/joker2.jpeg";

    std::map<char, std::string> rank_map = {{'A',"ace"}, {'K',"king"}, {'Q',"queen"}, {'J',"jack"}, {'T',"10"},
                                            {'9',"9"}, {'8',"8"}, {'7',"7"}, {'6',"6"}, {'5',"5"}};
    std::map<char, std::string> suit_map = {{'s',"spades"}, {'d',"diamonds"}, {'c',"clubs"}};

    std::string rank = rank_map[ cardNotation[0] ];
    std::string suit = suit_map[ cardNotation[1] ];
    return "images/" + rank + "_of_" + suit + ".png";
}

std::string GamePlay::fromImageNameToCardNotation(std::string imageName)
{
    if (imageName == "images/joker1.jpeg")
        return "X1";
    if (imageName == "images/joker2.jpeg")
        return "X2";

    std::map<std::string, char> rank_map = {{"ace",'A'}, {"king",'K'}, {"queen",'Q'}, {"jack",'J'}, {"10",'T'},
                                            {"9",'9'}, {"8",'8'}, {"7",'7'}, {"6",'6'}, {"5",'5'}};

    std::string rank = imageName.substr(7,imageName.find("_of_")-7);
    std::string suit = imageName.substr(imageName.find("_of_")+4,1);

    return rank_map[rank] + suit;
}

void GamePlay::updateScores()
{
    std::map<char, bool> ace_map = {{'s',false}, {'d',false}, {'c',false}};

    for (auto it = m_cardsPlayedThisRound.rbegin(); it != m_cardsPlayedThisRound.rend(); ++it) {
        std::string card = *it;
        char rank = card[1];
        char suit = card[2];
        if (rank == 'X') break;
        else if (rank == 'A') ace_map[ suit ] = true;
    }

    if (ace_map['s']) m_isAceSpadesActive = true; emit isAceSpadesActiveChanged();
    if (ace_map['d']) m_isAceDiamondsActive = true; emit isAceDiamondsActiveChanged();
    if (ace_map['c']) m_isAceClubsActive = true; emit isAceClubsActiveChanged();

    std::map<char,int> ranksToValues = {{'K',10}, {'Q',10}, {'J',10}, {'T',10},
                                        {'9',9}, {'8',8}, {'7',7}, {'6',6}, {'5',5}};

    m_myScore = 0;
    m_enemyScore = 0;

    for (auto card : m_cardsPlayedThisRound) {
        char rank = card[1];
        if (rank == 'X' || rank == 'A') continue;
        char suit = card[2];
        bool inMyField = false;
        if ( (card[0]=='m' && rank!='J') || (card[0]=='e' && rank=='J') ) inMyField = true;
        if (ace_map[ suit ] && rank != 'K') {
            if (inMyField) m_myScore += 1;
            else m_enemyScore += 1;
        }
        else {
            if (inMyField) m_myScore += ranksToValues[rank];
            else m_enemyScore += ranksToValues[rank];
        }
    }

    emit myScoreChanged();
    emit enemyScoreChanged();
}

void GamePlay::startNewRound()
{
    int round;
    if (m_roundWinners[0] == 'x') round = 1;
    else if (m_roundWinners[1] == 'x') round = 2;
    else round = 3;

    if (m_myScore > m_enemyScore) m_roundWinners[round-1] = 'm';
    else if (m_myScore < m_enemyScore) m_roundWinners[round-1] = 'e';
    else m_roundWinners[round-1] = 't';
    emit roundWinnersChanged();

    m_cardsPlayedThisRound.clear();
    updateScores();
    m_myHasPassed = false; emit myHasPassedChanged();
    m_enemyHasPassed = false; emit enemyHasPassedChanged();
    m_isAceSpadesActive = false; emit isAceSpadesActiveChanged();
    m_isAceDiamondsActive = false; emit isAceDiamondsActiveChanged();
    m_isAceClubsActive = false; emit isAceClubsActiveChanged();

    if ( ( round == 2 && (
                          (m_roundWinners[0] == m_roundWinners[1] && m_roundWinners[0] != 't') ||
                          (m_roundWinners[0] == 't' && m_roundWinners[1] != 't') ||
                          (m_roundWinners[1] == 't' && m_roundWinners[0] != 't')
                         )
         ) || round == 3) {
        m_isGameStarted = false; emit isGameStartedChanged();
    } else {
        m_myHand.push_back( drawCard() ); emit myHandChanged();
        m_enemyHand.push_back( drawCard() ); emit enemyHandChanged();
    }
}

QList<QString> GamePlay::myHand()
{
    QList<QString> newList;

    for (std::string card : m_myHand)
        newList.append( QString::fromStdString( fromCardNotationToImageName(card) ) );

    return newList;
}

QList<QString> GamePlay::enemyHand()
{
    QList<QString> newList;

    for (std::string card : m_enemyHand)
        newList.append( QString::fromStdString( fromCardNotationToImageName(card) ) );

    return newList;
}

bool GamePlay::myHasPassed()
{
    return m_myHasPassed;
}

bool GamePlay::enemyHasPassed()
{
    return m_enemyHasPassed;
}

bool GamePlay::isMyTurn()
{
    return m_isMyTurn;
}

bool GamePlay::isGameStarted()
{
    return m_isGameStarted;
}

int GamePlay::myScore()
{
    return m_myScore;
}

int GamePlay::enemyScore()
{
    return m_enemyScore;
}

QString GamePlay::enemyCard()
{
    return QString::fromStdString( fromCardNotationToImageName(m_enemyCard) );
}

bool GamePlay::isAceSpadesActive()
{
    return m_isAceSpadesActive;
}

bool GamePlay::isAceDiamondsActive()
{
    return m_isAceDiamondsActive;
}

bool GamePlay::isAceClubsActive()
{
    return m_isAceClubsActive;
}

QString GamePlay::roundWinners()
{
    return QString::fromStdString(m_roundWinners);
}

void GamePlay::startNewGame()
{
    copy(&possible_cards[0], &possible_cards[possible_cards.size()], back_inserter(deck));
    m_myHand.clear();
    m_enemyHand.clear();
    m_cardsPlayedThisRound.clear();
    updateScores();
    m_roundWinners = "xxx"; emit roundWinnersChanged();
    m_myHasPassed = false; emit myHasPassedChanged();
    m_enemyHasPassed = false; emit enemyHasPassedChanged();
    m_isAceSpadesActive = false; emit isAceSpadesActiveChanged();
    m_isAceDiamondsActive = false; emit isAceDiamondsActiveChanged();
    m_isAceClubsActive = false; emit isAceClubsActiveChanged();

    for (int i = 0; i < deck.size() - 1; i++) {
        int j = i + rand() % (deck.size() - i);
        std::swap(deck[i], deck[j]);
    }

    m_isMyTurn = rand() % 2; emit isMyTurnChanged();

    if ( m_isMyTurn ) {
        m_myHand.push_back( drawCard() );
    } else {
        m_enemyHand.push_back( drawCard() );
    }

    for (int i = 0; i < 7; i++) {
        m_myHand.push_back( drawCard() );
        m_enemyHand.push_back( drawCard() );
    }

    // whoever goes first, make them pick a card
    if ( m_isMyTurn ) {
        m_myHand.erase( m_myHand.begin() + rand() % m_myHand.size() );
    } else {
        m_enemyHand.erase( m_enemyHand.begin() + rand() % m_enemyHand.size() );
    }

    qDebug() << "*****MY HAND*****";
    for (auto i: m_myHand)
        qDebug() << i << ' ';
    qDebug() << "*****ENEMY HAND*****";
    for (auto i: m_enemyHand)
        qDebug() << i << ' ';

    emit myHandChanged();
    emit enemyHandChanged();
    m_isGameStarted = true; emit isGameStartedChanged();
}

void GamePlay::playMyCard(QString card)
{
    m_myCard = card.toUtf8().constData();
    if ( m_myCard != "pass") {
        m_myCard = fromImageNameToCardNotation(m_myCard);
    }
    startNextTurn();
}

void GamePlay::playEnemyCard()
{
    int index_of_chosen_card = rand() % (m_enemyHand.size() + 1);
    if (index_of_chosen_card == m_enemyHand.size()) {
        m_enemyCard = "pass";
    } else {
        m_enemyCard = m_enemyHand[index_of_chosen_card];
    }
    startNextTurn();
}

void GamePlay::startNextTurn()
{
    std::string cardPlayedThisTurn;

    if (m_isMyTurn) {
        cardPlayedThisTurn = m_myCard;
        if (cardPlayedThisTurn == "pass") {
            m_myHasPassed = true; emit myHasPassedChanged();
        }
    } else {
        cardPlayedThisTurn = m_enemyCard;
        if (cardPlayedThisTurn == "pass") {
            m_enemyHasPassed = true; emit enemyHasPassedChanged();
        } else emit enemyCardPlayed();
    }

    addToCardsPlayedThisRound(cardPlayedThisTurn);

    if (m_myHasPassed && m_enemyHasPassed) startNewRound();
    else changeTurn();
}

void GamePlay::addToCardsPlayedThisRound(std::string card)
{
    if ( card == "pass" ) return;
    if (m_isMyTurn) {
        m_myHand.erase(std::remove(m_myHand.begin(), m_myHand.end(), card), m_myHand.end());
        if (card[0] == 'J') {
            m_myHand.push_back( drawCard() );
            m_myHand.push_back( drawCard() );
        }
        card.insert(0,"m");
        emit myHandChanged();
    } else {
        m_enemyHand.erase(std::remove(m_enemyHand.begin(), m_enemyHand.end(), card), m_enemyHand.end());
        if (card[0] == 'J') {
            m_enemyHand.push_back( drawCard() );
            m_enemyHand.push_back( drawCard() );
        }
        card.insert(0,"e");
        emit enemyHandChanged();
    }
    m_cardsPlayedThisRound.push_back( card );

    qDebug() << "---------------------------";
    for (auto card : m_cardsPlayedThisRound) qDebug() << card;

    if (card[1] == 'X') {
        m_isAceSpadesActive = false; emit isAceSpadesActiveChanged();
        m_isAceDiamondsActive = false; emit isAceDiamondsActiveChanged();
        m_isAceClubsActive = false; emit isAceClubsActiveChanged();
    }
    updateScores();
}

void GamePlay::changeTurn()
{
    if ( (m_isMyTurn && !m_enemyHasPassed)
        || (!m_isMyTurn && !m_myHasPassed) ) {
        m_isMyTurn = !m_isMyTurn;
    }
    emit isMyTurnChanged();
}

void GamePlay::exitGame()
{
    qDebug() << "exit";
}
