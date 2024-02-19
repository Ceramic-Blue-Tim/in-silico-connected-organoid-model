# In-silico connected organoids

## Overview

Emulation of human cerebral organoids reciprocally connected with axons on Matlab using Hodgkin-Huxley neurons and conductance-based synapses.

_Maintainers_: Timothée Lévi (timothee.levi@u-bordeaux.fr)
_Authors_: Romain Beaubois (rbeaubois@u-bordeaux.fr)

## Features

| Features          | Details       |
|-------------------|---------------|
| **Neurons**       | FS, RS        |
| **Synapses**      | AMPA, NMDA, GABAa, GABAb |

## Getting started

### Usage

1. Set parameters of the emulation in `sim_organoid.m` in parameters section.

```matlab
%% Parameters #########################################
    % Time
        dt              = 2^-5; % ms - Time step
        sim_time        = 5e3;  % ms - Simulation time

    % ...
% #####################################################
```

2. Run `sim_organoid.m`

### Documentation

Additional documentation is available in ```docs/```.

### Issues and Contributing

In case you find any issues that have not been reported yet, don't hesitate to open a new issue here on Github or consider contacting the maintainers.

### Repository structure

* **docs** : Documentation and figures
* **src** : Matlab sources

## Licensing

This project is licensed under GPLv3.

`SPDX-License-Identifier: GPL-3.0-or-later`

<!-- ## Publication

If you use this work, you can cite us:

<details>
<summary>Organoid publication</summary>
<p>

```
@article{tofill,
  title={tofill},
  author={tofill},
  journal={tofill},
  volume={tofill},
  number={tofill},
  pages={tofill},
  year={tofill},
  publisher={tofill}
}
```
</p>
</details> -->

## Special thanks

* **Farad Khoyratee** for sharing the emulation sources for HH neurons and synapses
  * Optimized Real-Time Biomimetic Neural Network on FPGA for Bio-hybridization ([DOI](https://doi.org/10.3389/fnins.2019.00377))
* **Tatsuya Osaki** for his contribution to the parameters of the modeling