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

PROD_IOC = streamloc
# streamloc.dbd will be created and installed
DBD += streamloc.dbd

# streamloc.dbd will be made up from these files:
streamloc_DBD += base.dbd
streamloc_DBD += stream.dbd
streamloc_DBD += drvAsynIPPort.dbd

streamloc_DBD+= qsrv.dbd PVAServerRegister.dbd

# Include dbd files from all support applications:
#streamloc_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
streamloc_LIBS += asyn stream qsrv $(EPICS_BASE_PVA_CORE_LIBS)

# streamloc_registerRecordDeviceDriver.cpp derives from streamloc.dbd
streamloc_SRCS += streamloc_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
streamloc_SRCS_DEFAULT += streamlocMain.cpp
streamloc_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#streamloc_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
streamloc_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

