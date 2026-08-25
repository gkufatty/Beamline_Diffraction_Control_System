#include "asynGPiO.hpp"
#include "wiringPi.h"
#include "epicsString.h"

#include <iocsh.h>
#include <epicsExport.h>

static const char *driverName="asynGPiO";

asynGPiO::asynGPiO(const char *portName, const int gpioPin, const int usePwm)
    : asynPortDriver(portName, 1,
                     asynInt32Mask | asynFloat64Mask | asynDrvUserMask,
                     asynInt32Mask | asynFloat64Mask,
                     0, 1, 0, 0), gpioPin(gpioPin), usePwm(usePwm) {

    wiringPiSetup();

    if (usePwm) {
        pinMode(gpioPin, PWM_OUTPUT);
        pwmSetRange(LASER_PWM_RANGE);
        pwmSetMode(PWM_MODE_MS);
        pwmSetClock(375);
        pwmWrite(gpioPin, 0);
    } else {
        pinMode(gpioPin, OUTPUT);
        digitalWrite(gpioPin, 0);
    }

    createParam(P_ValueString, asynParamFloat64, &P_Value);
    setDoubleParam(P_Value, 0);

}

asynGPiO::~asynGPiO() = default;

asynStatus asynGPiO::writeFloat64(asynUser *pasynUser, epicsFloat64 value) {
    int function = pasynUser->reason;
    asynStatus status = asynSuccess;
    const char *functionName = "writeFloat64";
    const char *paramName;

    status = setDoubleParam(function, value);
    getParamName(function, &paramName);

    if (function == P_Value) {
        setDoubleParam(P_Value, value);

        if (this->usePwm) {
            double dc = static_cast<double>(LASER_PWM_RANGE) * value;
            pwmWrite(this->gpioPin, static_cast<int>(dc));
        } else {
            digitalWrite(this->gpioPin, (value != 0));
        }
    } else { }

    // Read logic
    status = (asynStatus) callParamCallbacks();

    if (status)
        epicsSnprintf(pasynUser->errorMessage, pasynUser->errorMessageSize,
                  "%s:%s: status=%d, function=%d, name=%s, value=%f",
                  driverName, functionName, status, function, paramName, value);
    else
        asynPrint(pasynUser, ASYN_TRACEIO_DRIVER,
              "%s:%s: function=%d, name=%s, value=%f\n",
              driverName, functionName, function, paramName, value);

    return status;
}

extern "C" {

    int asynGPiOConfigure(const char *portName, const int gpioPin, const int usePwm)
    {
        new asynGPiO(portName, gpioPin, usePwm);
        return(asynSuccess);
    }


    /* EPICS iocsh shell commands */

    static const iocshArg initArg0 = { "portName",iocshArgString};
    static const iocshArg initArg1 = { "gpioPin",iocshArgInt};
    static const iocshArg initArg2 = { "usePwm",iocshArgInt};

    static const iocshArg * const initArgs[] = {&initArg0, &initArg1, &initArg2};
    static const iocshFuncDef initFuncDef = {"asynGPiOConfigure",3,initArgs};
    static void initCallFunc(const iocshArgBuf *args) {
        asynGPiOConfigure(args[0].sval, args[1].ival, args[2].ival);
    }

    void asynGPiORegister(void) {
        iocshRegister(&initFuncDef,initCallFunc);
    }

    epicsExportRegistrar(asynGPiORegister);

}
