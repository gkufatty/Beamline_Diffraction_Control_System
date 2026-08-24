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
asynLaserConfigure("$(LASER_PORT)", 1, 1) # PWM Pin 1

## Load record instances
dbLoadRecords("db/laser.db","P=LaserDiffraction, R=Laser, PORT=$(LASER_PORT)")

cd "${TOP}/iocBoot/${IOC}"
iocInit

## Start any sequence programs
#seq sncxxx,"user=pi"
