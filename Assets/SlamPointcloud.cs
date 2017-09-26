using ROSBridgeLib;
using PointCloud;
using ROSBridgeLib.sensor_msgs;
using SimpleJSON;
using UnityEngine;
using System.Collections.Generic;
[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]

//this is an extension of the ROSBridgeSubscriber class and makes a subscriber for getting pointcloud messages from a rostopic
// it takes the point cloud data receieved by the web socket and generates a voxel/cube on each point
public class SlamPointcloud : ROSBridgeSubscriber
{
    public static string Mesh_name = "cloud"; //giving our mesh a name for easy access
    public static Material Vertex_material; //material is required to color the mesh
    public static int total_meshes; //number of meshes generated
    public static List<Vector3> vertices; //list of mesh vertices
    public static List<int> triangles; //list of mesh triangles
    public static List<Color> col; //list of mesh colors
    public static float adjScale; //variable to adjust size of voxel/cube in mesh
    public static int Points_limit = 65000/(4*6); //unity can only render 65000 points per mesh, a cube takes up 4*6 points
    public static int numPoints; //total number of points in a mesh
    public static GameObject main_mesh; //unity object of our parent mesh
    public static Vector3[] mpoints; //array of out pointcloud points
    public static Color[] colors; //array of our point cloud colors

    public new static string GetMessageTopic()
    {
        return "/rtabmap/cloud_map"; //name of the rostopic subscribed
    }

    public new static string GetMessageType()
    {
        return "sensor_msgs/PointCloud2"; //type of the rostopic subscribed
    }

    public new static ROSBridgeMsg ParseMessage(JSONNode msg)
    {
        return new PointCloud2Msg(msg);
    }

    public static void CallBack(ROSBridgeMsg msg) //after receiving the ros message
    {
        PointCloud2Msg cloudm = (PointCloud2Msg)msg; //point cloud message
        PointCloud<PointXYZRGB> points = cloudm.GetCloud();// get data, the data has point location and point color information
        PointXYZRGB point; //variable to access information of single point in the list of points

        //voxel mesh with triangles
        numPoints = points.Size; //number of points received
        mpoints = new Vector3[numPoints];
        colors = new Color[numPoints];

        //store points and colors of the point cloud separately in arrays
        for (int i = 0; i < numPoints; i++)
        {
            point = points.At(i); //point at index i in the list
            mpoints[i] = new Vector3(point.X, point.Z, point.Y);
            colors[i] = new Color(point.R / 255.0f, point.G / 255.0f, point.B / 255.0f);
        }
        // generate child meshes
        total_meshes = Mathf.CeilToInt(numPoints * 1.0f / Points_limit * 1.0f); //calculate the number of child meshes required
        main_mesh = GameObject.Find(Mesh_name); //find the mesh in unity environment

        if (main_mesh == null)
            main_mesh = new GameObject(Mesh_name); //if no mesh found, create one
        else
        {
            //do nothing
        }
        //initialize the mesh
        for (int i = 0; i < total_meshes - 1; i++)
        {
           Mesh_initialization(i, Points_limit);
        }
        Mesh_initialization(total_meshes - 1, numPoints - (total_meshes - 1) * Points_limit);
    }
    //fnction for mesh initialization
    public static void Mesh_initialization(int meshInd, int nPoints)
    {
        GameObject child_mesh = GameObject.Find(Mesh_name + meshInd); //find gameobject in unity for the child mesh

        if (child_mesh == null)
        {
            child_mesh = new GameObject(Mesh_name + meshInd); //if not found create an object of child mesh with its index
            // a mesh requires a mesh filter and a mesh renderer
            child_mesh.AddComponent<MeshFilter>();
            child_mesh.AddComponent<MeshRenderer>();
        }
        else
        {
           //do nothing
        }
        adjScale = 0.020f; //scale of the voxel/cube can be changed here
        Vertex_material = new Material(Shader.Find("Custom/VertexColor")); //vertex color shader shades the vertices, we have to give the shader to the material
        child_mesh.GetComponent<Renderer>().material = Vertex_material; //assign the material to renderer
        child_mesh.GetComponent<MeshFilter>().mesh = CreateMesh(meshInd, nPoints, Points_limit); //create mesh and get mesh filter
        child_mesh.transform.parent = main_mesh.transform; //mesh transform
       
    }
    // function to create mesh
    public static Mesh CreateMesh(int id, int nPoints, int Points_limit)
    {
        //initializations
        Mesh mesh = new Mesh();
        triangles = new List<int>();
        vertices = new List<Vector3>();
        col = new List<Color>();
        Vector3[] myPoints = new Vector3[nPoints];
        Color[] myColors = new Color[nPoints];


        //child mesh point cloud data
        for (int i = 0; i < nPoints; ++i)
        {
            myPoints[i] = mpoints[id * Points_limit + i]; 
            myColors[i] = colors[id * Points_limit + i];
            MakeCube(adjScale, myPoints[i], myColors[i]); //make cube at each point of the child mesh point cloud data
        }

        //creating mesh
        mesh.Clear();
        mesh.vertices = vertices.ToArray();
        mesh.triangles = triangles.ToArray();
        mesh.colors = col.ToArray();
        mesh.RecalculateNormals();
      
        return mesh;
    }
    public static void MakeFace(int dir, float faceScale, Vector3 facePos)
    {
        vertices.AddRange(CubeMeshData.faceVertices(dir, faceScale, facePos)); //add this range of vertices to the vertices list
        int vertCount = vertices.Count;
        //the initial number of vertices is 4 so subtract 4 from the vertex count
        //the clockwise direction to build the mesh triangles is 0,1,2 (one triangle of the quad face) and 0,2,3 (second triangle of face)
        triangles.Add(vertCount - 4 + 0);
        triangles.Add(vertCount - 4 + 1);
        triangles.Add(vertCount - 4 + 2);
        triangles.Add(vertCount - 4 + 0);
        triangles.Add(vertCount - 4 + 2);
        triangles.Add(vertCount - 4 + 3);
    }
    public static void MakeCube(float cubeScale, Vector3 cubePos, Color colo)
    {
        //make face for 6 faces of the cube
        for (int i = 0; i < 6; i++)
        {

            MakeFace(i, cubeScale, cubePos);
            //one cube has one color
            for (int j = 0; j < 4; j++)
            {
                col.Add(colo); //update color list for the mesh
            }

        }

    }

}

