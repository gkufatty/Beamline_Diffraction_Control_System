#include "asynLaser.hpp"
#include "wiringPi.h"

static const char *driverName="asynLaser";

asynLaser::asynLaser(const char *portName)
    : asynPortDriver(portName, 1,
                     asynInt32Mask | asynFloat64Mask | asynDrvUserMask,
                     asynInt32Mask | asynFloat64Mask,
                     ASYN_MULTIDEVICE, 1, 0, 0) {

    wiringPiSetup();
    pinMode(LASER_PIN, PWM_OUTPUT);
    pwmSetRange(LASER_PWM_RANGE);

    createParam(P_DutyCycleString, asynParamFloat64, &P_DutyCycle);
    setDoubleParam(P_DutyCycle, 0);
    pwmWrite(LASER_PIN, 0);
}

asynLaser::~asynLaser() = default;

asynStatus asynLaser::writeFloat64(asynUser *pasynUser, epicsFloat64 value) {
    int function = pasynUser->reason;
    asynStatus status = asynSuccess;
    const char *functionName = "writeFloat64";
    const char *paramName;

    status = setDoubleParam(function, value);
    getParamName(function, &paramName);

    if (function == P_DutyCycle) {
        setDoubleParam(P_DutyCycle, value);
        double dc = static_cast<double>(LASER_PWM_RANGE) * value;

        pwmWrite(LASER_PIN, static_cast<int>(dc));
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