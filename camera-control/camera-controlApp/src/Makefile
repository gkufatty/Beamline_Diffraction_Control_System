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

PROD_IOC = camera-control
# camera-control.dbd will be created and installed
DBD += camera-control.dbd

# camera-control.dbd will be made up from these files:
camera-control_DBD += base.dbd
camera-control_DBD += stream.dbd drvAsynIPPort.dbd
camera-control_DBD += qsrv.dbd PVAServerRegister.dbd

# Include dbd files from all support applications:
#camera-control_DBD += xxx.dbd

# Add all the support libraries needed by this IOC
camera-control_LIBS += stream asyn qsrv $(EPICS_BASE_PVA_CORE_LIBS)

# camera-control_registerRecordDeviceDriver.cpp derives from camera-control.dbd
camera-control_SRCS += camera-control_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
camera-control_SRCS_DEFAULT += camera-controlMain.cpp
camera-control_SRCS_vxWorks += -nil-

# Add support from base/src/vxWorks if needed
#camera-control_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
camera-control_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
