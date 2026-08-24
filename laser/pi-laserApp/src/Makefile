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

PROD_IOC = pi-laser
# pi-laser.dbd will be created and installed
DBD += pi-laser.dbd

# pi-laser.dbd will be made up from these files:
pi-laser_DBD += base.dbd

# Include dbd files from all support applications:
#pi-laser_DBD += xxx.dbd

pi-laser_LIBS += asyn
pi-laser_SYS_LIBS += wiringPi

# pi-laser_registerRecordDeviceDriver.cpp derives from pi-laser.dbd
pi-laser_SRCS += pi-laser_registerRecordDeviceDriver.cpp

# Build the main IOC entry point on workstation OSs.
pi-laser_SRCS_DEFAULT += pi-laserMain.cpp
pi-laser_SRCS_vxWorks += -nil-

pi-laser_SRCS += asynLaser.cpp

# Add support from base/src/vxWorks if needed
#pi-laser_OBJS_vxWorks += $(EPICS_BASE_BIN)/vxComLibrary

# Finally link to the EPICS Base libraries
pi-laser_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE
