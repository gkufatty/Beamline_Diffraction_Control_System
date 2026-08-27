import numpy as np
from matplotlib import pyplot as plt

plt.rcParams.update({
    "font.size": 14,
    "axes.titlesize": 18,
    "axes.labelsize": 16,
    "xtick.labelsize": 14,
    "ytick.labelsize": 14,
    "legend.fontsize": 14,
})

FILES = [f"results/samples{i}.npz" for i in range(4)]
LAMBDA = 650e-9

def calc_N(phi, phi0, m):
    n = ((2**0.5) * abs(np.sin(np.radians(phi - phi0))))/(abs(m)*LAMBDA)
    return n

def load_file(file):
    with np.load(file, allow_pickle=False) as archive:
        motor_positions = archive["motor_positions"]
        samples = archive["samples"]
    return motor_positions, samples

def find_spikes(
    motor_positions: np.ndarray,
    samples: np.ndarray,
    count: int = 3,
    deadband: float = 5,
) -> list[tuple[float, float]]:
    """Return the strongest local maxima separated by at least deadband."""
    local_maxima = np.flatnonzero(
        (samples[1:-1] > samples[:-2]) & (samples[1:-1] >= samples[2:])
    ) + 1
    candidates = local_maxima[np.argsort(samples[local_maxima])[::-1]]

    spikes: list[tuple[float, float]] = []
    for index in candidates:
        position = float(motor_positions[index])
        if all(abs(position - selected_position) >= deadband for selected_position, _ in spikes):
            spikes.append((position, float(samples[index])))
            if len(spikes) == count:
                break
    return spikes

data = map(load_file, FILES)

plt.figure()
Ns = []
for motor_positions, samples in data:
    spikes = find_spikes(motor_positions, samples)
    spike_angles = [position for position, _ in spikes]
    spike_angles.sort()
    Ns.append(calc_N(spike_angles[0], spike_angles[1], -1))
    Ns.append(calc_N(spike_angles[2], spike_angles[1], 1))

    plt.plot(motor_positions, samples * 1e9)

print(f"N = {np.mean(Ns)/1000:.03f} ± {np.std(Ns)/1000:.03f} lines/mm")

plt.title("Laser Diffraction Scan")
plt.xlabel("Motor Position (degrees)")
plt.ylabel("Current (nA)")
plt.show()
