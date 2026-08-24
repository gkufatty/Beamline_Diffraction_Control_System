#include "asynPortDriver.h"
#include "epicsTypes.h"

#define P_DutyCycleString "DUTY_CYCLE"

static const int LASER_PIN = 1;
static const int LASER_PWM_RANGE = 1024;

class asynLaser : public asynPortDriver {
public:
    asynLaser(const char *portName);
    ~asynLaser();

    // virtual asynStatus readInt32(asynUser *pasynUser, epicsInt32 *value);
    // virtual asynStatus readFloat32(asynUser *pasynUser, epicsFloat32 *value);

    virtual asynStatus writeFloat64(asynUser *pasynUser, epicsFloat64 value);

private:
    int P_DutyCycle;
};
