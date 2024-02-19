# Neuronal network configuration

## Computational basis

The emulation is based on the scripts of the work: Optimized Real-Time Biomimetic Neural Network on FPGA for Bio-hybridization ([DOI](https://doi.org/10.3389/fnins.2019.00377))

## Generates neurons position in a XY 

Spatial position to each neuron is added to allow synaptic connection rules based on distance between neurons. Neurons are generated to fill a disk of a given size representating the organoid with a keepout between each neuron.


![Organoid_750](img/org750u_neur15u_N2588.png)
> Organoid diameter : 750um | Neuron diameter : 15um

![Organoid_150](img/org150u_neur15u_N116.png)
> Organoid diameter : 750um | Neuron diameter : 15um

![Syn_con](img/syn_con_plot.png)
> Example of synaptic connection

## Synaptic connection according to distance

An example of synaptic connectivity rule to promote closer neighbors connection is equated as below :

p = p<sub>con</sub> - p<sub>con</sub> x d<sub>ij</sub> / diam<sub>org</sub>

* p<sub>con</sub> the maximal connectivity probability
* d<sub>ij</sub> the distance between source and target neuron
* diam<sub>org</sub> the diameter of the organoid

When the distance **d<sub>ij</sub>** reaches its maximum value which the organoid diameter **diam<sub>org</sub>**, the division tends to 1 which means that the probability **p** is at lowest value.

![Distance_syn_1n](img/distance_syn_con_1n.png)
> Synaptic connection of one neuron according to distance (linear)
>
> Excitatory (red) | Inhibitory (blue)

![Distance_syn_100n](img/distance_syn_con_100n.png)
> Synaptic connection of 100 neurons according to distance (linear)
>
> Excitatory (red) | Inhibitory (blue)

## Tuning network activity

**Sweep synpatic current weight and connection probability**

The activity of the network can be modified by tuning probability synaptic connectivity as well as the weight of the synaptic current to reproduce behaviors such as network burst.

![Activity2](img/activity2.png)
![Activity1](img/activity1.png)
> Same probability of connection but different synaptic current weight

![HH_sim](img/HH_activity.png)
> Network activity with HH model
>
> FS as inhibitory neuron
> RS as excitatory neuron

**Model different organoid organisations**

Reproduce different organoid connection structures by adding different synaptic connection rules.

![assembloid](img/assembloid_con.jpg)
> Synaptic connection promoting proximity of neurons for assembloid (fused) structure

![assembloid](img/connectoid_con.jpg)
> Synaptic connection promoting location of neurons in the orgnaoid for connectoid structure

![single](img/single_con.jpg)
> Synaptic connection promoting mimicking the absence of synaptic connection between two independent organoids
