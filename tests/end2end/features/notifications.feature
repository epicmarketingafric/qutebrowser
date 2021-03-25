# vim: ft=cucumber fileencoding=utf-8 sts=4 sw=4 et:

Feature: Notifications
    HTML5 notification API interaction

    Background:
        When I open data/javascript/notifications.html
        And I set content.notifications to true
        And I run :click-element id button

    @qtwebengine_notifications
    Scenario: Notification is shown
        When I run :click-element id show-button
        Then the javascript message "notification shown" should be logged
        And a notification with id 1 is presented

    @qtwebengine_notifications
    Scenario: Notification containing escaped characters
        Given the notification server supports body markup
        When I run :click-element id show-symbols-button
        Then the javascript message "notification shown" should be logged
        And notification 1 has body "&lt;&lt; &amp;&amp; &gt;&gt;"
        And notification 1 has title "<< && >>"

    @qtwebengine_notifications
    Scenario: Notification containing escaped characters with no body markup
        Given the notification server doesn't support body markup
        When I run :click-element id show-symbols-button
        Then the javascript message "notification shown" should be logged
        And notification 1 has body "<< && >>"
        And notification 1 has title "<< && >>"

    # As a WORKAROUND for https://www.riverbankcomputing.com/pipermail/pyqt/2020-May/042918.html
    # and other issues, those can only run with PyQtWebEngine >= 5.15.0
    #
    # For these tests, we need to wait for the notification to be shown before
    # we try to close it, otherwise we wind up in race-condition-ish
    # situations.

    @qtwebengine_notifications @pyqtwebengine>=5.15.0
    Scenario: Replacing existing notifications
        When I run :click-element id show-multiple-button
        Then the javascript message "i=1 notification shown" should be logged
        Then the javascript message "i=2 notification shown" should be logged
        Then the javascript message "i=3 notification shown" should be logged
        And 1 notification is presented
        And notification 1 has title "i=3"

    @qtwebengine_notifications @pyqtwebengine<5.15.0
    Scenario: Replacing existing notifications (old Qt)
        When I run :click-element id show-multiple-button
        Then the javascript message "i=1 notification shown" should be logged
        And "Ignoring notification tag 'counter' due to PyQt bug" should be logged
        And the javascript message "i=2 notification shown" should be logged
        And "Ignoring notification tag 'counter' due to PyQt bug" should be logged
        And the javascript message "i=3 notification shown" should be logged
        And "Ignoring notification tag 'counter' due to PyQt bug" should be logged
        And 3 notifications are presented
        And notification 1 has title "i=1"
        And notification 2 has title "i=2"
        And notification 3 has title "i=3"

    @qtwebengine_notifications @pyqtwebengine>=5.15.0
    Scenario: User closes presented notification
        When I run :click-element id show-button
        And I wait for the javascript message "notification shown"
        And I close the notification with id 1
        Then the javascript message "notification closed" should be logged

    @qtwebengine_notifications @pyqtwebengine<5.15.0
    Scenario: User closes presented notification (old Qt)
        When I run :click-element id show-button
        And I wait for the javascript message "notification shown"
        And I close the notification with id 1
        Then "Ignoring close request for notification 1 due to PyQt bug" should be logged
        And the javascript message "notification closed" should not be logged
        And no crash should happen

    @qtwebengine_notifications @pyqtwebengine>=5.15.0
    Scenario: User closes some other application's notification
        When I run :click-element id show-button
        And I wait for the javascript message "notification shown"
        And I close the notification with id 1234
        Then the javascript message "notification closed" should not be logged

    @qtwebengine_notifications @pyqtwebengine>=5.15.0
    Scenario: User clicks presented notification
        When I run :click-element id show-button
        And I wait for the javascript message "notification shown"
        And I click the notification with id 1
        Then the javascript message "notification clicked" should be logged

    @qtwebengine_notifications @pyqtwebengine<5.15.0
    Scenario: User clicks presented notification (old Qt)
        When I run :click-element id show-button
        And I wait for the javascript message "notification shown"
        And I click the notification with id 1
        Then "Ignoring click request for notification 1 due to PyQt bug" should be logged
        Then the javascript message "notification clicked" should not be logged
        And no crash should happen

    @qtwebengine_notifications @pyqtwebengine>=5.15.0
    Scenario: User clicks some other application's notification
        When I run :click-element id show-button
        And I wait for the javascript message "notification shown"
        And I click the notification with id 1234
        Then the javascript message "notification clicked" should not be logged
