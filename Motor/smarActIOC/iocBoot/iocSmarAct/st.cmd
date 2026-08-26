#!../../bin/linux-x86_64/smarAct

< envPaths
epicsEnvSet("P", "SMARACT:")
epicsEnvSet("MC_CT", "unit1")

cd "${TOP}"

## Register all support components
dbLoadDatabase "dbd/smarAct.dbd"
smarAct_registerRecordDeviceDriver pdbbase

cd "${TOP}/iocBoot/${IOC}"

## motorUtil (allstop & alldone)
dbLoadRecords("$(MOTOR)/db/motorUtil.db", "P=SMARACT:")

# Uncomment one of the following lines for MCS or MCS2 controller
< smaractmcs.iocsh
#< smaractmcs2.iocsh
#< smaractscu.iocsh
## 
# Optional: load devIocStats records (requires DEVIOCSTATS module)
#dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminSoft.db", "IOC=$(P)$(MC_CT)")

iocInit

## motorUtil (allstop & alldone)
motorUtilInit("SMARACT:")

# Boot complete
