using UnityEngine;
using System.Collections;

public class FollowCamera : MonoBehaviour {

	// The target we are following, cube in our case. The cube represents the kinect transform
	public Transform target;
	
	void LateUpdate () {
		Transform target = GameObject.Find ("Cube").transform; //find the cube object in the scene
        //transform the position and orientation according to the poistion and orientation of the cube
		transform.position = target.position;  
        transform.rotation = target.rotation;
	    //make the camera look towards the cube
		transform.LookAt(target);
	}
}
