/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/

import QtQuick 2.15
import QtQuick.Controls 2.15
import Christopher 1.0

Rectangle {
    width: window.width //1920/2.25
    height: window.height //1080/2

    GamePlay {
        id: gamePlay
        onRoundWinnersChanged: delayAfterRound.running = true
    }

    Timer {
        id: delayAfterRound
        repeat: false
        interval: 1000
        onTriggered: {
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
        width: parent.width/8
        color: "#f5caca"
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
        }

        Image {
            id: specialCardsImage
            height: myHandRectangle.height
            fillMode: Image.PreserveAspectFit
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }

        Button {
            enabled: gamePlay.isMyTurn && gamePlay.isGameStarted
            onClicked: gamePlay.playMyCard("pass")
            height: parent.height/10
            anchors {
                bottom: parent.bottom; bottomMargin: 10
                left: parent.left; leftMargin: 5
                right: parent.right; rightMargin: 5
            }

            Text {
                text: qsTr("Pass")
                font.pixelSize: parent.width/4
                font.bold: true
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: scoreRectangle
        width: parent.width/6
        color: "#c79999"
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }

        Rectangle {
            visible: !gamePlay.isMyTurn && gamePlay.isGameStarted
            color: "#edf4f9"
            opacity: 0.5
            radius: 10
            anchors {
                fill: enemyScoreRectangle; margins: -4
            }
        }

        Rectangle {
            id: enemyScoreRectangle
            height: parent.height/9
            width: height
            radius: 10
            color: gamePlay.enemyHasPassed ? "black" : "#a7c9e3"
            anchors {
                bottom: parent.verticalCenter; bottomMargin: parent.height/64
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: gamePlay.enemyScore
                color: gamePlay.enemyHasPassed ? "#a7c9e3" : "black"
                font.pixelSize: parent.height/2
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle {
            visible: gamePlay.isMyTurn && gamePlay.isGameStarted
            color: "#edf4f9"
            opacity: 0.5
            radius: 10
            anchors {
                fill: myScoreRectangle; margins: -4
            }
        }

        Rectangle {
            id: myScoreRectangle
            height: parent.height/9
            width: height
            radius: 10
            color: gamePlay.myHasPassed ? "black" : "#a7c9e3"
            anchors {
                top: parent.verticalCenter; topMargin: parent.height/64
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: gamePlay.myScore
                color: gamePlay.myHasPassed ? "#a7c9e3" : "black"
                font.pixelSize: parent.height/2
                font.bold: true
                anchors.centerIn: parent
            }
        }

        function getWinnerColorFromRoundNumber(round) {
            var charOfInterest = gamePlay.roundWinners[round-1]
            if (charOfInterest === "m") return "#2478ed"
            else if (charOfInterest === "e") return "#c45656"
            else if (charOfInterest === "t") return "#8056c4"
            else return "#a7c9e3"
        }

        Rectangle {
            id: round1Circle
            height: parent.height/12
            width: height
            radius: 100
            color: scoreRectangle.getWinnerColorFromRoundNumber(1)
            anchors {
                top: parent.verticalCenter; topMargin: parent.height*3/16
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: qsTr("1")
                font.pixelSize: parent.width/2
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle {
            id: round2Circle
            height: parent.height/12
            width: height
            radius: 100
            color: scoreRectangle.getWinnerColorFromRoundNumber(2)
            anchors {
                top: round1Circle.bottom; topMargin: parent.height/64
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: qsTr("2")
                font.pixelSize: parent.width/2
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Rectangle {
            id: round3Circle
            height: parent.height/12
            width: height
            radius: 100
            color: scoreRectangle.getWinnerColorFromRoundNumber(3)
            anchors {
                top: round2Circle.bottom; topMargin: parent.height/64
                horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: qsTr("3")
                font.pixelSize: parent.width/2
                font.bold: true
                anchors.centerIn: parent
            }
        }
    }

    Rectangle {
        id: enemyFieldRectangle
        color: "#ff8f8f"
        anchors {
            left: specialCardsRectangle.right
            right: scoreRectangle.left
            top: parent.top
            bottom: parent.verticalCenter; bottomMargin: parent.height/128
        }

        Timer {
            running: !gamePlay.isMyTurn && !gamePlay.enemyHasPassed && gamePlay.isGameStarted
            interval: delayAfterRound.running ? 1500 : 500
            onTriggered: gamePlay.playEnemyCard()
        }

        function moveCardFromEnemyHandToField(imageName) {
            enemyHandListModel.remove(0)
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

        Rectangle {
            id: enemyHandRectangle
            height: parent.height/4
            color: "#86ae86"
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }

            Row {
                spacing: parent.width/50
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                }

                ListModel{ id: enemyHandListModel }

                Repeater {
                    model: enemyHandListModel

                    Image {
                        source: name
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            top: parent.top; topMargin: parent.height/15
                            bottom: parent.bottom; bottomMargin: parent.height/15
                        }
                    }
                }

                Connections {
                    target: gamePlay
                    onEnemyHandChanged: {
                        enemyHandListModel.clear()
                        for (var card of gamePlay.enemyHand)
                            enemyHandListModel.append({name: "images/back_of_card.png"})
                    }
                    onEnemyCardPlayed: enemyFieldRectangle.moveCardFromEnemyHandToField(gamePlay.enemyCard)
                }
            }
        }

        Rectangle {
            id: enemyClubsRectangle
            height: parent.height/4
            color: "#c1f9c1"
            anchors {
                left: parent.left
                right: parent.right
                top: enemyHandRectangle.bottom
            }

            Row {
                spacing: 10
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                }

                ListModel{ id: enemyClubsListModel }

                Repeater {
                    model: enemyClubsListModel

                    Image {
                        source: name
                        rotation: gamePlay.isAceClubsActive && !name.includes("king") ? 90 : 0
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            top: parent.top; topMargin: parent.height/15
                            bottom: parent.bottom; bottomMargin: parent.height/15
                        }
                    }
                }
            }
        }

        Rectangle {
            id: enemyDiamondsRectangle
            height: parent.height/4
            color: "#75a975"
            anchors {
                left: parent.left
                right: parent.right
                top: enemyClubsRectangle.bottom
            }

            Row {
                spacing: 10
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                }

                ListModel{ id: enemyDiamondsListModel }

                Repeater {
                    model: enemyDiamondsListModel

                    Image {
                        source: name
                        rotation: gamePlay.isAceDiamondsActive && !name.includes("king") ? 90 : 0
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            top: parent.top; topMargin: parent.height/15
                            bottom: parent.bottom; bottomMargin: parent.height/15
                        }
                    }
                }
            }
        }

        Rectangle {
            id: enemySpadesRectangle
            height: parent.height/4
            color: "#b7e6b7"
            anchors {
                left: parent.left
                right: parent.right
                top: enemyDiamondsRectangle.bottom
            }

            Row {
                spacing: 10
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                }

                ListModel{ id: enemySpadesListModel }

                Repeater {
                    model: enemySpadesListModel

                    Image {
                        source: name
                        rotation: gamePlay.isAceSpadesActive && !name.includes("king") ? 90 : 0
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            top: parent.top; topMargin: parent.height/15
                            bottom: parent.bottom; bottomMargin: parent.height/15
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: myFieldRectangle
        color: "#ac8686"
        anchors {
            left: specialCardsRectangle.right
            right: scoreRectangle.left
            top: parent.verticalCenter; topMargin: parent.height/128
            bottom: parent.bottom
        }

        function moveCardFromMyHandToField(imageName) {
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
            gamePlay.playMyCard(imageName)
        }

        Rectangle {
            id: myHandRectangle
            height: parent.height/4
            color: "#ded299"
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Row {
                spacing: parent.width/50
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                }

                ListModel{ id: myHandListModel }

                Repeater {
                    model: myHandListModel

                    Image {
                        source: name
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            top: parent.top; topMargin: parent.height/15
                            bottom: parent.bottom; bottomMargin: parent.height/15
                        }

                        MouseArea {
                            anchors.fill: parent
                            enabled: gamePlay.isMyTurn && gamePlay.isGameStarted
                            onClicked: myFieldRectangle.moveCardFromMyHandToField(name)
                        }
                    }
                }

                Connections {
                    target: gamePlay
                    onMyHandChanged: {
                        myHandListModel.clear()
                        for (var card of gamePlay.myHand)
                            myHandListModel.append({name: card})
                    }
                }
            }
        }

        Rectangle {
            id: myClubsRectangle
            height: parent.height/4
            color: "#c1f9c1"

            anchors {
                left: parent.left
                right: parent.right
                bottom: myHandRectangle.top
            }

            Row {
                spacing: 10
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                }

                ListModel{ id: myClubsListModel }

                Repeater {
                    model: myClubsListModel

                    Image {
                        source: name
                        rotation: gamePlay.isAceClubsActive && !name.includes("king") ? 90 : 0
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            top: parent.top; topMargin: parent.height/15
                            bottom: parent.bottom; bottomMargin: parent.height/15
                        }
                    }
                }
            }
        }

        Rectangle {
            id: myDiamondsRectangle
            height: parent.height/4
            color: "#75a975"
            anchors {
                left: parent.left
                right: parent.right
                bottom: myClubsRectangle.top
            }

            Row {
                spacing: 10
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                }

                ListModel{ id: myDiamondsListModel }

                Repeater {
                    model: myDiamondsListModel

                    Image {
                        source: name
                        rotation: gamePlay.isAceDiamondsActive && !name.includes("king") ? 90 : 0
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            top: parent.top; topMargin: parent.height/15
                            bottom: parent.bottom; bottomMargin: parent.height/15
                        }
                    }
                }
            }
        }

        Rectangle {
            id: mySpadesRectangle
            height: parent.height/4
            color: "#b7e6b7"
            anchors {
                left: parent.left
                right: parent.right
                bottom: myDiamondsRectangle.top
            }

            Row {
                spacing: 10
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    bottom: parent.bottom
                }

                ListModel{ id: mySpadesListModel }

                Repeater {
                    model: mySpadesListModel

                    Image {
                        source: name
                        rotation: gamePlay.isAceSpadesActive && !name.includes("king") ? 90 : 0
                        fillMode: Image.PreserveAspectFit
                        anchors {
                            top: parent.top; topMargin: parent.height/15
                            bottom: parent.bottom; bottomMargin: parent.height/15
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: separator
        color: "black"
        anchors {
            left: specialCardsRectangle.right
            right: scoreRectangle.left
            top: enemyFieldRectangle.bottom
            bottom: myFieldRectangle.top
        }
    }

    Timer {
        id: delayForEndOfGame
        running: !gamePlay.isGameStarted
        interval: 2000
        onTriggered: menu.visible = true
    }

    Item {
        id: menu
        visible: gamePlay.isGameStarted ? false : visible
        anchors.fill: parent

        Rectangle {
            id: menuShadow
            anchors.fill: parent
            color: "black"
            opacity: 0.4
        }

        Rectangle {
            id: menuRectangle
            color: "#a7c9e3"
            radius: 10
            height: parent.height/4
            width: parent.width/1.5
            anchors.centerIn: parent

            Text {
                visible: gamePlay.roundWinners == 'xxx' ? false : true
                text: {
                    if (gamePlay.roundWinners[2] == 'x') {
                        if (gamePlay.roundWinners[0] == 'e' || gamePlay.roundWinners[1] == 'e' ) return "YOU LOSE!"
                        else return "YOU WIN!"
                    }
                    else if (gamePlay.roundWinners[2] == 'e') return "YOU LOSE!"
                    else if (gamePlay.roundWinners[2] == 'm') return "YOU WIN!"
                    else return "DRAW!"
                }
                font.pixelSize: parent.height/4
                font.bold: true
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top; topMargin: parent.height/16
                    bottom: parent.verticalCenter; bottomMargin: parent.height/16
                }
            }

            Button {
                visible: gamePlay.roundWinners == 'xxx' ? true : false
                onClicked: {
                    menu.visible = false
                    gamePlay.startNewGame()
                }
                height: parent.height/1.5
                width: parent.width/1.5
                anchors.centerIn: parent

                Text {
                    text: qsTr("Start Game")
                    font.pixelSize: parent.height/4
                    font.bold: true
                    anchors.centerIn: parent
                }
            }

            Button {
                visible: gamePlay.roundWinners == 'xxx' ? false : true
                onClicked: {
                    menu.visible = false
                    gamePlay.startNewGame()
                }
                anchors {
                    left: parent.left; leftMargin: parent.width/16
                    right: parent.horizontalCenter; rightMargin: parent.width/16
                    top: parent.verticalCenter; topMargin: parent.height/16
                    bottom: parent.bottom; bottomMargin: parent.height/16
                }

                Text {
                    text: qsTr("Play Again")
                    font.pixelSize: parent.height/4
                    font.bold: true
                    anchors.centerIn: parent
                }
            }

            Button {
                onClicked: gamePlay.exitGame()
                height: parent.height/8
                anchors {
                    left: parent.horizontalCenter; leftMargin: parent.width/16
                    right: parent.right; rightMargin: parent.width/16
                    top: parent.verticalCenter; topMargin: parent.height/16
                    bottom: parent.bottom; bottomMargin: parent.height/16
                }
                visible: gamePlay.roundWinners == 'xxx' ? false : true


                Text {
                    text: qsTr("Exit")
                    font.pixelSize: parent.height/4
                    font.bold: true
                    anchors.centerIn: parent
                }
            }
        }
    }
}
