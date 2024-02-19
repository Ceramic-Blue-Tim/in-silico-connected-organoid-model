# Sources overview

* **sim_organoid.m** : main simulation script organoid HH allowing emulation of single, assembloid (fused) and connectoid structures
* **hh_network/org_tools/**
  * **syncon_assembloid.m** : fill synaptic connectivity matrix according to distance between neurons
  * **syncon_connectoid.m** : fill synaptic connectivity matrix according to position of neuron in organoid (surface or inside)
  * **syncon_single.m** : fill synaptic connectivity matrix according to distance between neurons
  * **XY_placement.m** : assign XY coordinates to neurons
* **tests/**
  * **FS_x3.m** : 3 FS neurons connected by Destexhe synapses
  * **RS_x3.m** : 3 FS neurons connected by Destexhe synapses
  * **test_Hillsyn.m** : test script for spike-mediated synapses
  * **test_optostim.m** : test script ChRd2 optogenetic stimulation