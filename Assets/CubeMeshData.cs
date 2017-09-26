using UnityEngine;
//ata required to create a single voxel/cube
public static class CubeMeshData {

    //the eight vertices of the cube
    public static Vector3[] vertices =
    {
        // (0,0,0) is the center of the cube
        //the four vertices on z side of cube
        new Vector3(1,1,1),
        new Vector3(-1,1,1),
        new Vector3(-1,-1,1),
        new Vector3(1,-1,1),

        //the four vertices on -z side of cube
        new Vector3(-1,1,-1),
        new Vector3(1,1,-1),
        new Vector3(1,-1,-1),
        new Vector3(-1,-1,-1)
    };
    //triangles for full face
    public static int[][] faceTriangles = 
    {
        //the vertices are joined in clockwise direction 
        //because in unity the triangles with clockwise rotation
        //side are visible
        new int[] {0,1,2,3}, //+z face
        new int[] {5,0,3,6}, //+x face
        new int[] {4,5,6,7},//-z face
        new int[] {1,4,7,2}, //-x face
        new int[] {5,4,1,0}, //+y face
        new int[] {3,2,7,6} //-y face
    };
    //returns the 4 virtices corresponding to direction +z,-z,+x,-x,+y,-y
    public static Vector3[] faceVertices(int dir, float scale,Vector3 pos)
    {
        Vector3[] fv = new Vector3[4];
        for(int i=0;i<fv.Length;i++)
        {
            fv[i] = (vertices[faceTriangles[dir][i]]*scale)+ pos;

        }
        return fv; //returns the array of the vertices on the face
    }

}
