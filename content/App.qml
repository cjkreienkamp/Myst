// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick 6.2
import Myst

Window {
    id: window
    width: 1920/5.5*1.25//mainScreen.width
    height: 1080/2.5*1.25//mainScreen.height

    visible: true
    title: "Myst"

    Screen01 {
        id: mainScreen
    }

}

