using UnityEngine;
using ROSBridgeLib;

public class MyViewer : MonoBehaviour  {
	private ROSBridgeWebSocketConnection ros = null;	

	// the critical thing here is to define our subscribers, publishers and service response handlers
	void Start () {
		
		ros = new ROSBridgeWebSocketConnection ("ws://130.251.13.178", 9090);
        //ros = new ROSBridgeWebSocketConnection("ws://192.168.1.105", 9090);

        ros.AddSubscriber(typeof(SlamPointcloud));
        ros.AddSubscriber(typeof(CameraPose));
        ros.Connect ();	
	}

	// extremely important to disconnect from ROS. OTherwise packets continue to flow
	void OnApplicationQuit() {
		if(ros!=null)
			ros.Disconnect ();
	}
	
	// Update is called once per frame in Unity. 
	void Update () { 	
		ros.Render ();
	}
}
