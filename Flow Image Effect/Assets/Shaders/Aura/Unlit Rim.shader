Shader "Unlit/Unlit Rim"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

		_TintColor ("Tint Color", Color) = (1, 1, 1, 1)
		_FresnelExponent("Fresnel Exponent", Float) = 2
    }
    SubShader
    {
		Tags {"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		LOD 100

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

				float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;

				float3 normal : NORMAL;
				float3 viewDir : VIEWDIR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _TintColor;
			float _FresnelExponent;

            v2f vert (appdata v)
            {
                v2f o;

				v.vertex += float4(v.normal.rgb, 0) * 0.001;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);

				o.normal = v.normal;
				o.viewDir = ObjSpaceViewDir(v.vertex);



                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float fresnel = 1 - saturate(dot(i.normal, normalize(i.viewDir)));
				fresnel = pow(fresnel, _FresnelExponent);
				fixed4 col = fixed4(_TintColor.rgb, fresnel);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);

                return col;
            }
            ENDCG
        }
    }
}
