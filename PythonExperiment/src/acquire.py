from p4p.client.thread import Context
import numpy as np
import sys
from time import sleep
from matplotlib import pyplot as plt
import epics

RED_LED_PV = "LaserDiffraction:RedLED:Mode"
YELLOW_LED_PV = "LaserDiffraction:YellowLED:Enable"
LASER_ENA_PV = "LaserDiffraction:Laser:Enable"
LASER_VAL_PV = "LaserDiffraction:Laser:Value"

MOTOR_MIN = -40
MOTOR_MAX = 5
MOTOR_STEP = 5
MOTOR_SPEED = 30
MOTOR_PV = "SMARACT:m1"
MOTOR_SPEED_PV = "SMARACT:m1.VELO"

AMPS_PV = "LaserDiffraction:Keithley:meas-curr"

SLEEP_TIME = 6

motor_positions = [ 1.2, 2.2, 3.2, -17.2, -18.2, -19.2, -37.6, -38.6, -39.6]
motor_positions.extend(range(MOTOR_MIN, MOTOR_MAX + 1, MOTOR_STEP))
motor_positions.sort()

if __name__ != "__main__":
    print("This script is intended to be run as a standalone program, not imported as a module.", file=sys.stderr)
    sys.exit(1)

pva = Context('pva')

for idx in range(4):
    print("Starting laser diffraction scan...")
    pva.put(RED_LED_PV, 2) # Slow Blink
    pva.put(YELLOW_LED_PV, 0)
    pva.put(LASER_ENA_PV, 1)
    pva.put(LASER_VAL_PV, 1)
    epics.caput(MOTOR_PV, MOTOR_MIN)
    epics.caput(MOTOR_SPEED_PV, 10 * MOTOR_SPEED)
    sleep(2 * SLEEP_TIME)
    epics.caput(MOTOR_SPEED_PV, MOTOR_SPEED)

    samples: list[float] = []

    for motor_pos in motor_positions:
        print(f"Scanning motor in {motor_pos}°...", end="")
        epics.caput(MOTOR_PV, motor_pos)
        sleep(SLEEP_TIME)
        samples.append(pva.get(AMPS_PV))
        print(f"{1e9 * samples[-1]} nA")

    pva.put(RED_LED_PV, 0)
    pva.put(LASER_ENA_PV, 0)

    np.savez(
        f"results/samples{idx}.npz",
        motor_positions=np.asarray(motor_positions, dtype=np.float64),
        samples=np.asarray(samples, dtype=np.float64),
    )
    print(f"Finished experiment {idx}")
