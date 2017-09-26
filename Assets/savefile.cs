using UnityEngine;
using System.IO;
//script to save the rotaion about y axis into a txt file
//just add this script to the unity object and give the file name and sampling frequency to record data
public class savefile : MonoBehaviour
{
    public float samplingRate = 1f; // sample rate in Hz
    public string outputFilePath;

    private StreamWriter _sw;

    public void OnEnable()
    {
        _sw = System.IO.File.AppendText(outputFilePath);
        InvokeRepeating("SampleNow", 0, 1 / samplingRate);
    }

    public void OnDisable()
    {
        _sw.Close();
        CancelInvoke();
    }

    public void SampleNow()
    {
        _sw.WriteLine("{0} {1}",Time.time, transform.rotation.y * 180.0f / 3.1415f);
    }
}