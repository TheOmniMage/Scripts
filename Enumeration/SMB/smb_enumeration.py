#!/bin/env python3

#Enumerate over smb on fin
import os
from getpass import getpass
import subprocess
from subprocess import PIPE

#file = open('/home/kali/Documents/Engagements/MFE_11_2021/Notes/targets_2.txt', 'r')
#file = file.readlines()
#file = file.rstrip()
#file.close()

with open('/home/kali/Documents/Engagements/MFE_11_2021/Notes/targets_2.txt', 'r') as file:
    for line in file:
        Target_list = file.read()

Target_list = Target_list.rstrip()
Target_list = Target_list.split()
#print(Target_list)
user_name = input('Enter Username with domain\n')
pw = getpass('Enter Password\n') #Hides password on entry
file_out = open('/home/kali/Documents/Engagements/MFE_11_2021/Notes/smb_out.txt', "a")
for line in Target_list:
    text = user_name + ':' + pw + '@' + line #write arguments for smbclient.py - subprocess didn't like my arguments on the line itself
    print('[+] '+ line + '\n')
    file_out.write('\n\n')
    file_out.write(line)
    file_out.write('\n\n')
    file_out.flush() #this makes it so that subprocess writes in the correct order, otherwise it puts all stdout from smbclient above all the share names
    p = subprocess.Popen(['smbclient.py', text], stdin=PIPE,stdout=file_out) #allows automated interaction with prompt - writes share info to file
    p.stdin.write(b"shares\nexit") #had to newline this as I can't find a multi-line solution
    p.communicate()

    '''
    To-do:
    Add argparse or something for cli argument implimentation
    make user_name/pw/file_out/file editable by argument
    have stdout from smbclient.py pipe into a variable, turn variable into list, enumerate through list to determine read/write access to share and output 
    info to stdout/file
    '''
