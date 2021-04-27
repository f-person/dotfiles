#!/usr/bin/python3
import time
import easygui

title = "Take care about your eyes <3"
body = """It's time to take a break
Click 'OK' when you are back"""

while True:
    print("Started counting at", time.ctime())
    time.sleep(60 * 52)  # 21 minutes
    easygui.msgbox(body, title)

