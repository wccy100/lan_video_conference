import QtQuick 2.0
import QtQuick.Controls 2.2
import Meeting 1.0

Item {
    id: notification
    anchors.fill: parent
//    property var xvisible: false
    property var notificationMessage: []
    property var notificationCategory: []
    property var meetingID: []
    property var currentMeetingIndex

//    onVisibleChanged: {
//        notification.visible = xvisible
//    }

    property Notification not
    function initNotification() {
        while (notificationMessage.length != 0) {
            notificationCategory.pop()
            notificationMessage.pop()
            meetingID.pop()
        }

        //        notificationMessage.length = notificationCategory.length = meetingID.length = 0
        for (var i = 0; i !== conferenceUI.employee.notificationCount(); i++) {
            not = conferenceUI.employee.getNotification(i)
            notificationMessage[i] = not.notificationMessage
            notificationCategory[i] = not.notificationCategory
            meetingID[i] = not.meetingID
        }
    }

    Loader {
        id: notificationLoader
        anchors.fill: parent
    }

    Connections {
        target: conferenceUI.employee
        onLoginSucceeded: {
            if (type === "NotificationMessage") {

                initNotification()
                console.log("refresh notification  ",
                            notificationMessage.length)
                notificationLoader.sourceComponent = null
                notificationLoader.sourceComponent = notificationComponent
            }
        }
    }

    Component {
        id: notificationComponent
        ScrollView {
            id: notificationList
            anchors.fill: parent
            ListView {
                model: notificationMessage.length
                spacing: 0.1
                delegate: Rectangle {
                    width: mainWindow.width * 0.85
                    height: mainWindow.height * 0.10
                    border.width: 0.5
                    //                border.color: "blue"
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: mainWindow.width * 0.01
                        text: notificationMessage[index]
                        //                    font.pixelSize: 15
                    }
                    Rectangle {
                        width: mainWindow.width * 0.30
                        height: mainWindow.height * 0.10 - 2
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        visible: {
                            console.log("notificationCategory  ",
                                        notificationCategory[index])
                            var s = notificationCategory[index]
                            if (s === "MEETING_INVITATION")
                                return true
                            else
                                return false
                        }
                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            spacing: 10
                            Button {
                                text: "同意"
                                onClicked: {
                                    conferenceUI.getReplyMeetingInvitation(
                                                "1", meetingID[index], "")
                                }
                            }
                            Button {
                                text: "拒绝"
                                onClicked: {
                                    currentMeetingIndex = index
                                    refuse.visible = true
                                    notificationLoader.opacity = 0.1
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Rectangle {
        id: refuse
        visible: false
        anchors.centerIn: parent
        width: mainWindow.width * 0.4
        height: mainWindow.height * 0.50
        Rectangle {
            width: 20
            height: 20
            anchors.top: parent.top
            anchors.right: parent.right
            Image {
                id: back
                source: "../resources/back.png"
                anchors.fill: parent
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        refuse.visible = false
                        //                        notificationList.opacity = 1
                        mistake.text = ""
                    }
                }
            }
        }
        Column {
            anchors.fill: parent
            spacing: 10
            Text {
                text: "请填写无法参会理由"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                width: mainWindow.width * 0.40
                height: mainWindow.height * 0.30
                anchors.horizontalCenter: parent.horizontalCenter
                border.width: 1
                ScrollView {
                    anchors.fill: parent
                    TextArea {
                        id: refuseText
                    }
                }
            }
            Button {
                text: "确定"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    if (refuseText.text.length !== 0) {
                        conferenceUI.getReplyMeetingInvitation(
                                    "0", meetingID[currentMeetingIndex],
                                    refuseText.text)
                        notificationLoader.opacity = 1
                        refuse.visible = false
                        mistake.text = ""
                        refuseText.text = ""
                    } else
                        mistake.text = "无法参会原因不能为空"
                }
            }
            Text {
                id: mistake
                anchors.horizontalCenter: parent.horizontalCenter
                color: "red"
            }
        }
    }
}
