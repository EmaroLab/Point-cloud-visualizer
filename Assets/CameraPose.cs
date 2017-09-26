using ROSBridgeLib;
using ROSBridgeLib.nav_msgs;
using ROSBridgeLib.geometry_msgs;
using SimpleJSON;
using UnityEngine;

//this is an extension of the ROSBridgeSubscriber class and makes a subscriber for getting odometry messages from a rostopic
//get the position and orientation of the kinect through ros message
public class CameraPose : ROSBridgeSubscriber {
	
	public new static string GetMessageTopic() {
		return "/rtabmap/odom"; //name of the rostopic subscribed
	}  
	
	public new static string GetMessageType() {
		return "nav_msgs/Odometry"; //type of the rostopic subscribed
	}
	
	public new static ROSBridgeMsg ParseMessage(JSONNode msg) {
        return new OdometryMsg(msg); //Parse the message received from websocket
	}
	//callback functions is called whenever the message is received

	public static void CallBack(ROSBridgeMsg msg) {

		GameObject cube_obj = GameObject.Find ("Cube"); 
		if (cube_obj == null)
			Debug.Log ("Cube not found!!!");
		else {
			OdometryMsg odom = (OdometryMsg)msg; 
            PoseWithCovarianceMsg posemsg = odom._pose; 
            PoseMsg pose = posemsg.GetPose(); // get the pose part of the odometry message
           
            //move the cube in the scene along with the kinect which is on top of the robot

			cube_obj.transform.position = new Vector3(pose._position.GetX(), pose._position.GetZ(), pose._position.GetY());
            cube_obj.transform.rotation = Quaternion.Euler(-pose._orientation.GetX() * 180.0f / 3.1415f, -pose._orientation.GetZ() * 180.0f / 3.1415f,- pose._orientation.GetY() * 180.0f / 3.1415f);
        }
	}
}
