# Introducing vpnauto
An AppleScript to automate connecting VPN by using SofToken(SecurID). This script was based on http://coreygilmore.com/projects/automated-securid-token-generation-and-vpn-login-applescript/. Thanks to Corey Gilmore.

## How Do I Use It?
Check out the code using git, modify a little bit for your own VPN configuration, save it as an application in AppleScript Editor. Have fun.

Here is the command to clone the code:

    git clone git@github.com:nicoster/vpnauto.git

You need to change the following lines, see comments for their purpose:

    set theConnection to "<VPN Connection Name>"  -- change to your VPN connection name
    set thePin to "" -- set to "" to prompt every time (recommended)

You might need connect ADSL before you connect the VPN. If it is the case, modify the following line, the script will take care of it for you.

    set theADSL to "<ADSL Connection Name>" -- if theADSL is not null, will try to connect ADSL first

You could get the 'VPN Connection Name' or 'ADSL Connection Name' from the 'System Preferences'/Network panel.

## Bug Report
If you found any bugs, file a report here.

## Changelog
* _Mar. 2012_ 
	* First Release


## Credits
@nicoster

##License
(The MIT License)

Copyright © 2012 Nick Xiao

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

