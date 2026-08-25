#!../../bin/darwin-aarch64/streamloc

#- SPDX-FileCopyrightText: 2005 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS

#- You may have to change streamloc to something else
#- everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "../../dbd/streamloc.dbd"
streamloc_registerRecordDeviceDriver(pdbbase) 

epicsEnvSet "STREAM_PROTOCOL_PATH", "$(TOP)/db"
epicsEnvSet PORT port

# drvAsynIPPortConfigure "$(PORT)", "localhost:5555"
# dbLoadRecords("$(TOP)/db/stream.db", "P=gk:, PORT=port")
drvAsynIPPortConfigure "port", "ics-lab-moxa.cslab.esss.lu.se:4001"

dbLoadRecords("$(TOP)/db/stream.db", "P=gk:, PORT=port")
## Load record instances
#dbLoadRecords("../../db/streamloc.db","user=gk")

iocInit()

## Start any sequence programs
#seq sncstreamloc,"user=gk"
