#include "asynPortDriver.h"
#include "epicsTypes.h"

#define P_ValueString "VALUE"

static const int LASER_PWM_RANGE = 1024;

class asynGPiO : public asynPortDriver {
public:
    asynGPiO(const char *portName, const int gpioPin, const int usePwm);
    ~asynGPiO();

    virtual asynStatus writeFloat64(asynUser *pasynUser, epicsFloat64 value);

private:
    const int gpioPin;
    const int usePwm;
    int P_Value;
};
