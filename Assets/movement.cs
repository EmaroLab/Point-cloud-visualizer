using UnityEngine;
using System.Collections;

public class movement : MonoBehaviour {
    float speed = 1.0f;

    void Update()
    {
        var move = new Vector3(Input.GetAxis("Horizontal"), 0,Input.GetAxis("Vertical"));
        transform.position += move * speed * Time.deltaTime;
        if (Input.GetKey("left"))
        {
            transform.Rotate(0, -.5f, 0);
        }
        if (Input.GetKey("right"))
        {
            transform.Rotate(0, .5f, 0);
        }
    }
}
