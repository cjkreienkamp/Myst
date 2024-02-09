/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
//import QtGraphicalEffects 1.12
import Christopher 1.0

Rectangle {
    id: backgroundRectangle
    width: window.width//1920/5.5*1.25
    height: window.height//1080/2.5*1.25

    GamePlay {
        id: gamePlay
        onRoundWinnersChanged: {
            mySpadesListModel.clear()
            myDiamondsListModel.clear()
            myClubsListModel.clear()
            enemySpadesListModel.clear()
            enemyDiamondsListModel.clear()
            enemyClubsListModel.clear()
            specialCardsImage.source = "images/back_of_card.png"
        }
    }

    Rectangle {
        id: specialCardsRectangle
        width: backgroundRectangle.width/8
        color: "#f5caca"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        anchors.leftMargin: 0

        Image {
            id: specialCardsImage
            height: myHandRectangle.height*13/15
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectFit
        }

        Button {
            id: myPassButton
            height: parent.width/3
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.rightMargin: 5
            anchors.bottomMargin: 10
            anchors.leftMargin: 5
            font.pixelSize: myPassButton.width/2
            onClicked: gamePlay.setMyHasPassed(true)

            Text {
                text: qsTr("My Pass")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: parent.width/6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Button {
            id: enemyPassButton
            height: parent.width/3
            anchors.right: parent.right
            anchors.bottom: myPassButton.top
            anchors.left: parent.left
            anchors.rightMargin: 5
            anchors.bottomMargin: 5
            anchors.leftMargin: 5
            font.pixelSize: enemyPassButton.width/2
            onClicked: gamePlay.setEnemyHasPassed(true)

            Text {
                text: qsTr("Enemy Pass")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: parent.width/6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Rectangle {
        id: scoreRectangle
        width: backgroundRectangle.width/6
        color: "#c79999"
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        Button {
            id: startGameButton
            height: parent.height/8
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.rightMargin: 5
            anchors.topMargin: 5
            anchors.leftMargin: 5
            font.pixelSize: startGameButton.height/2
            onClicked: {
                mySpadesListModel.clear()
                myDiamondsListModel.clear()
                myClubsListModel.clear()
                enemySpadesListModel.clear()
                enemyDiamondsListModel.clear()
                enemyClubsListModel.clear()
                specialCardsImage.source = "images/back_of_card.png"
                gamePlay.startNewGame()
            }

            Text {
                text: qsTr("Start \nGame")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: parent.height/6
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Rectangle {
            id: enemyScoreRectangleGlow
            height: scoreRectangle.height/9 + 8
            width: enemyScoreRectangleGlow.height
            color: "#edf4f9"
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            anchors.bottomMargin: parent.height/64
            visible: {!gamePlay.isMyTurn && gamePlay.isGameStarted}
            opacity: 0.5
        }

        Rectangle {
            id: enemyScoreRectangle
            height: scoreRectangle.height/9
            width: enemyScoreRectangle.height
            color: {
                if (gamePlay.enemyHasPassed) return "#000000"
                else return "#a7c9e3"
            }
            radius: 10
            anchors.centerIn: enemyScoreRectangleGlow
            visible: true

            Text {
                text: gamePlay.enemyScore
                anchors.centerIn: parent
                font.pixelSize: parent.height/2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                color: {
                    if (gamePlay.enemyHasPassed) return "#a7c9e3"
                    else return "#000000"
                }
            }
        }

        Rectangle {
            id: myScoreRectangleGlow
            height: scoreRectangle.height/9 + 8
            width: myScoreRectangleGlow.height
            color: "#edf4f9"
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: parent.height/64
            visible: {gamePlay.isMyTurn && gamePlay.isGameStarted}
            opacity: 0.5
        }

        Rectangle {
            id: myScoreRectangle
            height: scoreRectangle.height/9
            width: myScoreRectangle.height
            color: {
                if (gamePlay.myHasPassed) return "#000000"
                else return "#a7c9e3"
            }
            radius: 10
            anchors.centerIn: myScoreRectangleGlow
            focus: true
            visible: true

            Text {
                id: myScoreText
                text: gamePlay.myScore
                anchors.centerIn: parent
                font.pixelSize: parent.height/2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
                color: {
                    if (gamePlay.myHasPassed) return "#a7c9e3"
                    else return "#000000"
                }
            }
        }

        function getRoundRectangleColorFromNumber(round)
        {
            var charOfInterest = gamePlay.roundWinners[round-1]
            if (charOfInterest === "m") return "#2478ed"
            else if (charOfInterest === "e") return "#c45656"
            else if (charOfInterest === "t") return "#8056c4"
            else return "#a7c9e3"
        }

        Rectangle {
            id: round1Rectangle
            height: parent.height/12
            width: round1Rectangle.height
            color: scoreRectangle.getRoundRectangleColorFromNumber(1)
            radius: 100
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.verticalCenter
            anchors.topMargin: parent.height*3/16
            focus: true

            Text {
                text: qsTr("1")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: parent.height/2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }
        }

        Rectangle {
            id: round2Rectangle
            height: parent.height/12
            width: round2Rectangle.height
            color: scoreRectangle.getRoundRectangleColorFromNumber(2)
            radius: 100
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: round1Rectangle.bottom
            anchors.topMargin: parent.height/64
            focus: true

            Text {
                text: qsTr("2")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: parent.height/2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }
        }

        Rectangle {
            id: round3Rectangle
            height: parent.height/12
            width: round3Rectangle.height
            color: scoreRectangle.getRoundRectangleColorFromNumber(3)
            radius: 100
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: round2Rectangle.bottom
            anchors.topMargin: parent.height/64
            focus: true

            Text {
                text: qsTr("3")
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: parent.height/2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }
        }
    }

    Rectangle {
        id: enemyFieldRectangle
        color: "#ff8f8f"
        anchors.left: specialCardsRectangle.right
        anchors.right: scoreRectangle.left
        anchors.top: parent.top
        anchors.bottom: parent.verticalCenter
        anchors.bottomMargin: parent.height/128

        function moveCardFromEnemyHandToField(imageName) {
            for(var i=0; i<enemyHandListModel.count; ++i)
            {
                if (imageName === enemyHandListModel.get(i).name)
                {
                    enemyHandListModel.remove(i)
                    if (imageName.includes("ace") || imageName.includes("joker")) specialCardsImage.source = imageName
                    else if (imageName.includes("spades")) {
                        if (imageName.includes("jack")) {
                            mySpadesListModel.append({name: imageName})
                        } else {
                            enemySpadesListModel.append({name: imageName})
                        }
                    }
                    else if (imageName.includes("diamonds")) {
                        if (imageName.includes("jack")) {
                            myDiamondsListModel.append({name: imageName})
                        } else {
                            enemyDiamondsListModel.append({name: imageName})
                        }
                    }
                    else if (imageName.includes("clubs")) {
                        if (imageName.includes("jack")) {
                            myClubsListModel.append({name: imageName})
                        } else {
                            enemyClubsListModel.append({name: imageName})
                        }
                    }
                }
            }
            gamePlay.addToCardsPlayedThisRound(imageName)
            gamePlay.changeTurn()
        }

        Rectangle {
            id: enemyHandRectangle
            height: parent.height/4
            color: "#86ae86"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top

            Row {
                id: enemyHandRow
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: parent.width/50

                Connections {
                    target: gamePlay
                    onMyHandChanged: {
                        enemyHandListModel.clear();
                        for (var card of gamePlay.enemyHand)
                            enemyHandListModel.append({name: card});
                    }
                }

                ListModel{
                    id: enemyHandListModel

                    Component.onCompleted: {
                        for (var card of gamePlay.enemyHand)
                            myHandListModel.append({name: card});
                    }
                }

                Repeater {
                    id: enemyHandRepeater
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    model: enemyHandListModel

                    Image {
                        id: enemyHandImage
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: parent.height/15
                        anchors.bottomMargin: parent.height/15
                        fillMode: Image.PreserveAspectFit
                        source: name

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            enabled: !gamePlay.isMyTurn
                            onClicked: enemyFieldRectangle.moveCardFromEnemyHandToField(name)
                        }


                    }
                }
            }
        }

        Rectangle {
            id: enemyClubsRectangle
            y: 7
            height: enemyFieldRectangle.height/4
            color: "#c1f9c1"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: enemyHandRectangle.bottom

            Row {
                id: enemyClubsRow
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                ListModel{
                    id: enemyClubsListModel
                }

                Repeater {
                    id: enemyClubsRepeater
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    model: enemyClubsListModel

                    Image {
                        id: enemyClubsImage
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: parent.height/15
                        anchors.bottomMargin: parent.height/15
                        fillMode: Image.PreserveAspectFit
                        source: name
                    }
                }
            }
        }

        Rectangle {
            id: enemyDiamondsRectangle
            y: 4
            height: enemyFieldRectangle.height/4
            color: "#75a975"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: enemyClubsRectangle.bottom
            anchors.topMargin: 0
            anchors.rightMargin: 0
            anchors.leftMargin: 0

            Row {
                id: enemyDiamondsRow
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                ListModel{
                    id: enemyDiamondsListModel
                }

                Repeater {
                    id: enemyDiamondsRepeater
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    model: enemyDiamondsListModel

                    Image {
                        id: enemyDiamondsImage
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: parent.height/15
                        anchors.bottomMargin: parent.height/15
                        fillMode: Image.PreserveAspectFit
                        source: name
                    }
                }
            }
        }

        Rectangle {
            id: enemySpadesRectangle
            color: "#b7e6b7"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: enemyDiamondsRectangle.bottom
            anchors.bottom: parent.bottom

            Row {
                id: enemySpadesRow
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                ListModel{
                    id: enemySpadesListModel
                }

                Repeater {
                    id: enemySpadesRepeater
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    model: enemySpadesListModel

                    Image {
                        id: enemySpadesImage
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: parent.height/15
                        anchors.bottomMargin: parent.height/15
                        fillMode: Image.PreserveAspectFit
                        source: name
                    }
                }
            }
        }

    }

    Rectangle {
        id: myFieldRectangle
        color: "#ac8686"
        anchors.left: specialCardsRectangle.right
        anchors.right: scoreRectangle.left
        anchors.top: parent.verticalCenter
        anchors.bottom: parent.bottom
        anchors.topMargin: parent.height/128

        function moveCardFromMyHandToField(imageName)
        {
            for(var i=0; i<myHandListModel.count; ++i)
            {
                if (imageName === myHandListModel.get(i).name)
                {
                    myHandListModel.remove(i)
                    if (imageName.includes("ace")) {
                        specialCardsImage.source = imageName
                    }
                    else if (imageName.includes("joker")) specialCardsImage.source = imageName
                    else if (imageName.includes("spades")) {
                        if (imageName.includes("jack")) {
                            enemySpadesListModel.append({name: imageName})
                        } else {
                            mySpadesListModel.append({name: imageName})
                        }
                    }
                    else if (imageName.includes("diamonds")) {
                        if (imageName.includes("jack")) {
                            enemyDiamondsListModel.append({name: imageName})
                        } else {
                            myDiamondsListModel.append({name: imageName})
                        }
                    }
                    else if (imageName.includes("clubs")) {
                        if (imageName.includes("jack")) {
                            enemyClubsListModel.append({name: imageName})
                        } else {
                            myClubsListModel.append({name: imageName})
                        }
                    }
                }
            }
            gamePlay.addToCardsPlayedThisRound(imageName)
            gamePlay.changeTurn()
        }

        Rectangle {
            id: myHandRectangle
            height: myFieldRectangle.height/4
            color: "#86ae86"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            anchors.leftMargin: 0

            Row {
                id: myHandRow
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: parent.width/50

                Connections {
                    target: gamePlay
                    onMyHandChanged: {
                        myHandListModel.clear();
                        for (var card of gamePlay.myHand)
                            myHandListModel.append({name: card});
                    }
                }

                ListModel{
                    id: myHandListModel

                    Component.onCompleted: {
                        for (var card of gamePlay.myHand)
                            myHandListModel.append({name: card});
                    }
                }

                Repeater {
                    id: myHandRepeater
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    model: myHandListModel

                    Image {
                        id: myHandImage
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: parent.height/15
                        anchors.bottomMargin: parent.height/15
                        fillMode: Image.PreserveAspectFit
                        source: name

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            enabled: gamePlay.isMyTurn
                            onClicked: myFieldRectangle.moveCardFromMyHandToField(name)
                        }
                    }
                }
            }
        }

        Rectangle {
            id: myClubsRectangle
            y: 7
            height: myFieldRectangle.height/4
            color: "#c1f9c1"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: myHandRectangle.top
            anchors.rightMargin: 0
            anchors.leftMargin: 0
            anchors.bottomMargin: 0

            Row {
                id: myClubsRow
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                ListModel{
                    id: myClubsListModel
                }

                Repeater {
                    id: myClubsRepeater
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    model: myClubsListModel

                    Image {
                        id: myClubsImage
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: parent.height/15
                        anchors.bottomMargin: parent.height/15
                        fillMode: Image.PreserveAspectFit
                        source: name
                    }
                }
            }
        }

        Rectangle {
            id: myDiamondsRectangle
            y: 4
            height: myFieldRectangle.height/4
            color: "#75a975"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: myClubsRectangle.top
            anchors.bottomMargin: 0
            anchors.rightMargin: 0
            anchors.leftMargin: 0

            Row {
                id: myDiamondsRow
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                ListModel{
                    id: myDiamondsListModel
                }

                Repeater {
                    id: myDiamondsRepeater
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    model: myDiamondsListModel

                    Image {
                        id: myDiamondsImage
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: parent.height/15
                        anchors.bottomMargin: parent.height/15
                        fillMode: Image.PreserveAspectFit
                        source: name
                    }
                }
            }
        }

        Rectangle {
            id: mySpadesRectangle
            color: "#b7e6b7"
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: myDiamondsRectangle.top

            Row {
                id: mySpadesRow
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10

                ListModel{
                    id: mySpadesListModel
                }

                Repeater {
                    id: mySpadesRepeater
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    model: mySpadesListModel

                    Image {
                        id: mySpadesImage
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom
                        anchors.topMargin: parent.height/15
                        anchors.bottomMargin: parent.height/15
                        fillMode: Image.PreserveAspectFit
                        source: name
                    }
                }
            }
        }
    }

    Rectangle {
        id: separatorRectangle
        color: "#000000"
        anchors.top: enemyFieldRectangle.bottom
        anchors.bottom: myFieldRectangle.top
        anchors.left: specialCardsRectangle.right
        anchors.right: scoreRectangle.left
    }
}
