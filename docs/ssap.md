# Introduction
This document defines version 1.0 of SSAP (secure startup application protocol). SSAP is intended to allow startup applications (applications that start when an user logs in, such as window managers) to start in a secure manner. This document as a side effect also describes password storage.
# When a user logs in
1. Password is verified.
2. Startup program list is loaded.
3. Startup programs are verified
4. Remaining startup programs start. (Highest priority to lowest, alphabetical order)
## Password verification
### First:
The password file for the user is loaded from ```userdir/.password```. This file should only be accessible for ring 0 code.<br> This file is formatted in json and is in the following format:<br>
```
{
	"salt":"example-salt",
	"hash":"90e89beb8395b182",
	"algorithm": {
		"name":"pbkdf2",
		"key-length":"8B",
		"iteration-count":"1000"
	}
}
```