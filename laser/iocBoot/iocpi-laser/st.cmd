#!../../bin/linux-aarch64/pi-laser

#- SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS

#- You may have to change pi-laser to something else
#- everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/pi-laser.dbd"
pi_laser_registerRecordDeviceDriver pdbbase

epicsEnvSet("LASER_PORT", "asynLaser")
asynGPiOConfigure("$(LASER_PORT)", 1, 1) # WPi Pin 1 (GPIO 19)
dbLoadRecords("db/GPiO.db","P=LaserDiffraction, R=Laser, PORT=$(LASER_PORT)")

epicsEnvSet("RED_PORT", "asynRed")
asynGPiOConfigure("$(RED_PORT)", 25, 0) # WPi Pin 25 (GPIO 26)
dbLoadRecords("db/BlinkingLEDs.db","P=LaserDiffraction, R=RedLED, PORT=$(RED_PORT)")

epicsEnvSet("GREEN_PORT", "asynGreen")
asynGPiOConfigure("$(GREEN_PORT)", 7, 0) # WPi Pin 7 (GPIO 4)
dbLoadRecords("db/BlinkingLEDs.db","P=LaserDiffraction, R=GreenLED, PORT=$(GREEN_PORT)")

epicsEnvSet("YELLOW_PORT", "asynYellow")
asynGPiOConfigure("$(YELLOW_PORT)", 24, 1) # WPi Pin 24 (GPIO 19)
dbLoadRecords("db/GPiO.db","P=LaserDiffraction, R=YellowLED, PORT=$(YELLOW_PORT)")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=pi"
