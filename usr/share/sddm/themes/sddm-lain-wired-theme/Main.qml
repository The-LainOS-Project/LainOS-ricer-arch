// Import necessary modules for the QML file
import QtQuick 2.5
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4 as Qqc
import QtQuick.Controls.Styles 1.4
import QtQuick.Window 2.2
import QtMultimedia 5.5
import SddmComponents 2.0

Rectangle {
	// Main container for the login screen
	color: "black"
	width: Window.width
	height: Window.height

	// Connections to handle SDDM login events
	Connections {
		target: sddm

		onLoginSucceeded: {
			// Action when login succeeds
			// We could add log-in sound
		}

		onLoginFailed: {
			// Play denied sound on login failure
			denied.play()
		}
	}

	// Background image for the login screen
	AnimatedImage {
		width: parent.width
		height: parent.height
		fillMode: Image.Tile
		source: "bgN5.gif"
	}

	// Layout for the login form and other components
	ColumnLayout {
		width: parent.width
		height: parent.height

		// Logo or animation at the top
		AnimatedImage {
			Layout.alignment: Qt.AlignCenter
			Layout.topMargin: 2
			width: 192
			height: 192
			source: "WiredLogIn.gif"
		}

		// Label for the username field
		Qqc.Label {
			Layout.alignment: Qt.AlignCenter
			text: "User ID"
			color: "#5eeff5"
			font.family: ""
			font.pixelSize: 16
		}

		// Username input field
		Qqc.TextField {
			id: username
			Layout.alignment: Qt.AlignCenter
			text: userModel.lastUser
			style: TextFieldStyle {
				textColor: "#01013D"
				background: Rectangle {
					color: "#5eeff5"
					implicitWidth: 200
					border.color: "#5eeff5"
					radius: 15
				}
			}
			// Key navigation and login action
			KeyNavigation.backtab: shutdownBtn; KeyNavigation.tab: password
			Keys.onPressed: {
				if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
					sddm.login(username.text, password.text, session.index)
					event.accepted = true
				}
			}
		}

		// Label for the password field
		Qqc.Label {
			Layout.alignment: Qt.AlignCenter
			text: "Password"
			color: "#5eeff5"
			font.family: ""
			font.pixelSize: 16
		}

		// Password input field
		Qqc.TextField {
			id: password
			echoMode: TextInput.Password
			Layout.alignment: Qt.AlignCenter
			style: TextFieldStyle {
				textColor: "#01013D"
				background: Rectangle {
					color: "#5eeff5"
					implicitWidth: 200
					border.color: "#5eeff5"
					radius: 15
				}
			}
			// Key navigation and login action
			KeyNavigation.backtab: username; KeyNavigation.tab: session
			Keys.onPressed: {
				if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
					sddm.login(username.text, password.text, session.index)
					event.accepted = true
				}
			}
		}

		// Login button with label and mouse interaction
		ColumnLayout {
			Layout.alignment: Qt.AlignCenter
			Layout.topMargin: 4
			Layout.bottomMargin: 50
			width: 200
			Rectangle {
				anchors.fill: parent
				color: "#5eeff5"
				radius: 15
			}
			Qqc.Label {
				Layout.alignment: Qt.AlignCenter
				text: "Login"
				color: "#01013D"
				font.pixelSize: 20
			}
			MouseArea {
				anchors.fill: parent
				onClicked: sddm.login(username.text, password.text, session.index)
			}
		}
	}

	// Shutdown button with tooltip
	AnimatedImage {
		id: shutdownBtn
		height: 80
		width: 80
		y: 10
		x: Window.width - width - 10
		source: "VisLain.gif"
		fillMode: Image.PreserveAspectFit
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: sddm.powerOff()
			onEntered: {
				var component = Qt.createComponent("ShutdownToolTip.qml");
				if (component.status == Component.Ready) {
					var tooltip = component.createObject(shutdownBtn);
					tooltip.x = -45
					tooltip.y = 60
					tooltip.destroy(600);
				}
			}
		}
	}

	// Reboot button with tooltip
	AnimatedImage {
		id: rebootBtn
		anchors.right: shutdownBtn.left
		anchors.rightMargin: 5
		y: shutdownBtn.y + 10
		height: 70
		width: 60
		source: "lain_myese.gif"
		fillMode: Image.PreserveAspectFit
		MouseArea {
			anchors.fill: parent
			hoverEnabled: true
			onClicked: sddm.reboot()
			onEntered: {
				var component = Qt.createComponent("RebootToolTip.qml");
				if (component.status == Component.Ready) {
					var tooltip = component.createObject(rebootBtn);
					tooltip.x = -45
					tooltip.y = 50
					tooltip.destroy(600);
				}
			}
		}
	}

	// Session selection dropdown
	ComboBox {
		id: session
		height: 30
		width: 200
		x: 15
		y: 20
		// radius: 15
		model: sessionModel
		index: sessionModel.lastIndex
		color: "#000"
		borderColor: "#3d3b93"
		focusColor: "#3d3b93"
		hoverColor: "#3d3b93"
		textColor: mouseArea.containsMouse ? "#01013d" : "#533ff5"
		KeyNavigation.backtab: password; KeyNavigation.tab: rebootBtn;
		MouseArea {
			id: mouseArea
			anchors.fill: parent
			hoverEnabled: true
			acceptedButtons: Qt.NoButton
			onClicked: {
				session.forceActiveFocus();
				session.popup.visible = true;
			}
		}
	}
	// Background music and sound effects
	Audio {
		id: bgMusic
		source: "bg_music.wav"
		autoPlay: true
		loops: Audio.Infinite
	}
	Audio {
		id: welcome
		source: "welcome.wav"
		autoPlay: true
	}
	Audio {
		id: denied
		source: "denied.wav"
	}

	// Focus logic for username and password fields
	Component.onCompleted: {
		if (username.text == "") {
			username.focus = true
		} else {
			password.focus = true
		}
	}
}

