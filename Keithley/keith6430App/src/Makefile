# SPDX-FileCopyrightText: 2003 Argonne National Laboratory
#
# SPDX-License-Identifier: EPICS

TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build the IOC application

PROD_IOC = keith6430
# keith6430.dbd will be created and installed
DBD += keith6430.dbd

# keith6430.dbd will be made up from these files:
keith6430_DBD += base.dbd
keith6430_DBD += stream.dbd
keith6430_DBD += drvAsynIPPort.dbd

keith6430_DBD+= qsrv.dbd PVAServerRegister.dbd

# Include dbd files from all support applications:
#keith6430_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
keith6430_LIBS += asyn stream qsrv $(EPICS_BASE_PVA_CORE_LIBS)

# keith6430_registerRecordDeviceDriver.cpp derives from keith6430.dbd
keith6430_SRCS += keith6430_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
keith6430_SRCS_DEFAULT += keith6430Main.cpp
keith6430_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#keith6430_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
keith6430_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

