/*!
 * This file is part of OffloadBuddy.
 * COPYRIGHT (C) 2018 Emeric Grange - All Rights Reserved
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * \date      2018
 * \author    Emeric Grange <emeric.grange@gmail.com>
 */

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Window 2.2

import com.offloadbuddy.style 1.0

ApplicationWindow {
    id: applicationWindow
    //flags: Qt.FramelessWindowHint | Qt.Window

    title: "OffloadBuddy"
    width: 1280
    height: 720
    minimumWidth: 1280
    minimumHeight: 720
    visible: true
/*
    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Do nothing")
                onTriggered: console.log("Do nothing action triggered");
            }
            MenuItem {
                text: qsTr("&Exit")
                onTriggered: Qt.quit();
            }
        }
    }
*/

    property var currentDevicePtr

    Connections {
        target: jobManager
        onTrackedJobsUpdated: {
            if (button_jobs.visible === false && jobManager.trackedJobCount > 0) {
                button_jobs.visible = true
                button_jobs_fadein.start()
            }

            if (jobManager.workingJobCount > 0) {
                button_jobs_working.start()
            } else {
                button_jobs_working.stop()
                button_jobs_fadein.start()
            }
        }
    }

    Rectangle {
        id: sideBar
        width: 96
        color: ThemeEngine.colorSidebar
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        transformOrigin: Item.Center

        Rectangle {
            id: button_media
            width: 64
            height: 64
            color: "#00000000"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 16

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: content.state = "medias"
            }

            Image {
                id: image
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.left: parent.left
                anchors.bottom: parent.bottom
                anchors.top: parent.top
                source: "qrc:/resources/menus/media.svg"
            }
        }

        Rectangle {
            id: menuDevice
            color: "#00000000"

            anchors.bottom: button_settings.top
            anchors.bottomMargin: 16
            anchors.top: button_media.bottom
            anchors.topMargin: 16
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0

            ListView {
                id: devicesview
                interactive: false
                spacing: 16
                anchors.fill: parent

                model: deviceManager.devicesList
                delegate: ItemDeviceMenu {
                    myDevice: modelData
                    Component.onCompleted: {
                        myDeviceClicked.connect(sideBar.myDeviceClicked)
                    }
                }
            }
        }

        Rectangle {
            id: button_jobs
            width: 50
            height: 50
            color: "#00000000"
            anchors.bottom: button_settings.top
            anchors.bottomMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: content.state = "jobs"
            }
            Image {
                id: button_jobs_image
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "qrc:/resources/menus/jobs.svg"
                opacity: 0

                NumberAnimation on opacity {
                    id: button_jobs_fadein
                    running: false
                    from: button_jobs_image.opacity
                    to: 1
                    duration: 1000
                }

                SequentialAnimation on opacity {
                    id: button_jobs_working
                    running: false
                    loops: Animation.Infinite
                    OpacityAnimator { from: 0; to: 1; duration: 1000 }
                    OpacityAnimator { from: 1; to: 0; duration: 1000 }
                }
            }

            visible: false
        }

        Rectangle {
            id: button_settings
            width: 50
            height: 50
            color: "#00000000"
            anchors.bottom: button_about.top
            anchors.bottomMargin: 8
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: content.state = "settings"
            }
            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "qrc:/resources/menus/settings.svg"
            }
        }

        Rectangle {
            id: button_about
            width: 50
            height: 50
            color: "#00000000"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: button_exit.top
            anchors.bottomMargin: 8

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: content.state = "about"
            }
            Image {
                anchors.fill: parent
                source: "qrc:/resources/menus/about.svg"
            }
        }

        Rectangle {
            id: button_exit
            width: 50
            height: 50
            color: "#00000000"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 16

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
            }
            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "qrc:/resources/menus/exit.svg"
            }
        }

        Image {
            id: selectorArrow
            width: 12
            height: 12
            anchors.right: parent.right
            anchors.rightMargin: 0
            source: "qrc:/resources/menus/selector_arrow.svg"
        }
/*
        Image {
            id: selectorBar
            width: 4
            height: 40
            anchors.right: parent.right
            anchors.rightMargin: 0
            source: "qrc:/resources/menus/selector_bar.svg"
        }
*/
        signal myDeviceClicked(var devicePtr)
        onMyDeviceClicked: {
            if (typeof devicePtr !== "undefined") {
                //console.log(devicePtr + ' component was triggered')
                content.state = "device"
                screenDevice.myDevice = devicePtr
                currentDevicePtr = devicePtr // save current device
            }
        }

        Connections {
            target: deviceManager
            signal deviceRemoved(var devicePtr)
            onDeviceRemoved: {
                //console.log("deviceRemoved(" + devicePtr + ") and currentDevice(" + currentDevicePtr + ")")
                if (typeof devicePtr !== "undefined")
                    if (devicePtr === currentDevicePtr)
                        content.state = "medias"
            }
        }
    }

    ////////////////////////////////////////////////////////////////////////////

    Item {
        id: content

        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: sideBar.right
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        ScreenMedias {
            anchors.fill: parent
            id: screenMedias
        }
        ScreenDevice {
            anchors.fill: parent
            id: screenDevice
        }
        ScreenJobs {
            anchors.fill: parent
            id: screenJobs
            myJobs: jobManager
        }
        ScreenSettings {
            anchors.fill: parent
            id: screenSettings
        }
        ScreenAbout {
            anchors.fill: parent
            id: screenAbout
        }

        state: "medias"
        states: [
            State {
                name: "medias"

                PropertyChanges {
                    target: selectorArrow
                    anchors.verticalCenter: button_media.verticalCenter
                }
                PropertyChanges {
                    target: screenMedias
                    visible: true
                }
                PropertyChanges {
                    target: screenDevice
                    visible: false
                }
                PropertyChanges {
                    target: screenJobs
                    visible: false
                }
                PropertyChanges {
                    target: screenSettings
                    visible: false
                }
                PropertyChanges {
                    target: screenAbout
                    visible: false
                }
            },
            State {
                name: "device"

                PropertyChanges {
                    target: selectorArrow
                    anchors.verticalCenter: undefined
                }
                PropertyChanges {
                    target: screenMedias
                    visible: false
                }
                PropertyChanges {
                    target: screenDevice
                    visible: true
                }
                PropertyChanges {
                    target: screenJobs
                    visible: false
                }
                PropertyChanges {
                    target: screenSettings
                    visible: false
                }
                PropertyChanges {
                    target: screenAbout
                    visible: false
                }
            },
            State {
                name: "jobs"

                PropertyChanges {
                    target: selectorArrow
                    anchors.verticalCenter: button_jobs.verticalCenter
                }
                PropertyChanges {
                    target: screenMedias
                    visible: false
                }
                PropertyChanges {
                    target: screenDevice
                    visible: false
                }
                PropertyChanges {
                    target: screenJobs
                    visible: true
                }
                PropertyChanges {
                    target: screenSettings
                    visible: false
                }
                PropertyChanges {
                    target: screenAbout
                    visible: false
                }
            },
            State {
                name: "settings"

                PropertyChanges {
                    target: selectorArrow
                    anchors.verticalCenter: button_settings.verticalCenter
                }
                PropertyChanges {
                    target: screenMedias
                    visible: false
                }
                PropertyChanges {
                    target: screenDevice
                    visible: false
                }
                PropertyChanges {
                    target: screenJobs
                    visible: false
                }
                PropertyChanges {
                    target: screenSettings
                    visible: true
                }
                PropertyChanges {
                    target: screenAbout
                    visible: false
                }
            },
            State {
                name: "about"

                PropertyChanges {
                    target: selectorArrow
                    anchors.verticalCenter: button_about.verticalCenter
                }
                PropertyChanges {
                    target: screenMedias
                    visible: false
                }
                PropertyChanges {
                    target: screenDevice
                    visible: false
                }
                PropertyChanges {
                    target: screenJobs
                    visible: false
                }
                PropertyChanges {
                    target: screenSettings
                    visible: false
                }
                PropertyChanges {
                    target: screenAbout
                    visible: true
                }
            }
        ]
    }
}