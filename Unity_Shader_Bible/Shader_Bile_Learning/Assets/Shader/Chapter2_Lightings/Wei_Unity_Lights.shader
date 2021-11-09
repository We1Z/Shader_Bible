Shader "Unlit/Wei_Lightings"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float3 normal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;


            void unity_light(in float3 normals, out float Out)
            {
                Out = [Op] (normals);
            }

            // lets create a new function
            half3 normalWorld(half3 normal)
            {
                return normalize(mul(unity_ObjectToWorld, float4(normal,0))).xyz;
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.normal = v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // store the normals in a vector
                half3 normals = normalWorld(i.normal);
                // initialize our light in black
                half3 light = 0
                // initialize our function and pass the vectors
                unity_light(normals, light);



                return float4 (light.rgb, 1);
            }
            ENDCG
        }
    }
}
