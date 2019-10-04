using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AuraEffect : MonoBehaviour
{
    [SerializeField]
    private StencilTextureGenerator stencil;

    [SerializeField]
    private Material auraAccumulateMaterial;
    [SerializeField]
    private Material auraFlowMaterial;



    private RenderTexture auraTexture1;
    private RenderTexture auraTexture2;

    Vector4 sampledRegion;



    private void Awake()
    {
        auraTexture1 = new RenderTexture(512, 512, 0);
        auraTexture2 = new RenderTexture(512, 512, 0);
        GetComponent<MeshRenderer>().material.mainTexture = auraTexture1;
    }



    private void Start()
    {
        CalculateSampledRegion();
    }

    
    void Update()
    {
        // face the camera
        transform.rotation = stencil.StencilCam.transform.rotation;


        // Get the stencil image
        RenderTexture stencilTex = stencil.StencilTexture;

        // add it to the texture
        auraAccumulateMaterial.SetTexture("_StencilTex", stencilTex);
        auraAccumulateMaterial.SetVector("_SampledRegion", sampledRegion);
        Graphics.Blit(auraTexture1, auraTexture2, auraAccumulateMaterial);

        // flow the texture
        auraFlowMaterial.SetFloat("dt", Time.deltaTime);
        Graphics.Blit(auraTexture2, auraTexture1, auraFlowMaterial);
        //temp.Release();

        // Find the region to be written to in the next frame
        CalculateSampledRegion();
    }


    private void CalculateSampledRegion()
    {
        Vector2 bottomLeft = stencil.StencilCam.WorldToViewportPoint(transform.TransformPoint(new Vector3(-0.5f, -0.5f, 0)));
        Vector2 topRight = stencil.StencilCam.WorldToViewportPoint(transform.TransformPoint(new Vector3(0.5f, 0.5f, 0)));
        sampledRegion = new Vector4();
        sampledRegion.x = topRight.x - bottomLeft.x;
        sampledRegion.y = topRight.y - bottomLeft.y;
        sampledRegion.z = bottomLeft.x;
        sampledRegion.w = bottomLeft.y;
    }
}
