#!../../bin/linux-x86_64/keith6430

#- SPDX-FileCopyrightText: 2005 Argonne National Laboratory
#-
#- SPDX-License-Identifier: EPICS

#- You may have to change keith6430 to something else
#- everywhere it appears in this file

< envPaths

## Register all support components
dbLoadDatabase "../../dbd/keith6430.dbd"
keith6430_registerRecordDeviceDriver(pdbbase) 

epicsEnvSet "STREAM_PROTOCOL_PATH", "$(TOP)/db"
epicsEnvSet PORT port

# drvAsynIPPortConfigure "$(PORT)", "localhost:5555"
# dbLoadRecords("$(TOP)/db/stream.db", "P=ess:, PORT=port")
drvAsynIPPortConfigure "port", "ics-lab-moxa.cslab.esss.lu.se:4001"

dbLoadRecords("$(TOP)/db/stream.db", "P=LaserDiffraction, R=Keithley, PORT=port")
## Load record instances
#dbLoadRecords("../../db/keith6430.db","user=ess")

iocInit()

## Start any sequence programs
#seq snckeith6430,"user=ess"
