#!/bin/bash

/opt/dell/toolkit/bin/syscfg --AcPwrRcvry=On
/opt/dell/toolkit/bin/syscfg --AcPwrRcvryDelay=random
/opt/dell/toolkit/bin/syscfg --SerialComm=onconredircom2
/opt/dell/toolkit/bin/syscfg --SerialPortAddress=serial1com1serial2com2
/opt/dell/toolkit/bin/syscfg --ExtSerialConnector=serial1
/opt/dell/toolkit/bin/syscfg --FailSafeBaud=115200
/opt/dell/toolkit/bin/syscfg --ConTermType=vt100vt220
/opt/dell/toolkit/bin/syscfg --RedirAfterBoot=disable
/opt/dell/toolkit/bin/syscfg --extserial=com1
/opt/dell/toolkit/bin/syscfg --SysProfile=perfoptimized
