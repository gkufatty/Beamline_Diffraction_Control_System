# Beamline Diffraction Control System

EPICS-based control system for a laser diffraction beamline experiment. The setup rotates a diffraction grating through a laser beam with a motorized stage, measures the diffracted light intensity with a picoammeter, and monitors the sample with a camera — all coordinated over EPICS process variables (PVs). A Python client automates the scan and analyzes the results to calculate the grating's line density.

## How it works

A laser is aimed through a diffraction grating mounted on a rotation stage. As the stage sweeps through a range of angles, a Keithley picoammeter measures the photocurrent produced by the diffracted light hitting a detector. The angles where the current spikes correspond to diffraction orders, and the spacing between those peaks is used to calculate the grating's line density (lines/mm) from the diffraction equation.

Each piece of hardware runs as its own EPICS IOC (Input/Output Controller), so the whole experiment can be driven and monitored through standard EPICS tools (Channel Access / pvAccess) and the operator screens included in this repo.

## Repository layout

- **`Keithley/`** — EPICS IOC (via StreamDevice) for a Keithley 6430 picoammeter. Reads the diffracted-light current and lets the current range be configured.
- **`Motor/smarActIOC/`** — EPICS motor IOC for SmarAct motor controllers (MCS/MCS2/SCU), used to rotate the grating/sample stage through the scan angles.
- **`laser/`** — EPICS IOC for a Raspberry Pi, controlling the laser diode (on/off) and status LEDs (off / on / slow blink / fast blink) over GPIO/PWM.
- **`camera-control/`** — EPICS IOC (via StreamDevice over HTTP) for adjusting an Axis network camera's image settings (sharpness, brightness, contrast, exposure, etc.) used to monitor the sample.
- **`image-acquisition/`** — EPICS areaDetector IOC (URL driver) for pulling images from the monitoring camera into the EPICS image-processing pipeline.
- **`OPIs/`** — Operator screens (Phoebus/CS-Studio `.bob`/`.opi` files) for the motor, ammeter, camera settings, image acquisition/areaDetector plugins, and laser/LED control.
- **`PythonExperiment/`** — Python client that runs the automated scan and analyzes the results:
  - `src/acquire.py` drives the laser, motor, and picoammeter over pvAccess/Channel Access (`p4p`, `pyepics`), sweeping the stage through a set of angles and recording the measured current at each position. Results are saved to `results/samplesN.npz`.
  - `src/analyze.py` loads the saved scans, finds the diffraction peaks, and computes the grating's line density (lines/mm) from the peak spacing, plotting the scan traces.

## Requirements

- An EPICS base installation to build and run the IOCs (each IOC directory is a standard EPICS application with its own `configure/` and `Makefile`).
- Phoebus/CS-Studio (or another EPICS OPI viewer) to open the screens in `OPIs/`.
- Python 3.14+ with `p4p`, `pyepics`, `numpy`, and `matplotlib` to run `PythonExperiment/` (managed with [uv](https://github.com/astral-sh/uv); see `PythonExperiment/pyproject.toml`).

## Running a scan

1. Build and start each hardware IOC (Keithley, motor, laser, camera-control, image-acquisition).
2. Open the relevant screens under `OPIs/` to verify the hardware is connected and behaving as expected.
3. From `PythonExperiment/`, run `uv run src/acquire.py` to sweep the motor and record the picoammeter readings.
4. Run `uv run src/analyze.py` to plot the scan and print the calculated line density.

