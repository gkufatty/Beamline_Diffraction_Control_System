#include "asynPortDriver.h"
#include "epicsTypes.h"

#define P_ValueString "VALUE"

static const int LASER_PWM_RANGE = 1024;

class asynLaser : public asynPortDriver {
public:
    asynLaser(const char *portName, const int gpioPin, const int usePwm);
    ~asynLaser();

    virtual asynStatus writeFloat64(asynUser *pasynUser, epicsFloat64 value);

private:
    const int gpioPin;
    const int usePwm;
    int P_Value;
};
