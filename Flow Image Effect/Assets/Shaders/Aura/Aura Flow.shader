Shader "Aura/Aura Flow"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_FlowTex("Flow Texture", 2D) = "white" {}
		_FlowTexScale("Flow Texture Scale", Vector) = (1, 1, 0, 0)
		_MoveSpeed("Move Speed", Vector) = (0, 0.2, 0, 0.1)
		_FlowAmount("Flow Amount", Float) = 0.3
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			sampler2D _FlowTex;
			float4 _MoveSpeed;
			float4 _FlowTexScale;
			float _FlowAmount;

			uniform float dt;

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col1 = tex2D(_FlowTex, i.uv / _FlowTexScale.xy - _MoveSpeed.xy * _Time[1]);
				float2 flowDirection = (col1.rg - float2(0.5, 0.5)) * 2;
				fixed4 col2 = tex2D(_MainTex, i.uv + (flowDirection * _FlowAmount - _MoveSpeed.zw) * dt);
                return col2;
            }
            ENDCG
        }
    }
}
