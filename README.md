# Neural synchronization to detect and classify tactile behaviours with MiRo

MiRo is a small pet-like robot intended to be a companion. It is provided with a matrix	of tactile sensors on its head and its back. 
The values of these tactile sensors are acquired via a ROS-based subscriber communication	channel. The goal of this	assignment is to process touch patterns	using synchronised neural oscillators, each	one	coupled	with a specific tactile sensor.
When close tactile sensors are excited with	similar	stimuli, the corresponding neural oscillators become synchronised (i.e., they are	coupled) and their values are used to understand the touch pattern on MiRo.

### Accomplishments
- Create a simple ROS subscriber that received data from MiRo sensors and save things on a file
- Mapped MiRo sensors "flatting" his body. This is needed to understand which sensors are near and so which ones must be syncronized (if they are active). The map is created mesauring distances of MiRo sensors and writing them in the MiroMap.txt file
<p align="center"> 
<img src="https://user-images.githubusercontent.com/26459008/36801857-7e9bd47a-1cb3-11e8-9eb3-f716f2d8bddf.jpg">
</p>

- Modify the matlab code according to our case 
  - Simplified "main" SlotineExperiment
  - Modified readMap to read MiroMap.txt
  - Modified ReadInput and ActiveOscillators according to MiRo sensors.
- Create findSyncronizations.m function to understand which sensors are coupled between them, starting from the values of the curves
<p align="center"> 
<img src="https://user-images.githubusercontent.com/26459008/36801866-85a66ad2-1cb3-11e8-9d2b-1360bafdfa0b.jpg">
</p>

In this figure are represented the neural oscillators responses (only the activated ones at least once in the pattern).
This is a zoom in steps 97-98-99 (x label is multiplied by tf that is 100). We see 2 clusters: the curve in blue is in reality two curves overlying each other.

<p align="center"> 
<img src="https://user-images.githubusercontent.com/26459008/36802543-7c5c73ac-1cb5-11e8-88ae-1517dd13cabe.jpg">
</p>
In this figure we see a heatMap of the syncroMatrix that gives for each step (each row) which sensors are not activated (gray) and which ones are activated (colored). Different colors correspond to different clusters. In this case we used the method 4 (9 observations from three maximum) and it is possible see the few errors. 


### Limitations of the system:
With findSyncronizations everything work well for simple activation sequences.
With more complex pattern (touch both head and body) it finds almost every time right clusters of touched sensors.
Sometimes it finds false syncronizations (coupled oscillators that aren't really coupled, and not coupled ones that are shown as coupled), due to the fact that we take unfortunate values of the curves.
We try taking 5,9 values (and make the average) of each curve for each step (a step is a row in the activation sequence) in different parts of the step and with different method (changeable as input of findSyncronization.m. Also the percentage error to say if sensors are coupled is settable):
1. Five observations on the whole step time (dividing it into equal subTimes)
2. Nine observations on the whole step time (dividing it into equal subTimes)
3. Five observations only on the second half of the step time (to wait for curves to assestate well)
4. Nine observations. We take three maximums for the first activated curve and we observe the curves taking three near values for each maximum. This is actual the method which gives less errors because the points where the curves are more different are near the maximums.
5. Nine observations in random times of the step
 

### Modules/Files in the system
- listenerMiro.cpp node of the sensor\_acquisition package inside src\/sensor_acquisition\/src (Ros subscriber to store values from MiRo sensors)
- Matlab functions inside matlab folder (SlotineExperiment.m is the main)
- Inside doc folder there are matlab publish outputs of each function and doxygen for listenerMiro.cpp

 
### How to run the application
There are already touch patterns taken with listenerMiro.cpp inside matlab/activation\_sequence, and also the txt file with the coordinate of the MiRo's sensors
With Matlab, run SlotineExperiment.m (this is the main). If you want you can change here something:
- To change activation sequence, specify it as argument of ReadInput function
- As argument of ActivateOscillators you can change ti and tf (the smaller their range is, the more the errors could increase because curves have less time to assestate in each step). You can also change step if you want to take only some rows of the activation sequence chosen
- Inside each function there is the possibility to show more figures uncommenting final parts of the code

If you want to acquire new patter with MiRo, you need to compile and execute listenerMiro node:
- Be sure to have ROS installed in your system and to have setuped correctly your pc to communicate with MiRo (find instruction on [MiRo website](https://consequential.bitbucket.io/Developer_Preparation.html)
- inside catkin\_miro folder use catkin\_make 
- run roscore then, in another terminal, write command source ./devel/setup.bash
- launch node with "rosrun sensor\_acquisition listener\_Miro \<name of activation sequence you want\>

### Credits 
Davide Torielli & Fabio Fusaro For the "Software Architectures for Robotics" course 2017/2018

Starting from code of Fulvio Mastrogiovanni (aims at validating the experiment in the Wang's and Slotine's paper; Last modified on July 19, 2010)
And modified by Barbara Bruno & Jorhabib E. Gomez (for the "Software Architectures for Robotics" course 2010/2011)
