/* === This file is part of Calamares - <https://calamares.io> ===
 *
 *   SPDX-FileCopyrightText: 2015 Teo Mrnjavac <teo@kde.org>
 *   SPDX-FileCopyrightText: 2018 Adriaan de Groot <groot@kde.org>
 *   SPDX-License-Identifier: GPL-3.0-or-later
 *
 *   Calamares is Free Software: see the License-Identifier above.
 *
 */

import QtQuick 2.15
import calamares.slideshow 1.0

Presentation {
	id: presentation

	Timer {
		interval: 8000
		running: presentation.activatedInCalamares
		repeat: true
		onTriggered: presentation.goToNextSlide()
	}

	Slide {
		Rectangle { anchors.fill: parent; color: "#0b0d1a" }
		Column {
			anchors.centerIn: parent
			width: parent.width * 0.8
			spacing : 18
			Image {
				source: "logo.png"
				width: 180; height: 180
				fillMode: Image.PreserveAspectFit
				anchors.horizontalCenter: parent.horizontalCenter
			}
			Text {
				width: parent.width
				text: qsTr("Welcome to AuricOS")
				color: "#f2c94c"; font.family: "Inter"; font.pixelSize: 30; font.bold: true
				horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
				
			}
		}
	}

	Slide {
		Rectangle { anchors.fill: parent; color: "#0b0d1a" }
		Image {
			anchors.fill: parent
			source: "SLIDE_1.jpg"
			fillMode: Image.PreserveAspectCrop
			smooth: true
			visible: slide2.visible
		}
	}

	Slide {
		Rectangle { anchors.fill: parent; color: "#0b0d1a" }
		Image {
			anchors.fill: parent
			source: "SLIDE_2.jpg"
			fillMode: Image.PreserveAspectCrop
			smooth: true
			visible: slide3.visible
		}
	}

	Slide {
		Rectangle { anchors.fill: parent; color: "#0b0d1a" }
		Image {
			anchors.fill: parent
			source: "SLIDE_3.jpg"
			fillMode: Image.PreserveAspectCrop
			smooth: true
			visible: slide3.visible
		}
	}

	Slide {
		Rectangle { anchors.fill: parent; color: "#0b0d1a" }
		Column {
			anchors.centerIn: parent
			width: parent.width * 0.8
			spacing: 18
			Text {
				width: parent.width
				text: qsTr("Built by Stlwtrs (Zach White)")
				color: "#f2c94c"; font.family: "Inter"; font.pixelSize: 30; font.bold: true
				horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
			}
			Rectangle {width: 80; height: 3; color: "#f2c94c"; anchors.horizontalCenter: parent.horizontalCenter }
			Text {
				width: parent.width
				text: qsTr("AuricOS is an open-source project. Follow along at github.com/Stlwtrs")
				color: "#e8dcc0"; font.family: "Inter"; font.pixelSize: 17
				horizontalAlignment: Text.AlignHCenter; wrapMode: Text.WordWrap
			}
		}
	}

	function onActivate() { presentation.currentSlide = 0 }
	function onLeave() { }
			
}           
