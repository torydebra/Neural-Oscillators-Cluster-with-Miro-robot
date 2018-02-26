# Neural synchronization to detect and classify tactile behaviours with miro

MiRo is a small pet-like robot intended to be a companion. It is provided with a matrix	of tactile sensors on its head and its back. 
The values of these tactile sensors are acquired via a ROS-based subscriber communication	channel. The goal of this	assignment is to process touch patterns	using synchronised neural oscillators, each	one	coupled	with a specific tactile sensor.
When close tactile sensors are excited with	similar	stimuli, the corresponding neural oscillators become synchronised (i.e., they are	coupled) and their values are used to understand the touch pattern on Miro.

### Accomplishments
- Create a simple ROS subscriber that received data from Miro sensors and save things on a file
- Mapped Miro sensors "flatting" his body. This is needed to understand which sensors must be syncronized (if they are active). The map is created mesauring distance of Miro sensor and writing them in the MiroMap.txt file
<p align="center"> 
<img src="https://user-images.githubusercontent.com/26459008/36688969-5b54e87a-1b2e-11e8-932a-54776562864f.jpg">
</p>
- Modify the matlab code according to our case 
  - Simplified "main" SlotineExperiment
  - Modified readMap to read MiroMap.txt
  - Modified ReadInput and ActiveOscillators according to Miro sensors.
- Create findSyncronizations.m function to understand which sensors are coupled between them, starting from the values of the curves


### Limitations of the system:
With findSyncronizations everything work well for simple activation sequences.
With more complex pattern (touch both head and body) it finds almost every time right clusters of touched sensor (it divides 		correctly head oscillators and body oscillators into 2 different groups). But sometimes it find false syncronizations (coupled 		oscillators that aren't really coupled), due to the fact that we take unfortunate values of the curves.
We try taking 3,5,9 values (and make the average) of each curve for each step (a step is a row in the activation sequence) in 		different parts of the step:
- on the whole step time (at the moment the best way)
- only on the second half of the step time (to wait for curves to assestate well)
- near the maximum of an activated sensor (because the point where the curves are more different is near the maximum)
- at a random 
 

### Modules/Files in the system
- listenerMiro.cpp (Ros subscriber to store values from Miro sensor)
- Matlab functions (SlotineExperiment.m is the main)

 
### How to run the application
There are already touch pattern taken with listenerMiro.cpp inside matlab/activation_sequence. Otherwise, one can use listenerMiro node to make new ones.
With Matlab, run SlotineExperiment.m (this is the main) inside each function there is the possibility to show more figures uncommenting part of the code


### Credits 
Davide Torielli & Fabio Fusaro For the "Software Architectures for Robotics" course 2017/2018

Starting from code of Fulvio Mastrogiovanni (aims at validating the experiment in the Wang's and Slotine's paper; Last modified on July 19, 2010)
And modified by Barbara Bruno & Jorhabib E. Gomez (for the "Software Architectures for Robotics" course 2010/2011)
