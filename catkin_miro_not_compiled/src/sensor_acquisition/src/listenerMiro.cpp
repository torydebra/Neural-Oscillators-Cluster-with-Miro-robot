#include "ros/ros.h"
#include "std_msgs/String.h"
#include "sensor_acquisition/platform_sensors_msg.h" /**auto generated .h by gencpp. it is inside devel/include*/
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

ros::Time start;
ofstream outputFile;

/**
 * This function is called when a message from Miro's sensors arrives.
 * Check if almost one sensor is excited. If yes it prints a row in outputFile
 * subdivided in 10 columns:
 * 	 [timestamp]
 *   number of sensors excited (always >0)
 * 	 0(not excited) or 1(excited) for head[0] (behind right ear)
 *   0(not excited) or 1(excited) for head[1] (above right eye)
 *   0(not excited) or 1(excited) for head[2] (above left eye)
 *   0(not excited) or 1(excited) for head[3] (behind left ear)
 *   0(not excited) or 1(excited) for body[0] (near tail)
 *   0(not excited) or 1(excited) for body[1]
 *   0(not excited) or 1(excited) for body[2]
 *   0(not excited) or 1(excited) for body[3] (near head)
 *
 * Argument:
 * const sensor_acquisition::platform_sensors_msg &msg : message received by Miro
 */
void chatterCallback(const sensor_acquisition::platform_sensors_msg &msg)
{
	int counter = 0;
	int head[4];
	int body[4];

  for(int i=0; i<4;i++){
		if (msg.touch_head[i] == 1){
			counter++;
		}
		if (msg.touch_body[i] == 1){
			counter++;
		}
  }

  if (counter != 0){
		ros::Time now = ros::Time::now();
		outputFile << "[" << now-start << "]\t" << counter << "\t";
		cout << "[" << now-start << "]\t" << counter << "\t";

		for(int i=0; i<4;i++){
			printf("%d ", msg.touch_head[i]);

			head[i] = msg.touch_head[i];
			outputFile << head[i] << "\t";

		}

		for(int i=0; i<4;i++){
			printf("%d ", msg.touch_body[i]);
			body[i] = msg.touch_body[i];
			outputFile << body[i] << "\t";

		}

		printf("\n");
		outputFile << "\n";
	}
}


/**
 * Open the outputFile, start the timestamp and create the subscriber node
 *
 * Argument:
 * name of the outputFile (which is created if doesn't exist or updated if it exists)
 */
int main(int argc, char **argv)
{

	if (argc <= 1){

		cout << "Insert file name\n";
		return -1;
	}

	string name = argv[1];
	string destination = "matlab/activation_seq/" + name;


  outputFile.open (destination.c_str(), ios::out | ios::app);
  if (! outputFile.is_open())
  {
		cout << "ERROR opening file";
		return -1;
  }

  ros::init(argc, argv, "listenerMiro");

  ros::NodeHandle n;
  start = ros::Time::now();

  ros::Subscriber sub = n.subscribe("/miro/rob01/platform/sensors", 1000, chatterCallback);

  ros::spin();

	outputFile.close();

  return 0;
}
