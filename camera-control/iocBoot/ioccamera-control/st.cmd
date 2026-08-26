#!../../bin/linux-x86_64/camera-control

#- SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS

#- You may have to change camera-control to something else
#- everywhere it appears in this file

< envPaths

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/camera-control.dbd"
camera_control_registerRecordDeviceDriver pdbbase

epicsEnvSet "STREAM_PROTOCOL_PATH" "$(TOP)/db"
epicsEnvSet "PORT" "portname"
drvAsynIPPortConfigure "$(PORT)", "epicsss-axiscamera-01.cslab.esss.lu.se:80 HTTP"
dbLoadRecords("db/cameracontrol.db","P=LaserDiffraction,R=CameraControl,PORT=$(PORT)")

set_requestfile_path("$(TOP)/db")
set_savefile_path("$(TOP)/db")
set_pass0_restoreFile("cameracontrol.sav", "P=LaserDiffraction,R=CameraControl")
set_pass1_restoreFile("cameracontrol.sav", "P=LaserDiffraction,R=CameraControl")
save_restoreSet_NumSeqFiles(0)

## Load record instances
#dbLoadRecords("db/camera-control.db","user=epicsstudent")

cd "${TOP}/iocBoot/${IOC}"
iocInit

create_monitor_set("cameracontrol.req", 5, "P=LaserDiffraction,R=CameraControl")
## Start any sequence programs
#seq sncxxx,"user=epicsstudent"
