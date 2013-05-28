p4ftp
=====

A little Windows Batch Script to upload a Perforce ChangeList from console to a FTP host 

First argument is the change list number, and is mandatory.   
Second argument is an optional "1" flag, indicating no confirmation is desired.

Usage 
------

#### From console   
    p4ftp.bat <cl> [1]

#### From perforce visual client, p4v    
* Tools > Manage Custom Tools
* click on New Tool
* fill in data
* under Arguments write "%C 1" (case sensitive, must be an uppercase c, followed by a white space and the flag one)

Limitations
------
- works only for straight-forward mappings
- directory structure must already exist on the server, this script doesn't create the folders

On Build Failure: http://buildfailure.wordpress.com/2013/05/19/windows-batch-script-ftp-upload-a-perforce-changelist/
